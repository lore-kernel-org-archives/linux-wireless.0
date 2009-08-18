Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40165 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZHRDup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:50:45 -0400
Date: Tue, 18 Aug 2009 05:50:45 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/29] mwl8k: s/IEEE80211_ADDR_LEN/ETH_ALEN/g
Message-ID: <20090818035045.GG18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   47 +++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6f78fae..55abf27 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -38,8 +38,6 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_table) = {
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_table);
 
-#define IEEE80211_ADDR_LEN			ETH_ALEN
-
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
 #define  MWL8K_MODE_STA				0x0000005a
@@ -199,7 +197,7 @@ struct mwl8k_priv {
 
 	/* XXX need to convert this to handle multiple interfaces */
 	bool capture_beacon;
-	u8 capture_bssid[IEEE80211_ADDR_LEN];
+	u8 capture_bssid[ETH_ALEN];
 	struct sk_buff *beacon_skb;
 
 	/*
@@ -228,8 +226,8 @@ struct mwl8k_vif {
 	struct ieee80211_bss_conf bss_info;
 
 	/* BSSID of AP or IBSS */
-	u8	bssid[IEEE80211_ADDR_LEN];
-	u8	mac_addr[IEEE80211_ADDR_LEN];
+	u8	bssid[ETH_ALEN];
+	u8	mac_addr[ETH_ALEN];
 
 	/*
 	 * Subset of supported legacy rates.
@@ -785,7 +783,7 @@ static inline struct sk_buff *mwl8k_add_dma_header(struct sk_buff *skb)
 		memmove(&tr->wh, wh, hdrlen);
 
 	/* Clear addr4 */
-	memset(tr->wh.addr4, 0, IEEE80211_ADDR_LEN);
+	memset(tr->wh.addr4, 0, ETH_ALEN);
 
 	/*
 	 * Firmware length is the length of the fully formed "802.11
@@ -952,7 +950,7 @@ static inline void mwl8k_save_beacon(struct mwl8k_priv *priv,
 							struct sk_buff *skb)
 {
 	priv->capture_beacon = false;
-	memset(priv->capture_bssid, 0, IEEE80211_ADDR_LEN);
+	memset(priv->capture_bssid, 0, ETH_ALEN);
 
 	/*
 	 * Use GFP_ATOMIC as rxq_process is called from
@@ -1067,7 +1065,7 @@ struct mwl8k_tx_desc {
 	__le16 qos_control;
 	__le32 pkt_phys_addr;
 	__le16 pkt_len;
-	__u8 dest_MAC_addr[IEEE80211_ADDR_LEN];
+	__u8 dest_MAC_addr[ETH_ALEN];
 	__le32 next_tx_desc_phys_addr;
 	__le32 reserved;
 	__le16 rate_info;
@@ -1587,7 +1585,7 @@ struct mwl8k_cmd_get_hw_spec {
 	__u8 hw_rev;
 	__u8 host_interface;
 	__le16 num_mcaddrs;
-	__u8 perm_addr[IEEE80211_ADDR_LEN];
+	__u8 perm_addr[ETH_ALEN];
 	__le16 region_code;
 	__le32 fw_rev;
 	__le32 ps_cookie;
@@ -1644,7 +1642,7 @@ struct mwl8k_cmd_mac_multicast_adr {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
 	__le16 numaddr;
-	__u8 addr[1][IEEE80211_ADDR_LEN];
+	__u8 addr[1][ETH_ALEN];
 };
 
 #define MWL8K_ENABLE_RX_MULTICAST 0x000F
@@ -1655,7 +1653,7 @@ static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 	struct mwl8k_cmd_mac_multicast_adr *cmd;
 	int index = 0;
 	int rc;
-	int size = sizeof(*cmd) + ((mc_count - 1) * IEEE80211_ADDR_LEN);
+	int size = sizeof(*cmd) + ((mc_count - 1) * ETH_ALEN);
 	cmd = kzalloc(size, GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -1665,11 +1663,11 @@ static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 	cmd->action = cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 	cmd->numaddr = cpu_to_le16(mc_count);
 	while ((index < mc_count) && mclist) {
-		if (mclist->da_addrlen != IEEE80211_ADDR_LEN) {
+		if (mclist->da_addrlen != ETH_ALEN) {
 			rc = -EINVAL;
 			goto mwl8k_cmd_mac_multicast_adr_exit;
 		}
-		memcpy(cmd->addr[index], mclist->da_addr, IEEE80211_ADDR_LEN);
+		memcpy(cmd->addr[index], mclist->da_addr, ETH_ALEN);
 		index++;
 		mclist = mclist->next;
 	}
@@ -1848,11 +1846,11 @@ static int mwl8k_cmd_set_pre_scan(struct ieee80211_hw *hw)
 struct mwl8k_cmd_set_post_scan {
 	struct mwl8k_cmd_pkt header;
 	__le32 isibss;
-	__u8 bssid[IEEE80211_ADDR_LEN];
+	__u8 bssid[ETH_ALEN];
 } __attribute__((packed));
 
 static int
-mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 mac[IEEE80211_ADDR_LEN])
+mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 mac[ETH_ALEN])
 {
 	struct mwl8k_cmd_set_post_scan *cmd;
 	int rc;
@@ -1864,7 +1862,7 @@ mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 mac[IEEE80211_ADDR_LEN])
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_POST_SCAN);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->isibss = 0;
-	memcpy(cmd->bssid, mac, IEEE80211_ADDR_LEN);
+	memcpy(cmd->bssid, mac, ETH_ALEN);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2216,7 +2214,7 @@ struct mwl8k_cmd_update_sta_db {
 	__le32	action;
 
 	/* Peer MAC address */
-	__u8	peer_addr[IEEE80211_ADDR_LEN];
+	__u8	peer_addr[ETH_ALEN];
 
 	__le32	reserved;
 
@@ -2244,7 +2242,7 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 
 	cmd->action = cpu_to_le32(action);
 	peer_info = &cmd->peer_info;
-	memcpy(cmd->peer_addr, mv_vif->bssid, IEEE80211_ADDR_LEN);
+	memcpy(cmd->peer_addr, mv_vif->bssid, ETH_ALEN);
 
 	switch (action) {
 	case MWL8K_STA_DB_ADD_ENTRY:
@@ -2293,7 +2291,7 @@ struct mwl8k_cmd_update_set_aid {
 	__le16	aid;
 
 	 /* AP's MAC address (BSSID) */
-	__u8	bssid[IEEE80211_ADDR_LEN];
+	__u8	bssid[ETH_ALEN];
 	__le16	protection_mode;
 	__u8	supp_rates[MWL8K_RATE_INDEX_MAX_ARRAY];
 } __attribute__((packed));
@@ -2317,7 +2315,7 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->aid = cpu_to_le16(info->aid);
 
-	memcpy(cmd->bssid, mv_vif->bssid, IEEE80211_ADDR_LEN);
+	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
 
 	prot_mode = MWL8K_FRAME_PROT_DISABLED;
 
@@ -2934,7 +2932,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 
 	/* Save the mac address */
-	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, IEEE80211_ADDR_LEN);
+	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, ETH_ALEN);
 
 	/* Back pointer to parent config block */
 	mwl8k_vif->priv = priv;
@@ -3098,14 +3096,13 @@ static int mwl8k_bss_info_changed_wt(struct work_struct *wt)
 		 * Finalize the join.  Tell rx handler to process
 		 * next beacon from our BSSID.
 		 */
-		memcpy(priv->capture_bssid,
-				mwl8k_vif->bssid, IEEE80211_ADDR_LEN);
+		memcpy(priv->capture_bssid, mwl8k_vif->bssid, ETH_ALEN);
 		priv->capture_beacon = true;
 	} else {
 		mwl8k_cmd_update_sta_db(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
 		memset(&mwl8k_vif->bss_info, 0,
 			sizeof(struct ieee80211_bss_conf));
-		memset(mwl8k_vif->bssid, 0, IEEE80211_ADDR_LEN);
+		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
 	}
 
 mwl8k_bss_info_changed_exit:
@@ -3124,7 +3121,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 	int rc;
 
 	if (changed & BSS_CHANGED_BSSID)
-		memcpy(mv_vif->bssid, info->bssid, IEEE80211_ADDR_LEN);
+		memcpy(mv_vif->bssid, info->bssid, ETH_ALEN);
 
 	if ((changed & BSS_CHANGED_ASSOC) == 0)
 		return;
-- 
1.5.6.4
