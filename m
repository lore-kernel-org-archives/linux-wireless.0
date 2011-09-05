Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4714 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1IEOj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 10:39:26 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/4] ath6kl: Fix AP mode connect event parsing and TIM updates
Date: Mon, 5 Sep 2011 17:38:45 +0300
Message-ID: <1315233527-6234-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20110905_163928_795400_29C39CCC)
In-Reply-To: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up the connect event parsing by defining a union in
struct wmi_connect_event to match with the three possible sets of
fields that the target uses depending on which type of connect
event is being indicated. In addition, two AP cases are now
separated from ath6kl_connect_event() so that correct field names
can be used to make it actually possible to understand what the
code is doing.

The bug hiding in the previous mess was in parsing the AID incorrectly
when processing the new station connecting event in AP mode. The fix
here for that is also fixing TIM updates for PS buffering to use the
correct AID.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    4 ++
 drivers/net/wireless/ath/ath6kl/main.c |   92 ++++++++++++++------------------
 drivers/net/wireless/ath/ath6kl/wmi.c  |   44 +++++++++++++--
 drivers/net/wireless/ath/ath6kl/wmi.h  |   29 ++++++++--
 4 files changed, 107 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index fdb796f..054da13 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -560,6 +560,10 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel,
 			  u16 beacon_int, enum network_type net_type,
 			  u8 beacon_ie_len, u8 assoc_req_len,
 			  u8 assoc_resp_len, u8 *assoc_info);
+void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel);
+void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
+				u8 keymgmt, u8 ucipher, u8 auth,
+				u8 assoc_req_len, u8 *assoc_info);
 void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason,
 			     u8 *bssid, u8 assoc_resp_len,
 			     u8 *assoc_info, u16 prot_reason_status);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3cefca6..d510046 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -519,57 +519,55 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 	}
 }
 
-static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
-				   u16 listen_int, u16 beacon_int,
-				   u8 assoc_req_len, u8 *assoc_info)
+void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 {
-	struct net_device *dev = ar->net_dev;
-	u8 *ies = NULL, *wpa_ie = NULL, *pos;
-	size_t ies_len = 0;
-	struct station_info sinfo;
 	struct ath6kl_req_key *ik;
 	int res;
 	u8 key_rsc[ATH6KL_KEY_SEQ_LEN];
 
-	if (memcmp(dev->dev_addr, bssid, ETH_ALEN) == 0) {
-		ik = &ar->ap_mode_bkey;
+	ik = &ar->ap_mode_bkey;
 
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "AP mode started on %u MHz\n",
-			   channel);
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "AP mode started on %u MHz\n", channel);
 
-		switch (ar->auth_mode) {
-		case NONE_AUTH:
-			if (ar->prwise_crypto == WEP_CRYPT)
-				ath6kl_install_static_wep_keys(ar);
+	switch (ar->auth_mode) {
+	case NONE_AUTH:
+		if (ar->prwise_crypto == WEP_CRYPT)
+			ath6kl_install_static_wep_keys(ar);
+		break;
+	case WPA_PSK_AUTH:
+	case WPA2_PSK_AUTH:
+	case (WPA_PSK_AUTH | WPA2_PSK_AUTH):
+		if (!ik->valid)
 			break;
-		case WPA_PSK_AUTH:
-		case WPA2_PSK_AUTH:
-		case (WPA_PSK_AUTH|WPA2_PSK_AUTH):
-			if (!ik->valid)
-				break;
 
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed addkey for "
-				   "the initial group key for AP mode\n");
-			memset(key_rsc, 0, sizeof(key_rsc));
-			res = ath6kl_wmi_addkey_cmd(
-				ar->wmi, ik->key_index, ik->key_type,
-				GROUP_USAGE, ik->key_len, key_rsc, ik->key,
-				KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
-			if (res) {
-				ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed "
-					   "addkey failed: %d\n", res);
-			}
-			break;
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed addkey for "
+			   "the initial group key for AP mode\n");
+		memset(key_rsc, 0, sizeof(key_rsc));
+		res = ath6kl_wmi_addkey_cmd(
+			ar->wmi, ik->key_index, ik->key_type,
+			GROUP_USAGE, ik->key_len, key_rsc, ik->key,
+			KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
+		if (res) {
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed "
+				   "addkey failed: %d\n", res);
 		}
-
-		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
-		set_bit(CONNECTED, &ar->flag);
-		netif_carrier_on(ar->net_dev);
-		return;
+		break;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n",
-		   bssid, channel);
+	ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+	set_bit(CONNECTED, &ar->flag);
+	netif_carrier_on(ar->net_dev);
+}
+
+void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
+				u8 keymgmt, u8 ucipher, u8 auth,
+				u8 assoc_req_len, u8 *assoc_info)
+{
+	u8 *ies = NULL, *wpa_ie = NULL, *pos;
+	size_t ies_len = 0;
+	struct station_info sinfo;
+
+	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n", mac_addr, aid);
 
 	if (assoc_req_len > sizeof(struct ieee80211_hdr_3addr)) {
 		struct ieee80211_mgmt *mgmt =
@@ -606,10 +604,9 @@ static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
 		pos += 2 + pos[1];
 	}
 
-	ath6kl_add_new_sta(ar, bssid, channel, wpa_ie,
+	ath6kl_add_new_sta(ar, mac_addr, aid, wpa_ie,
 			   wpa_ie ? 2 + wpa_ie[1] : 0,
-			   listen_int & 0xFF, beacon_int,
-			   (listen_int >> 8) & 0xFF);
+			   keymgmt, ucipher, auth);
 
 	/* send event to application */
 	memset(&sinfo, 0, sizeof(sinfo));
@@ -620,11 +617,9 @@ static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
 	sinfo.assoc_req_ies_len = ies_len;
 	sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
 
-	cfg80211_new_sta(ar->net_dev, bssid, &sinfo, GFP_KERNEL);
+	cfg80211_new_sta(ar->net_dev, mac_addr, &sinfo, GFP_KERNEL);
 
 	netif_wake_queue(ar->net_dev);
-
-	return;
 }
 
 /* Functions for Tx credit handling */
@@ -1030,13 +1025,6 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 {
 	unsigned long flags;
 
-	if (ar->nw_type == AP_NETWORK) {
-		ath6kl_connect_ap_mode(ar, channel, bssid, listen_int,
-				       beacon_int, assoc_req_len,
-				       assoc_info + beacon_ie_len);
-		return;
-	}
-
 	ath6kl_cfg80211_connect_event(ar, channel, bssid,
 				      listen_int, beacon_int,
 				      net_type, beacon_ie_len,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index b2c5c40..b56830f 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -699,14 +699,47 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_connect_event *ev;
 	u8 *pie, *peie;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(struct wmi_connect_event))
 		return -EINVAL;
 
 	ev = (struct wmi_connect_event *) datap;
 
+	if (ar->nw_type == AP_NETWORK) {
+		/* AP mode start/STA connected event */
+		struct net_device *dev = ar->net_dev;
+		if (memcmp(dev->dev_addr, ev->u.ap_bss.bssid, ETH_ALEN) == 0) {
+			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM "
+				   "(AP started)\n",
+				   __func__, le16_to_cpu(ev->u.ap_bss.ch),
+				   ev->u.ap_bss.bssid);
+			ath6kl_connect_ap_mode_bss(
+				ar, le16_to_cpu(ev->u.ap_bss.ch));
+		} else {
+			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: aid %u mac_addr %pM "
+				   "auth=%u keymgmt=%u cipher=%u apsd_info=%u "
+				   "(STA connected)\n",
+				   __func__, ev->u.ap_sta.aid,
+				   ev->u.ap_sta.mac_addr,
+				   ev->u.ap_sta.auth,
+				   ev->u.ap_sta.keymgmt,
+				   le16_to_cpu(ev->u.ap_sta.cipher),
+				   ev->u.ap_sta.apsd_info);
+			ath6kl_connect_ap_mode_sta(
+				ar, ev->u.ap_sta.aid, ev->u.ap_sta.mac_addr,
+				ev->u.ap_sta.keymgmt,
+				le16_to_cpu(ev->u.ap_sta.cipher),
+				ev->u.ap_sta.auth, ev->assoc_req_len,
+				ev->assoc_info + ev->beacon_ie_len);
+		}
+		return 0;
+	}
+
+	/* STA/IBSS mode connection event */
+
 	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM\n",
-		   __func__, ev->ch, ev->bssid);
+		   __func__, le16_to_cpu(ev->u.sta.ch), ev->u.sta.bssid);
 
 	/* Start of assoc rsp IEs */
 	pie = ev->assoc_info + ev->beacon_ie_len +
@@ -735,10 +768,11 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 		pie += pie[1] + 2;
 	}
 
-	ath6kl_connect_event(wmi->parent_dev, le16_to_cpu(ev->ch), ev->bssid,
-			     le16_to_cpu(ev->listen_intvl),
-			     le16_to_cpu(ev->beacon_intvl),
-			     le32_to_cpu(ev->nw_type),
+	ath6kl_connect_event(wmi->parent_dev, le16_to_cpu(ev->u.sta.ch),
+			     ev->u.sta.bssid,
+			     le16_to_cpu(ev->u.sta.listen_intvl),
+			     le16_to_cpu(ev->u.sta.beacon_intvl),
+			     le32_to_cpu(ev->u.sta.nw_type),
 			     ev->beacon_ie_len, ev->assoc_req_len,
 			     ev->assoc_resp_len, ev->assoc_info);
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index e86b81d..5ca8c8e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1275,11 +1275,30 @@ struct wmi_ready_event_2 {
 
 /* Connect Event */
 struct wmi_connect_event {
-	__le16 ch;
-	u8 bssid[ETH_ALEN];
-	__le16 listen_intvl;
-	__le16 beacon_intvl;
-	__le32 nw_type;
+	union {
+		struct {
+			__le16 ch;
+			u8 bssid[ETH_ALEN];
+			__le16 listen_intvl;
+			__le16 beacon_intvl;
+			__le32 nw_type;
+		} sta;
+		struct {
+			u8 phymode;
+			u8 aid;
+			u8 mac_addr[ETH_ALEN];
+			u8 auth;
+			u8 keymgmt;
+			__le16 cipher;
+			u8 apsd_info;
+			u8 unused[3];
+		} ap_sta;
+		struct {
+			__le16 ch;
+			u8 bssid[ETH_ALEN];
+			u8 unused[8];
+		} ap_bss;
+	} u;
 	u8 beacon_ie_len;
 	u8 assoc_req_len;
 	u8 assoc_resp_len;
-- 
1.7.4.1

