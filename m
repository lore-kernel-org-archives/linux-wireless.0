Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754421AbdHYCay (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:54 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 09/27] qtnfmac: do not cache BSS state in per-VIF structure
Date: Thu, 24 Aug 2017 19:30:06 -0700
Message-Id: <20170825023024.10565-10-igor.mitsyanko.os@quantenna.com> (sfid-20170825_044308_802339_9D239C5D)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This cached state is unused, except for BSSID that we will keep.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 39 ++++--------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 49 +++++++++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 19 ++-------
 3 files changed, 42 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 999f1bd..9eb0c08 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -131,6 +131,7 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	vif->netdev = NULL;
 	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 	eth_zero_addr(vif->mac_addr);
+	eth_zero_addr(vif->bssid);
 
 	return 0;
 }
@@ -199,6 +200,8 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 	qtnf_cmd_send_del_intf(vif);
 err_cmd:
 	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+	eth_zero_addr(vif->mac_addr);
+	eth_zero_addr(vif->bssid);
 
 	return ERR_PTR(-EFAULT);
 }
@@ -569,7 +572,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct cfg80211_chan_def chandef;
-	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
 	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
@@ -578,9 +580,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->sta_state != QTNF_STA_DISCONNECTED)
 		return -EBUSY;
 
-	bss_cfg = &vif->bss_cfg;
-	memset(bss_cfg, 0, sizeof(*bss_cfg));
-
 	if (sme->channel) {
 		/* FIXME: need to set proper nl80211_channel_type value */
 		cfg80211_chandef_create(&chandef, sme->channel,
@@ -593,34 +592,10 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 		memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
 	}
 
-	bss_cfg->ssid_len = sme->ssid_len;
-	memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
-	bss_cfg->auth_type = sme->auth_type;
-	bss_cfg->privacy = sme->privacy;
-	bss_cfg->mfp = sme->mfp;
-
-	if ((sme->bg_scan_period > 0) &&
-	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
-		bss_cfg->bg_scan_period = sme->bg_scan_period;
-	else if (sme->bg_scan_period == -1)
-		bss_cfg->bg_scan_period = QTNF_DEFAULT_BG_SCAN_PERIOD;
-	else
-		bss_cfg->bg_scan_period = 0; /* disabled */
-
-	bss_cfg->connect_flags = 0;
-
-	if (sme->flags & ASSOC_REQ_DISABLE_HT)
-		bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_HT;
-	if (sme->flags & ASSOC_REQ_DISABLE_VHT)
-		bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_VHT;
-	if (sme->flags & ASSOC_REQ_USE_RRM)
-		bss_cfg->connect_flags |= QLINK_STA_CONNECT_USE_RRM;
-
-	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg->crypto));
 	if (sme->bssid)
-		ether_addr_copy(bss_cfg->bssid, sme->bssid);
+		ether_addr_copy(vif->bssid, sme->bssid);
 	else
-		eth_zero_addr(bss_cfg->bssid);
+		eth_zero_addr(vif->bssid);
 
 	ret = qtnf_cmd_send_connect(vif, sme);
 	if (ret) {
@@ -1050,7 +1025,7 @@ void qtnf_virtual_intf_cleanup(struct net_device *ndev)
 			break;
 		case QTNF_STA_CONNECTING:
 			cfg80211_connect_result(vif->netdev,
-						vif->bss_cfg.bssid, NULL, 0,
+						vif->bssid, NULL, 0,
 						NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
 						GFP_KERNEL);
@@ -1077,7 +1052,7 @@ void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif)
 		switch (vif->sta_state) {
 		case QTNF_STA_CONNECTING:
 			cfg80211_connect_result(vif->netdev,
-						vif->bss_cfg.bssid, NULL, 0,
+						vif->bssid, NULL, 0,
 						NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
 						GFP_KERNEL);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index cb9632b..7dbee42 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2036,11 +2036,11 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_connect *cmd;
-	struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
 	struct qlink_auth_encr aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
+	u32 connect_flags = 0;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_CONNECT,
@@ -2052,40 +2052,55 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	cmd = (struct qlink_cmd_connect *)cmd_skb->data;
 
-	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
+	ether_addr_copy(cmd->bssid, vif->bssid);
 
 	if (vif->mac->chandef.chan)
 		cmd->channel = cpu_to_le16(vif->mac->chandef.chan->hw_value);
 
-	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
+	if ((sme->bg_scan_period > 0) &&
+	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
+		cmd->bg_scan_period = cpu_to_le16(sme->bg_scan_period);
+	else if (sme->bg_scan_period == -1)
+		cmd->bg_scan_period = cpu_to_le16(QTNF_DEFAULT_BG_SCAN_PERIOD);
+	else
+		cmd->bg_scan_period = 0; /* disabled */
+
+	if (sme->flags & ASSOC_REQ_DISABLE_HT)
+		connect_flags |= QLINK_STA_CONNECT_DISABLE_HT;
+	if (sme->flags & ASSOC_REQ_DISABLE_VHT)
+		connect_flags |= QLINK_STA_CONNECT_DISABLE_VHT;
+	if (sme->flags & ASSOC_REQ_USE_RRM)
+		connect_flags |= QLINK_STA_CONNECT_USE_RRM;
+
+	cmd->flags = cpu_to_le32(connect_flags);
 
 	memset(&aen, 0, sizeof(aen));
-	aen.auth_type = bss_cfg->auth_type;
-	aen.privacy = !!bss_cfg->privacy;
-	aen.mfp = bss_cfg->mfp;
-	aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
-	aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
+	aen.auth_type = sme->auth_type;
+	aen.privacy = !!sme->privacy;
+	aen.mfp = sme->mfp;
+	aen.wpa_versions = cpu_to_le32(sme->crypto.wpa_versions);
+	aen.cipher_group = cpu_to_le32(sme->crypto.cipher_group);
 	aen.n_ciphers_pairwise = cpu_to_le32(
-					bss_cfg->crypto.n_ciphers_pairwise);
+		sme->crypto.n_ciphers_pairwise);
 
 	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
 		aen.ciphers_pairwise[i] = cpu_to_le32(
-					bss_cfg->crypto.ciphers_pairwise[i]);
+			sme->crypto.ciphers_pairwise[i]);
 
-	aen.n_akm_suites = cpu_to_le32(bss_cfg->crypto.n_akm_suites);
+	aen.n_akm_suites = cpu_to_le32(sme->crypto.n_akm_suites);
 
 	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
 		aen.akm_suites[i] = cpu_to_le32(
-					bss_cfg->crypto.akm_suites[i]);
+			sme->crypto.akm_suites[i]);
 
-	aen.control_port = bss_cfg->crypto.control_port;
+	aen.control_port = sme->crypto.control_port;
 	aen.control_port_no_encrypt =
-			bss_cfg->crypto.control_port_no_encrypt;
+		sme->crypto.control_port_no_encrypt;
 	aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
-				bss_cfg->crypto.control_port_ethertype));
+		sme->crypto.control_port_ethertype));
 
-	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
-				 bss_cfg->ssid_len);
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, sme->ssid,
+		sme->ssid_len);
 	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
 				 sizeof(aen));
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index a40295e..aa1a92f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -57,20 +57,6 @@ extern const struct net_device_ops qtnf_netdev_ops;
 struct qtnf_bus;
 struct qtnf_vif;
 
-struct qtnf_bss_config {
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 bssid[ETH_ALEN];
-	size_t ssid_len;
-	u8 dtim;
-	u16 bcn_period;
-	u16 auth_type;
-	bool privacy;
-	enum nl80211_mfp mfp;
-	struct cfg80211_crypto_settings crypto;
-	u16 bg_scan_period;
-	u32 connect_flags;
-};
-
 struct qtnf_sta_node {
 	struct list_head list;
 	u8 mac_addr[ETH_ALEN];
@@ -93,6 +79,8 @@ enum qtnf_mac_status {
 
 struct qtnf_vif {
 	struct wireless_dev wdev;
+	u8 bssid[ETH_ALEN];
+	u8 mac_addr[ETH_ALEN];
 	u8 vifid;
 	u8 bss_priority;
 	u8 bss_status;
@@ -100,9 +88,8 @@ struct qtnf_vif {
 	u16 mgmt_frames_bitmask;
 	struct net_device *netdev;
 	struct qtnf_wmac *mac;
-	u8 mac_addr[ETH_ALEN];
+
 	struct work_struct reset_work;
-	struct qtnf_bss_config bss_cfg;
 	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
 };
-- 
2.9.5
