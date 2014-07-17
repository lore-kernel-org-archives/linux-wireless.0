Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63891 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778AbaGQOOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:16 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so2032055wgh.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:13 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/15] mac80211: add QoS IE during TDLS setup start
Date: Thu, 17 Jul 2014 17:14:23 +0300
Message-Id: <1405606471-30128-8-git-send-email-arik@wizery.com> (sfid-20140717_161424_857962_2E33C6AA)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If QoS is supported by the card, add an appropriate IE to TDLS setup-
request and setup-response frames.

Consolidate the setting of the WMM info IE across mac80211.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        | 13 ++-----------
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 11 +----------
 net/mac80211/tdls.c        |  7 +++++++
 net/mac80211/util.c        | 15 +++++++++++++++
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 713485f..9713dc5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -189,17 +189,8 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 						 chandef, 0);
 	}
 
-	if (local->hw.queues >= IEEE80211_NUM_ACS) {
-		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
-		*pos++ = 7; /* len */
-		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
-		*pos++ = 0x50;
-		*pos++ = 0xf2;
-		*pos++ = 2; /* WME */
-		*pos++ = 0; /* WME info */
-		*pos++ = 1; /* WME ver */
-		*pos++ = 0; /* U-APSD no in use */
-	}
+	if (local->hw.queues >= IEEE80211_NUM_ACS)
+		pos = ieee80211_add_wmm_info_ie(pos, 0); /* U-APSD not in use */
 
 	presp->head_len = pos - presp->head;
 	if (WARN_ON(presp->head_len > frame_len))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9e025e1..cb87476 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1824,6 +1824,7 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic,
 				enum ieee80211_band band);
+u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 
 /* channel management */
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 931330b..d863ff8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -830,16 +830,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			qos_info = 0;
 		}
 
-		pos = skb_put(skb, 9);
-		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
-		*pos++ = 7; /* len */
-		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
-		*pos++ = 0x50;
-		*pos++ = 0xf2;
-		*pos++ = 2; /* WME */
-		*pos++ = 0; /* WME info */
-		*pos++ = 1; /* WME ver */
-		*pos++ = qos_info;
+		pos = ieee80211_add_wmm_info_ie(skb_put(skb, 9), qos_info);
 	}
 
 	/* add any remaining custom (i.e. vendor specific here) IEs */
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 398a413..bfd8fc4 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -100,6 +100,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 				   const u8 *extra_ies, size_t extra_ies_len)
 {
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	struct ieee80211_local *local = sdata->local;
 	size_t offset = 0, noffset;
 	u8 *pos;
 
@@ -126,6 +127,11 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_tdls_add_ext_capab(skb);
 
+	/* add the QoS element if we support it */
+	if (local->hw.queues >= IEEE80211_NUM_ACS &&
+	    action_code != WLAN_PUB_ACTION_TDLS_DISCOVER_RES)
+		ieee80211_add_wmm_info_ie(skb_put(skb, 9), 0); /* no U-APSD */
+
 	/* add any custom IEs that go before HT capabilities */
 	if (extra_ies_len) {
 		static const u8 before_ht_cap[] = {
@@ -310,6 +316,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 				sizeof(struct ieee80211_tdls_data)) +
 			    50 + /* supported rates */
 			    7 + /* ext capab */
+			    26 + /* max(WMM-info, WMM-param) */
 			    extra_ies_len +
 			    sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index df1bb7e..725af7a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3083,3 +3083,18 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 
 	return max_num_different_channels;
 }
+
+u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo)
+{
+	*buf++ = WLAN_EID_VENDOR_SPECIFIC;
+	*buf++ = 7; /* len */
+	*buf++ = 0x00; /* Microsoft OUI 00:50:F2 */
+	*buf++ = 0x50;
+	*buf++ = 0xf2;
+	*buf++ = 2; /* WME */
+	*buf++ = 0; /* WME info */
+	*buf++ = 1; /* WME ver */
+	*buf++ = qosinfo; /* U-APSD no in use */
+
+	return buf;
+}
-- 
1.9.1

