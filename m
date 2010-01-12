Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58853 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0ALMuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:50:37 -0500
Date: Tue, 12 Jan 2010 13:50:36 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 15/17] mwl8k: post per-vif firmware commands as per-vif commands
Message-ID: <20100112125036.GE1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SET_BEACON, SET_MAC_ADDR, BSS_START and SET_NEW_STN are the currently
supported firmware commands that are actually per-vif commands.  Use
mwl8k_post_pervif_cmd() for these commands, so that the macid of the
vif they operate on gets passed down into the firmware.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   49 ++++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ea39ef6..d8cf438 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -294,7 +294,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
 #define MWL8K_CMD_RF_TX_POWER		0x001e
 #define MWL8K_CMD_RF_ANTENNA		0x0020
-#define MWL8K_CMD_SET_BEACON		0x0100
+#define MWL8K_CMD_SET_BEACON		0x0100		/* per-vif */
 #define MWL8K_CMD_SET_PRE_SCAN		0x0107
 #define MWL8K_CMD_SET_POST_SCAN		0x0108
 #define MWL8K_CMD_SET_RF_CHANNEL	0x010a
@@ -308,10 +308,10 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_MIMO_CONFIG		0x0125
 #define MWL8K_CMD_USE_FIXED_RATE	0x0126
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
-#define MWL8K_CMD_SET_MAC_ADDR		0x0202
+#define MWL8K_CMD_SET_MAC_ADDR		0x0202		/* per-vif */
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
-#define MWL8K_CMD_BSS_START		0x1100
-#define MWL8K_CMD_SET_NEW_STN		0x1111
+#define MWL8K_CMD_BSS_START		0x1100		/* per-vif */
+#define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
 static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
@@ -2156,7 +2156,8 @@ struct mwl8k_cmd_set_beacon {
 	__u8 beacon[0];
 };
 
-static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw, u8 *beacon, int len)
+static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif, u8 *beacon, int len)
 {
 	struct mwl8k_cmd_set_beacon *cmd;
 	int rc;
@@ -2170,7 +2171,7 @@ static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw, u8 *beacon, int len)
 	cmd->beacon_len = cpu_to_le16(len);
 	memcpy(cmd->beacon, beacon, len);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -2761,7 +2762,8 @@ struct mwl8k_cmd_set_mac_addr {
 #define MWL8K_MAC_TYPE_PRIMARY_CLIENT	0
 #define MWL8K_MAC_TYPE_PRIMARY_AP	2
 
-static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
+static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_set_mac_addr *cmd;
@@ -2780,7 +2782,7 @@ static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 		memcpy(cmd->mac_addr, mac, ETH_ALEN);
 	}
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -2823,7 +2825,8 @@ struct mwl8k_cmd_bss_start {
 	__le32 enable;
 } __attribute__((packed));
 
-static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw, int enable)
+static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif, int enable)
 {
 	struct mwl8k_cmd_bss_start *cmd;
 	int rc;
@@ -2836,7 +2839,7 @@ static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw, int enable)
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->enable = cpu_to_le32(enable);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -2904,7 +2907,7 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 		cmd->is_qos_sta = 1;
 	}
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -2924,7 +2927,7 @@ static int mwl8k_cmd_set_new_stn_add_self(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	memcpy(cmd->mac_addr, vif->addr, ETH_ALEN);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -2945,7 +2948,7 @@ static int mwl8k_cmd_set_new_stn_del(struct ieee80211_hw *hw,
 	memcpy(cmd->mac_addr, addr, ETH_ALEN);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_REMOVE);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -3287,12 +3290,6 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
-	/* Set the mac address.  */
-	mwl8k_cmd_set_mac_addr(hw, vif->addr);
-
-	if (priv->ap_fw)
-		mwl8k_cmd_set_new_stn_add_self(hw, vif);
-
 	/* Setup driver private area. */
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
@@ -3300,6 +3297,12 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif->macid = 0;
 	mwl8k_vif->seqno = 0;
 
+	/* Set the mac address.  */
+	mwl8k_cmd_set_mac_addr(hw, vif, vif->addr);
+
+	if (priv->ap_fw)
+		mwl8k_cmd_set_new_stn_add_self(hw, vif);
+
 	list_add_tail(&mwl8k_vif->list, &priv->vif_list);
 
 	return 0;
@@ -3314,7 +3317,7 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	if (priv->ap_fw)
 		mwl8k_cmd_set_new_stn_del(hw, vif, vif->addr);
 
-	mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
 
 	list_del(&mwl8k_vif->list);
 }
@@ -3492,13 +3495,13 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		skb = ieee80211_beacon_get(hw, vif);
 		if (skb != NULL) {
-			mwl8k_cmd_set_beacon(hw, skb->data, skb->len);
+			mwl8k_cmd_set_beacon(hw, vif, skb->data, skb->len);
 			kfree_skb(skb);
 		}
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED)
-		mwl8k_cmd_bss_start(hw, info->enable_beacon);
+		mwl8k_cmd_bss_start(hw, vif, info->enable_beacon);
 
 out:
 	mwl8k_fw_unlock(hw);
@@ -4112,7 +4115,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	/* Clear MAC address */
-	rc = mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+	rc = mwl8k_cmd_set_mac_addr(hw, NULL, "\x00\x00\x00\x00\x00\x00");
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot clear MAC address\n",
 		       wiphy_name(hw->wiphy));
-- 
1.5.6.4
