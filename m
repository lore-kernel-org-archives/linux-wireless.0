Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754484AbdHYCbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:08 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 22/27] qtnfmac: SCAN results: retreive frame type information from "IE set" TLV
Date: Thu, 24 Aug 2017 19:30:19 -0700
Message-Id: <20170825023024.10565-23-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043112_972599_192A7735)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

"IE set" TLV carries the same information as
qlink_event_scan_result::frame_type. Convert the event to make use of
TLV and drop frame_type member.
While at it, make qlink_event_scan_result structure alignement-safe.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 25 ++++++++++++-------------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h | 11 ++---------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index c2452dc..5fb0ead 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -252,13 +252,12 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 	struct cfg80211_bss *bss;
 	struct ieee80211_channel *channel;
 	struct wiphy *wiphy = priv_to_wiphy(vif->mac);
-	enum cfg80211_bss_frame_type frame_type;
+	enum cfg80211_bss_frame_type frame_type = CFG80211_BSS_FTYPE_UNKNOWN;
 	size_t payload_len;
 	u16 tlv_type;
 	u16 tlv_value_len;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
-
 	const u8 *ies = NULL;
 	size_t ies_len = 0;
 
@@ -275,17 +274,6 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 		return -EINVAL;
 	}
 
-	switch (sr->frame_type) {
-	case QLINK_BSS_FTYPE_BEACON:
-		frame_type = CFG80211_BSS_FTYPE_BEACON;
-		break;
-	case QLINK_BSS_FTYPE_PRESP:
-		frame_type = CFG80211_BSS_FTYPE_PRESP;
-		break;
-	default:
-		frame_type = CFG80211_BSS_FTYPE_UNKNOWN;
-	}
-
 	payload_len = len - sizeof(*sr);
 	tlv = (struct qlink_tlv_hdr *)sr->payload;
 
@@ -308,6 +296,17 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 			ie_len = tlv_value_len -
 				(sizeof(*ie_set) - sizeof(ie_set->hdr));
 
+			switch (ie_set->type) {
+			case QLINK_IE_SET_BEACON_IES:
+				frame_type = CFG80211_BSS_FTYPE_BEACON;
+				break;
+			case QLINK_IE_SET_PROBE_RESP_IES:
+				frame_type = CFG80211_BSS_FTYPE_PRESP;
+				break;
+			default:
+				frame_type = CFG80211_BSS_FTYPE_UNKNOWN;
+			}
+
 			if (ie_len) {
 				ies = ie_set->ie_data;
 				ies_len = ie_len;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index ecf493d..e584d2e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -872,12 +872,6 @@ struct qlink_event_rxmgmt {
 	u8 frame_data[0];
 } __packed;
 
-enum qlink_frame_type {
-	QLINK_BSS_FTYPE_UNKNOWN,
-	QLINK_BSS_FTYPE_BEACON,
-	QLINK_BSS_FTYPE_PRESP,
-};
-
 /**
  * struct qlink_event_scan_result - data for QLINK_EVENT_SCAN_RESULTS event
  *
@@ -887,7 +881,6 @@ enum qlink_frame_type {
  * @capab: capabilities field.
  * @bintval: beacon interval announced by discovered BSS.
  * @signal: signal strength.
- * @frame_type: frame type used to get scan result, see &enum qlink_frame_type.
  * @bssid: BSSID announced by discovered BSS.
  * @ssid_len: length of SSID announced by BSS.
  * @ssid: SSID announced by discovered BSS.
@@ -900,10 +893,10 @@ struct qlink_event_scan_result {
 	__le16 capab;
 	__le16 bintval;
 	s8 signal;
-	u8 frame_type;
-	u8 bssid[ETH_ALEN];
 	u8 ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 bssid[ETH_ALEN];
+	u8 rsvd[2];
 	u8 payload[0];
 } __packed;
 
-- 
2.9.5
