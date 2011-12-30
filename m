Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:43207 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752534Ab1L3LQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 06:16:35 -0500
Date: Fri, 30 Dec 2011 16:35:27 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH V2] mwl8k: Recover from firmware crash
Message-ID: <20111230110515.GA23198@hertz.marvell.com> (sfid-20111230_121639_469094_61A4C050)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of firmware crash, reload the firmware and reconfigure it
by triggering ieee80211_hw_restart; mac80211 utility function.

V2 Addressed following comments from Lennert:
 - Stop the queues during reload
 - Removed atomic_t declaration for hw_restart
 - Extend the firmware reload support for sta firmware as well
 - Other misc changes

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  136 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 129 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 901cd79..cf69271 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -198,6 +198,7 @@ struct mwl8k_priv {
 	/* firmware access */
 	struct mutex fw_mutex;
 	struct task_struct *fw_mutex_owner;
+	struct task_struct *hw_restart_owner;
 	int fw_mutex_depth;
 	struct completion *hostcmd_wait;
 
@@ -262,6 +263,10 @@ struct mwl8k_priv {
 	 */
 	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_WMM_QUEUES];
 
+	/* To perform the task of reloading the firmware */
+	struct work_struct fw_reload;
+	bool hw_restart_in_progress;
+
 	/* async firmware loading state */
 	unsigned fw_state;
 	char *fw_pref;
@@ -1498,6 +1503,18 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 	might_sleep();
 
+	/* Since fw restart is in progress, allow only the firmware
+	 * commands from the restart code and block the other
+	 * commands since they are going to fail in any case since
+	 * the firmware has crashed
+	 */
+	if (priv->hw_restart_in_progress) {
+		if (priv->hw_restart_owner == current)
+			return 0;
+		else
+			return -EBUSY;
+	}
+
 	/*
 	 * The TX queues are stopped at this point, so this test
 	 * doesn't need to take ->tx_lock.
@@ -1541,6 +1558,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		wiphy_err(hw->wiphy, "tx rings stuck for %d ms\n",
 			  MWL8K_TX_WAIT_TIMEOUT_MS);
 		mwl8k_dump_tx_rings(hw);
+		priv->hw_restart_in_progress = true;
+		ieee80211_queue_work(hw, &priv->fw_reload);
 
 		rc = -ETIMEDOUT;
 	}
@@ -2058,7 +2077,9 @@ static int mwl8k_fw_lock(struct ieee80211_hw *hw)
 
 		rc = mwl8k_tx_wait_empty(hw);
 		if (rc) {
-			ieee80211_wake_queues(hw);
+			if (!priv->hw_restart_in_progress)
+				ieee80211_wake_queues(hw);
+
 			mutex_unlock(&priv->fw_mutex);
 
 			return rc;
@@ -2077,7 +2098,9 @@ static void mwl8k_fw_unlock(struct ieee80211_hw *hw)
 	struct mwl8k_priv *priv = hw->priv;
 
 	if (!--priv->fw_mutex_depth) {
-		ieee80211_wake_queues(hw);
+		if (!priv->hw_restart_in_progress)
+			ieee80211_wake_queues(hw);
+
 		priv->fw_mutex_owner = NULL;
 		mutex_unlock(&priv->fw_mutex);
 	}
@@ -4398,7 +4421,8 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	mwl8k_cmd_radio_disable(hw);
+	if (!priv->hw_restart_in_progress)
+		mwl8k_cmd_radio_disable(hw);
 
 	ieee80211_stop_queues(hw);
 
@@ -4499,6 +4523,16 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void mwl8k_remove_vif(struct mwl8k_priv *priv, struct mwl8k_vif *vif)
+{
+	/* Has ieee80211_restart_hw re-added the removed interfaces? */
+	if (!priv->macids_used)
+		return;
+
+	priv->macids_used &= ~(1 << vif->macid);
+	list_del(&vif->list);
+}
+
 static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -4510,8 +4544,54 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 
 	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
 
-	priv->macids_used &= ~(1 << mwl8k_vif->macid);
-	list_del(&mwl8k_vif->list);
+	mwl8k_remove_vif(priv, mwl8k_vif);
+}
+
+static void mwl8k_hw_restart_work(struct work_struct *work)
+{
+	struct mwl8k_priv *priv =
+		container_of(work, struct mwl8k_priv, fw_reload);
+	struct ieee80211_hw *hw = priv->hw;
+	struct mwl8k_device_info *di;
+	int rc;
+
+	/* If some command is waiting for a response, clear it */
+	if (priv->hostcmd_wait != NULL) {
+		complete(priv->hostcmd_wait);
+		priv->hostcmd_wait = NULL;
+	}
+
+	priv->hw_restart_owner = current;
+	di = priv->device_info;
+	mwl8k_fw_lock(hw);
+
+	if (priv->ap_fw)
+		rc = mwl8k_reload_firmware(hw, di->fw_image_ap);
+	else
+		rc = mwl8k_reload_firmware(hw, di->fw_image_sta);
+
+	if (rc)
+		goto fail;
+
+	priv->hw_restart_owner = NULL;
+	priv->hw_restart_in_progress = false;
+
+	/*
+	 * This unlock will wake up the queues and
+	 * also opens the command path for other
+	 * commands
+	 */
+	mwl8k_fw_unlock(hw);
+
+	ieee80211_restart_hw(hw);
+
+	wiphy_err(hw->wiphy, "Firmware restarted successfully\n");
+
+	return;
+fail:
+	mwl8k_fw_unlock(hw);
+
+	wiphy_err(hw->wiphy, "Firmware restart failed\n");
 }
 
 static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
@@ -5024,7 +5104,11 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		for (i = 0; i < MAX_AMPDU_ATTEMPTS; i++) {
 			rc = mwl8k_check_ba(hw, stream);
 
-			if (!rc)
+			/* If HW restart is in progress mwl8k_post_cmd will
+			 * return -EBUSY. Avoid retrying mwl8k_check_ba in
+			 * such cases
+			 */
+			if (!rc || rc == -EBUSY)
 				break;
 			/*
 			 * HW queues take time to be flushed, give them
@@ -5263,12 +5347,15 @@ fail:
 	mwl8k_release_firmware(priv);
 }
 
+#define MAX_RESTART_ATTEMPTS 1
 static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
 			       bool nowait)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
+	int count = MAX_RESTART_ATTEMPTS;
 
+retry:
 	/* Reset firmware and hardware */
 	mwl8k_hw_reset(priv);
 
@@ -5290,6 +5377,16 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
 	/* Reclaim memory once firmware is successfully loaded */
 	mwl8k_release_firmware(priv);
 
+	if (rc && count) {
+		/* FW did not start successfully;
+		 * lets try one more time
+		 */
+		count--;
+		wiphy_err(hw->wiphy, "Trying to reload the firmware again\n");
+		msleep(20);
+		goto retry;
+	}
+
 	return rc;
 }
 
@@ -5365,7 +5462,14 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		goto err_free_queues;
 	}
 
-	memset(priv->ampdu, 0, sizeof(priv->ampdu));
+	/*
+	 * When hw restart is requested,
+	 * mac80211 will take care of clearing
+	 * the ampdu streams, so do not clear
+	 * the ampdu state here
+	 */
+	if (!priv->hw_restart_in_progress)
+		memset(priv->ampdu, 0, sizeof(priv->ampdu));
 
 	/*
 	 * Temporarily enable interrupts.  Initial firmware host
@@ -5439,10 +5543,20 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 {
 	int i, rc = 0;
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *vif, *tmp_vif;
 
 	mwl8k_stop(hw);
 	mwl8k_rxq_deinit(hw, 0);
 
+	/*
+	 * All the existing interfaces are re-added by the ieee80211_reconfig;
+	 * which means driver should remove existing interfaces before calling
+	 * ieee80211_restart_hw
+	 */
+	if (priv->hw_restart_in_progress)
+		list_for_each_entry_safe(vif, tmp_vif, &priv->vif_list, list)
+			mwl8k_remove_vif(priv, vif);
+
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 
@@ -5454,6 +5568,9 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 	if (rc)
 		goto fail;
 
+	if (priv->hw_restart_in_progress)
+		return rc;
+
 	rc = mwl8k_start(hw);
 	if (rc)
 		goto fail;
@@ -5524,6 +5641,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 	/* Handle watchdog ba events */
 	INIT_WORK(&priv->watchdog_ba_handle, mwl8k_watchdog_ba_events);
+	/* To reload the firmware if it crashes */
+	INIT_WORK(&priv->fw_reload, mwl8k_hw_restart_work);
 
 	/* TX reclaim and RX tasklets.  */
 	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
@@ -5667,6 +5786,9 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	rc = mwl8k_init_firmware(hw, priv->fw_pref, true);
 	if (rc)
 		goto err_stop_firmware;
+
+	priv->hw_restart_in_progress = false;
+
 	return rc;
 
 err_stop_firmware:
-- 
1.5.4.1

