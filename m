Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:33058 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751407Ab1LTGI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 01:08:27 -0500
Date: Tue, 20 Dec 2011 11:38:22 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/2] mwl8k: Recover from firmware crash
Message-ID: <20111220060809.GA4624@hertz.marvell.com> (sfid-20111220_070830_518607_29AE4501)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of firmware crash, reload the firmware and reconfigure it
by triggering ieee80211_hw_restart; mac80211 utility function.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  122 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 901cd79..241216c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -262,6 +262,11 @@ struct mwl8k_priv {
 	 */
 	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_WMM_QUEUES];
 
+	/* To do the task of reloading the firmware */
+	struct work_struct fw_reload;
+
+	atomic_t  hw_reload_state;
+
 	/* async firmware loading state */
 	unsigned fw_state;
 	char *fw_pref;
@@ -485,6 +490,14 @@ enum {
 	FW_STATE_ERROR,
 };
 
+/* FW reload states */
+enum {
+	FW_RELOAD_INIT = 0,
+	FW_RELOAD_TEST,
+	FW_RELOAD_ALL_BLOCK,
+	FW_RELOAD_FINAL,
+};
+
 /* Request fw image */
 static int mwl8k_request_fw(struct mwl8k_priv *priv,
 			    const char *fname, const struct firmware **fw,
@@ -1516,6 +1529,9 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		oldcount = priv->pending_tx_pkts;
 
+		if (!atomic_read(&priv->hw_reload_state))
+			atomic_set(&priv->hw_reload_state, FW_RELOAD_TEST);
+
 		spin_unlock_bh(&priv->tx_lock);
 		timeout = wait_for_completion_timeout(&tx_wait,
 			    msecs_to_jiffies(MWL8K_TX_WAIT_TIMEOUT_MS));
@@ -1540,7 +1556,12 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		wiphy_err(hw->wiphy, "tx rings stuck for %d ms\n",
 			  MWL8K_TX_WAIT_TIMEOUT_MS);
-		mwl8k_dump_tx_rings(hw);
+
+		if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_TEST) {
+			mwl8k_dump_tx_rings(hw);
+			atomic_set(&priv->hw_reload_state, FW_RELOAD_ALL_BLOCK);
+			ieee80211_queue_work(hw, &priv->fw_reload);
+		}
 
 		rc = -ETIMEDOUT;
 	}
@@ -1626,6 +1647,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		BUG_ON(txq->len == 0);
 		txq->len--;
 		priv->pending_tx_pkts--;
+		if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_TEST)
+			atomic_set(&priv->hw_reload_state, FW_RELOAD_INIT);
 
 		addr = le32_to_cpu(tx_desc->pkt_phys_addr);
 		size = le16_to_cpu(tx_desc->pkt_len);
@@ -1827,6 +1850,16 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	bool mgmtframe = false;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
+	if (atomic_read(&priv->hw_reload_state) > FW_RELOAD_TEST) {
+		/*
+		 * If fw reload is going on there is no point
+		 * in sending the packets down to the firmware.
+		 * Free the packets
+		 */
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	wh = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_data_qos(wh->frame_control))
 		qos = le16_to_cpu(*((__le16 *)ieee80211_get_qos_ctl(wh)));
@@ -2102,6 +2135,13 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	unsigned long timeout = 0;
 	u8 buf[32];
 
+	if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_ALL_BLOCK) {
+		wiphy_err(hw->wiphy, "Not executing command %s since "
+				"firmware reload is in progress\n",
+				mwl8k_cmd_name(cmd->code, buf, sizeof(buf)));
+		return -EBUSY;
+	}
+
 	cmd->result = (__force __le16) 0xffff;
 	dma_size = le16_to_cpu(cmd->length);
 	dma_addr = pci_map_single(priv->pdev, cmd, dma_size,
@@ -4382,6 +4422,8 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		mwl8k_fw_unlock(hw);
 	}
 
+	ieee80211_wake_queues(hw);
+
 	if (rc) {
 		iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 		free_irq(priv->pdev->irq, hw);
@@ -4510,8 +4552,10 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 
 	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
 
-	priv->macids_used &= ~(1 << mwl8k_vif->macid);
-	list_del(&mwl8k_vif->list);
+	if (priv->macids_used) {
+		priv->macids_used &= ~(1 << mwl8k_vif->macid);
+		list_del(&mwl8k_vif->list);
+	}
 }
 
 static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
@@ -5261,6 +5305,29 @@ fail:
 	complete(&priv->firmware_loading_complete);
 	device_release_driver(&priv->pdev->dev);
 	mwl8k_release_firmware(priv);
+	atomic_set(&priv->hw_reload_state, FW_RELOAD_INIT);
+}
+
+static void  mwl8k_reload_fw_work(struct work_struct *work)
+{
+	struct mwl8k_priv *priv =
+			container_of(work, struct mwl8k_priv, fw_reload);
+
+	struct ieee80211_hw *hw = priv->hw;
+	struct mwl8k_device_info *di;
+
+	di = priv->device_info;
+
+	/* If some command is waiting for a response, clear it */
+	if (priv->hostcmd_wait != NULL)
+		complete(priv->hostcmd_wait);
+
+	if (mwl8k_reload_firmware(hw, di->fw_image_ap))
+		wiphy_err(hw->wiphy, "Firmware reloading failed\n");
+	else
+		wiphy_err(hw->wiphy, "Firmware restarted successfully\n");
+
+	return;
 }
 
 static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
@@ -5268,6 +5335,8 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
+#define MAX_RESATRT_ATTEMEPT_COUNT	5
+	static int restart_count;
 
 	/* Reset firmware and hardware */
 	mwl8k_hw_reset(priv);
@@ -5290,6 +5359,23 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
 	/* Reclaim memory once firmware is successfully loaded */
 	mwl8k_release_firmware(priv);
 
+	if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_ALL_BLOCK) {
+		if (rc) {
+			/* FW did not start successfully;
+			 * lets try it some more time
+			 */
+			if (++restart_count < MAX_RESATRT_ATTEMEPT_COUNT) {
+				wiphy_err(hw->wiphy, "Re-trying %d time\n",
+								restart_count);
+				msleep(20);
+				rc = mwl8k_init_firmware(hw, fw_image, nowait);
+			}
+		} else {
+			restart_count = 0;
+			atomic_set(&priv->hw_reload_state, FW_RELOAD_FINAL);
+		}
+	}
+
 	return rc;
 }
 
@@ -5365,7 +5451,14 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		goto err_free_queues;
 	}
 
-	memset(priv->ampdu, 0, sizeof(priv->ampdu));
+	/*
+	 * When hw restart is requested,
+	 * mac80211 will take care of clearing
+	 * the ampdu streams, so do not clear
+	 * the ampdu state here
+	 */
+	if (atomic_read(&priv->hw_reload_state) != FW_RELOAD_FINAL)
+		memset(priv->ampdu, 0, sizeof(priv->ampdu));
 
 	/*
 	 * Temporarily enable interrupts.  Initial firmware host
@@ -5431,18 +5524,20 @@ err_stop_firmware:
 	return rc;
 }
 
-/*
- * invoke mwl8k_reload_firmware to change the firmware image after the device
- * has already been registered
- */
 static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 {
 	int i, rc = 0;
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mwl8k_vif, *tmp_vif;
 
 	mwl8k_stop(hw);
 	mwl8k_rxq_deinit(hw, 0);
 
+	list_for_each_entry_safe(mwl8k_vif, tmp_vif, &priv->vif_list, list) {
+		priv->macids_used &= ~(1 << mwl8k_vif->macid);
+		list_del(&mwl8k_vif->list);
+	}
+
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 
@@ -5454,6 +5549,12 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 	if (rc)
 		goto fail;
 
+	if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_FINAL) {
+		ieee80211_restart_hw(hw);
+		atomic_set(&priv->hw_reload_state, FW_RELOAD_INIT);
+		return 0;
+	}
+
 	rc = mwl8k_start(hw);
 	if (rc)
 		goto fail;
@@ -5472,6 +5573,8 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 
 fail:
 	printk(KERN_WARNING "mwl8k: Failed to reload firmware image.\n");
+	atomic_set(&priv->hw_reload_state, FW_RELOAD_ALL_BLOCK);
+
 	return rc;
 }
 
@@ -5524,6 +5627,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 	/* Handle watchdog ba events */
 	INIT_WORK(&priv->watchdog_ba_handle, mwl8k_watchdog_ba_events);
+	/* To reload the firmware if it crashes */
+	INIT_WORK(&priv->fw_reload, mwl8k_reload_fw_work);
 
 	/* TX reclaim and RX tasklets.  */
 	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
@@ -5624,7 +5729,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->pdev = pdev;
 	priv->device_info = &mwl8k_info_tbl[id->driver_data];
 
-
 	priv->sram = pci_iomap(pdev, 0, 0x10000);
 	if (priv->sram == NULL) {
 		wiphy_err(hw->wiphy, "Cannot map device SRAM\n");
-- 
1.7.5.4

