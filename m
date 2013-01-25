Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:45563 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab3AYKyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:54:10 -0500
Date: Fri, 25 Jan 2013 16:17:32 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Stop bsses before hw specific commands
Message-ID: <20130125104732.GA9134@markyou.marvell.com> (sfid-20130125_115415_897799_960B3DDE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the commands, that might change the hw characteristics
of the PHY device, stop the running bsses and resume them
once command is complete.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 78 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 1b1eb99..0b2428d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -285,6 +285,9 @@ struct mwl8k_priv {
 	char *fw_pref;
 	char *fw_alt;
 	struct completion firmware_loading_complete;
+
+	/* bitmap of running BSSes */
+	u32 running_bsses;
 };
 
 #define MAX_WEP_KEY_LEN         13
@@ -2156,6 +2159,8 @@ static void mwl8k_fw_unlock(struct ieee80211_hw *hw)
 	}
 }
 
+static void mwl8k_enable_bsses(struct ieee80211_hw *hw, bool enable,
+			       u32 bitmap);
 
 /*
  * Command processing.
@@ -2174,6 +2179,34 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	int rc;
 	unsigned long timeout = 0;
 	u8 buf[32];
+	u32 bitmap = 0;
+
+	wiphy_dbg(hw->wiphy, "Posting %s [%d]\n",
+		  mwl8k_cmd_name(cmd->code, buf, sizeof(buf)), cmd->macid);
+
+	/* Before posting firmware commands that could change the hardware
+	 * characteristics, make sure that all BSSes are stopped temporary.
+	 * Enable these stopped BSSes after completion of the commands
+	 */
+
+	rc = mwl8k_fw_lock(hw);
+	if (rc)
+		return rc;
+
+	if (priv->ap_fw && priv->running_bsses) {
+		switch (le16_to_cpu(cmd->code)) {
+		case MWL8K_CMD_SET_RF_CHANNEL:
+		case MWL8K_CMD_RADIO_CONTROL:
+		case MWL8K_CMD_RF_TX_POWER:
+		case MWL8K_CMD_TX_POWER:
+		case MWL8K_CMD_RF_ANTENNA:
+		case MWL8K_CMD_RTS_THRESHOLD:
+		case MWL8K_CMD_MIMO_CONFIG:
+			bitmap = priv->running_bsses;
+			mwl8k_enable_bsses(hw, false, bitmap);
+			break;
+		}
+	}
 
 	cmd->result = (__force __le16) 0xffff;
 	dma_size = le16_to_cpu(cmd->length);
@@ -2182,13 +2215,6 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	if (pci_dma_mapping_error(priv->pdev, dma_addr))
 		return -ENOMEM;
 
-	rc = mwl8k_fw_lock(hw);
-	if (rc) {
-		pci_unmap_single(priv->pdev, dma_addr, dma_size,
-						PCI_DMA_BIDIRECTIONAL);
-		return rc;
-	}
-
 	priv->hostcmd_wait = &cmd_wait;
 	iowrite32(dma_addr, regs + MWL8K_HIU_GEN_PTR);
 	iowrite32(MWL8K_H2A_INT_DOORBELL,
@@ -2201,7 +2227,6 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 
 	priv->hostcmd_wait = NULL;
 
-	mwl8k_fw_unlock(hw);
 
 	pci_unmap_single(priv->pdev, dma_addr, dma_size,
 					PCI_DMA_BIDIRECTIONAL);
@@ -2228,6 +2253,11 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 				     ms);
 	}
 
+	if (bitmap)
+		mwl8k_enable_bsses(hw, true, bitmap);
+
+	mwl8k_fw_unlock(hw);
+
 	return rc;
 }
 
@@ -3680,8 +3710,16 @@ static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif, int enable)
 {
 	struct mwl8k_cmd_bss_start *cmd;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+	struct mwl8k_priv *priv = hw->priv;
 	int rc;
 
+	if (enable && (priv->running_bsses & (1 << mwl8k_vif->macid)))
+		return 0;
+
+	if (!enable && !(priv->running_bsses & (1 << mwl8k_vif->macid)))
+		return 0;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -3693,9 +3731,31 @@ static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw,
 	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
+	if (!rc) {
+		if (enable)
+			priv->running_bsses |= (1 << mwl8k_vif->macid);
+		else
+			priv->running_bsses &= ~(1 << mwl8k_vif->macid);
+	}
 	return rc;
 }
 
+static void mwl8k_enable_bsses(struct ieee80211_hw *hw, bool enable, u32 bitmap)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mwl8k_vif, *tmp_vif;
+	struct ieee80211_vif *vif;
+
+	list_for_each_entry_safe(mwl8k_vif, tmp_vif, &priv->vif_list, list) {
+		vif = mwl8k_vif->vif;
+
+		if (!(bitmap & (1 << mwl8k_vif->macid)))
+			continue;
+
+		if (vif->type == NL80211_IFTYPE_AP)
+			mwl8k_cmd_bss_start(hw, vif, enable);
+	}
+}
 /*
  * CMD_BASTREAM.
  */
@@ -5948,6 +6008,8 @@ static int mwl8k_probe(struct pci_dev *pdev,
 
 	priv->hw_restart_in_progress = false;
 
+	priv->running_bsses = 0;
+
 	return rc;
 
 err_stop_firmware:
-- 
1.8.0.3

