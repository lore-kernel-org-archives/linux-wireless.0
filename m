Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4424 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3S7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:59:53 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 02/22] ath6kl: Fix AP mode (Re)AssocReq IE processing
Date: Tue, 30 Aug 2011 21:57:51 +0300
Message-ID: <1314730691-12089-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_205955_899329_F6D06BAB)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to use correct length field for association request frame and
parse the IEs to find WPA/WPS/RSN IE. In addition, copying of the
IE better make sure it fits in into the buffer to avoid buffer
overflows.

In addition, add the (Re)AssocReq IEs to the cfg80211 new station
event for user space.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   57 +++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index b64b2a3..89e29ea 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -61,7 +61,8 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
 
 	sta = &ar->sta_list[free_slot];
 	memcpy(sta->mac, mac, ETH_ALEN);
-	memcpy(sta->wpa_ie, wpaie, ielen);
+	if (ielen <= ATH6KL_MAX_IE)
+		memcpy(sta->wpa_ie, wpaie, ielen);
 	sta->aid = aid;
 	sta->keymgmt = keymgmt;
 	sta->ucipher = ucipher;
@@ -429,9 +430,11 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 
 static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
 				   u16 listen_int, u16 beacon_int,
-				   u8 assoc_resp_len, u8 *assoc_info)
+				   u8 assoc_req_len, u8 *assoc_info)
 {
 	struct net_device *dev = ar->net_dev;
+	u8 *ies = NULL, *wpa_ie = NULL, *pos;
+	size_t ies_len = 0;
 	struct station_info sinfo;
 	struct ath6kl_req_key *ik;
 	enum crypto_type keyType = NONE_CRYPT;
@@ -473,7 +476,43 @@ skip_key:
 	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n",
 		   bssid, channel);
 
-	ath6kl_add_new_sta(ar, bssid, channel, assoc_info, assoc_resp_len,
+	if (assoc_req_len > sizeof(struct ieee80211_hdr_3addr)) {
+		struct ieee80211_mgmt *mgmt =
+			(struct ieee80211_mgmt *) assoc_info;
+		if (ieee80211_is_assoc_req(mgmt->frame_control) &&
+		    assoc_req_len >= sizeof(struct ieee80211_hdr_3addr) +
+		    sizeof(mgmt->u.assoc_req)) {
+			ies = mgmt->u.assoc_req.variable;
+			ies_len = assoc_info + assoc_req_len - ies;
+		} else if (ieee80211_is_reassoc_req(mgmt->frame_control) &&
+			   assoc_req_len >= sizeof(struct ieee80211_hdr_3addr)
+			   + sizeof(mgmt->u.reassoc_req)) {
+			ies = mgmt->u.reassoc_req.variable;
+			ies_len = assoc_info + assoc_req_len - ies;
+		}
+	}
+
+	pos = ies;
+	while (pos && pos + 1 < ies + ies_len) {
+		if (pos + 2 + pos[1] > ies + ies_len)
+			break;
+		if (pos[0] == WLAN_EID_RSN)
+			wpa_ie = pos; /* RSN IE */
+		else if (pos[0] == WLAN_EID_VENDOR_SPECIFIC &&
+			 pos[1] >= 4 &&
+			 pos[2] == 0x00 && pos[3] == 0x50 && pos[4] == 0xf2) {
+			if (pos[5] == 0x01)
+				wpa_ie = pos; /* WPA IE */
+			else if (pos[5] == 0x04) {
+				wpa_ie = pos; /* WPS IE */
+				break; /* overrides WPA/RSN IE */
+			}
+		}
+		pos += 2 + pos[1];
+	}
+
+	ath6kl_add_new_sta(ar, bssid, channel, wpa_ie,
+			   wpa_ie ? 2 + wpa_ie[1] : 0,
 			   listen_int & 0xFF, beacon_int,
 			   (listen_int >> 8) & 0xFF);
 
@@ -481,9 +520,11 @@ skip_key:
 	memset(&sinfo, 0, sizeof(sinfo));
 
 	/* TODO: sinfo.generation */
-	/* TODO: need to deliver (Re)AssocReq IEs somehow.. change in
-	 * cfg80211 needed, e.g., by adding those into sinfo
-	 */
+
+	sinfo.assoc_req_ies = ies;
+	sinfo.assoc_req_ies_len = ies_len;
+	sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
+
 	cfg80211_new_sta(ar->net_dev, bssid, &sinfo, GFP_KERNEL);
 
 	netif_wake_queue(ar->net_dev);
@@ -895,8 +936,8 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 
 	if (ar->nw_type == AP_NETWORK) {
 		ath6kl_connect_ap_mode(ar, channel, bssid, listen_int,
-				       beacon_int, assoc_resp_len,
-				       assoc_info);
+				       beacon_int, assoc_req_len,
+				       assoc_info + beacon_ie_len);
 		return;
 	}
 
-- 
1.7.4.1

