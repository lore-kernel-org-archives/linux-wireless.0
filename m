Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:36994 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0AHRbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:31:40 -0500
Date: Fri, 8 Jan 2010 18:31:39 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] mwl8k: basic AP interface support
Message-ID: <20100108173139.GB1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for creating AP interfaces, and enabling beaconing.
This allows running a basic AP (11b/g mode only for now).

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  171 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 158 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 428575b..759c94f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -266,6 +266,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
 #define MWL8K_CMD_RF_TX_POWER		0x001e
 #define MWL8K_CMD_RF_ANTENNA		0x0020
+#define MWL8K_CMD_SET_BEACON		0x0100
 #define MWL8K_CMD_SET_PRE_SCAN		0x0107
 #define MWL8K_CMD_SET_POST_SCAN		0x0108
 #define MWL8K_CMD_SET_RF_CHANNEL	0x010a
@@ -281,6 +282,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
 #define MWL8K_CMD_SET_MAC_ADDR		0x0202
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
+#define MWL8K_CMD_BSS_START		0x1100
 #define MWL8K_CMD_SET_NEW_STN		0x1111
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
@@ -299,6 +301,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(RADIO_CONTROL);
 		MWL8K_CMDNAME(RF_TX_POWER);
 		MWL8K_CMDNAME(RF_ANTENNA);
+		MWL8K_CMDNAME(SET_BEACON);
 		MWL8K_CMDNAME(SET_PRE_SCAN);
 		MWL8K_CMDNAME(SET_POST_SCAN);
 		MWL8K_CMDNAME(SET_RF_CHANNEL);
@@ -314,6 +317,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(ENABLE_SNIFFER);
 		MWL8K_CMDNAME(SET_MAC_ADDR);
 		MWL8K_CMDNAME(SET_RATEADAPT_MODE);
+		MWL8K_CMDNAME(BSS_START);
 		MWL8K_CMDNAME(SET_NEW_STN);
 		MWL8K_CMDNAME(UPDATE_STADB);
 	default:
@@ -1769,7 +1773,9 @@ struct mwl8k_cmd_set_hw_spec {
 	__le32 total_rxd;
 } __attribute__((packed));
 
-#define MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT	0x00000080
+#define MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT		0x00000080
+#define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP	0x00000020
+#define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON		0x00000010
 
 static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 {
@@ -1790,7 +1796,9 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);
-	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT);
+	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT |
+				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP |
+				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
 	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
 
@@ -2028,6 +2036,35 @@ mwl8k_cmd_rf_antenna(struct ieee80211_hw *hw, int antenna, int mask)
 }
 
 /*
+ * CMD_SET_BEACON.
+ */
+struct mwl8k_cmd_set_beacon {
+	struct mwl8k_cmd_pkt header;
+	__le16 beacon_len;
+	__u8 beacon[0];
+};
+
+static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw, u8 *beacon, int len)
+{
+	struct mwl8k_cmd_set_beacon *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd) + len, GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_BEACON);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd) + len);
+	cmd->beacon_len = cpu_to_le16(len);
+	memcpy(cmd->beacon, beacon, len);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_SET_PRE_SCAN.
  */
 struct mwl8k_cmd_set_pre_scan {
@@ -2665,6 +2702,33 @@ static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
 }
 
 /*
+ * CMD_BSS_START.
+ */
+struct mwl8k_cmd_bss_start {
+	struct mwl8k_cmd_pkt header;
+	__le32 enable;
+} __attribute__((packed));
+
+static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw, int enable)
+{
+	struct mwl8k_cmd_bss_start *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_BSS_START);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->enable = cpu_to_le32(enable);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_SET_NEW_STN.
  */
 struct mwl8k_cmd_set_new_stn {
@@ -2727,6 +2791,26 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	return rc;
 }
 
+static int mwl8k_cmd_set_new_stn_add_self(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct mwl8k_cmd_set_new_stn *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_NEW_STN);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	memcpy(cmd->mac_addr, vif->addr, ETH_ALEN);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
 static int mwl8k_cmd_set_new_stn_del(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, u8 *addr)
 {
@@ -3016,15 +3100,9 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		return -EBUSY;
 
 	/*
-	 * We only support managed interfaces for now.
-	 */
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
-	/*
 	 * Reject interface creation if sniffer mode is active, as
 	 * STA operation is mutually exclusive with hardware sniffer
-	 * mode.
+	 * mode.  (Sniffer mode is only used on STA firmware.)
 	 */
 	if (priv->sniffer_enabled) {
 		printk(KERN_INFO "%s: unable to create STA "
@@ -3036,6 +3114,9 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	/* Set the mac address.  */
 	mwl8k_cmd_set_mac_addr(hw, vif->addr);
 
+	if (priv->ap_fw)
+		mwl8k_cmd_set_new_stn_add_self(hw, vif);
+
 	/* Clean out driver private area */
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
@@ -3054,6 +3135,9 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 
+	if (priv->ap_fw)
+		mwl8k_cmd_set_new_stn_del(hw, vif, vif->addr);
+
 	mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
 
 	priv->vif = NULL;
@@ -3105,10 +3189,9 @@ out:
 	return rc;
 }
 
-static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_bss_conf *info,
-				   u32 changed)
+static void
+mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	u32 ap_legacy_rates;
@@ -3188,6 +3271,66 @@ out:
 	mwl8k_fw_unlock(hw);
 }
 
+static void
+mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_bss_conf *info, u32 changed)
+{
+	int rc;
+
+	if (mwl8k_fw_lock(hw))
+		return;
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		rc = mwl8k_set_radio_preamble(hw,
+				vif->bss_conf.use_short_preamble);
+		if (rc)
+			goto out;
+	}
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		int idx;
+		int rate;
+
+		/*
+		 * Use lowest supported basic rate for multicasts
+		 * and management frames (such as probe responses --
+		 * beacons will always go out at 1 Mb/s).
+		 */
+		idx = ffs(vif->bss_conf.basic_rates);
+		rate = idx ? mwl8k_rates[idx - 1].hw_value : 2;
+
+		mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
+	}
+
+	if (changed & (BSS_CHANGED_BEACON_INT | BSS_CHANGED_BEACON)) {
+		struct sk_buff *skb;
+
+		skb = ieee80211_beacon_get(hw, vif);
+		if (skb != NULL) {
+			mwl8k_cmd_set_beacon(hw, skb->data, skb->len);
+			kfree_skb(skb);
+		}
+	}
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		mwl8k_cmd_bss_start(hw, info->enable_beacon);
+
+out:
+	mwl8k_fw_unlock(hw);
+}
+
+static void
+mwl8k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       struct ieee80211_bss_conf *info, u32 changed)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	if (!priv->ap_fw)
+		mwl8k_bss_info_changed_sta(hw, vif, info, changed);
+	else
+		mwl8k_bss_info_changed_ap(hw, vif, info, changed);
+}
+
 static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
 				   int mc_count, struct dev_addr_list *mclist)
 {
@@ -3766,6 +3909,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		rc = mwl8k_cmd_get_hw_spec_ap(hw);
 		if (!rc)
 			rc = mwl8k_cmd_set_hw_spec(hw);
+
+		hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_AP);
 	} else {
 		rc = mwl8k_cmd_get_hw_spec_sta(hw);
 
-- 
1.5.6.4
