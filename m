Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43660 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787AbaGQOOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:10 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so7210177wiv.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/15] mac80211: split extra TDLS IEs in setup frames
Date: Thu, 17 Jul 2014 17:14:20 +0300
Message-Id: <1405606471-30128-5-git-send-email-arik@wizery.com> (sfid-20140717_161505_268890_B0FE2E3F)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building TDLS setup frames, use the IE order mandates in the
specification, splitting extra IEs coming from usermode.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index b61448a..8d6c928 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -78,25 +78,91 @@ static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, const u8 *src_addr,
 	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
 }
 
+static void
+ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb, const u8 *peer,
+				   u8 action_code, const u8 *extra_ies,
+				   size_t extra_ies_len)
+{
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	size_t offset = 0, noffset;
+	u8 *pos;
+
+	ieee80211_add_srates_ie(sdata, skb, false, band);
+	ieee80211_add_ext_srates_ie(sdata, skb, false, band);
+
+	/* add any custom IEs that go before Extended Capabilities */
+	if (extra_ies_len) {
+		static const u8 before_ext_cap[] = {
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_COUNTRY,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_ext_cap,
+					     ARRAY_SIZE(before_ext_cap),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	ieee80211_tdls_add_ext_capab(skb);
+
+	/* add any custom IEs that go before HT capabilities */
+	if (extra_ies_len) {
+		static const u8 before_ht_cap[] = {
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_COUNTRY,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+			WLAN_EID_EXT_CAPABILITY,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_FAST_BSS_TRANSITION,
+			WLAN_EID_TIMEOUT_INTERVAL,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_ht_cap,
+					     ARRAY_SIZE(before_ht_cap),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	/* add any remaining IEs */
+	if (extra_ies_len) {
+		noffset = extra_ies_len;
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+	}
+}
+
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, bool initiator,
 				   const u8 *extra_ies, size_t extra_ies_len)
 {
 	const u8 *init_addr, *rsp_addr;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
 	case WLAN_TDLS_SETUP_RESPONSE:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		ieee80211_add_srates_ie(sdata, skb, false, band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
-		ieee80211_tdls_add_ext_capab(skb);
+		ieee80211_tdls_add_setup_start_ies(sdata, skb, peer,
+						   action_code, extra_ies,
+						   extra_ies_len);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
+		if (extra_ies_len)
+			memcpy(skb_put(skb, extra_ies_len), extra_ies,
+			       extra_ies_len);
 		break;
 	}
 
@@ -108,9 +174,6 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 		rsp_addr = sdata->vif.addr;
 	}
 
-	if (extra_ies_len)
-		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
-
 	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
 				   sdata->u.mgd.bssid);
 }
-- 
1.9.1

