Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab2EPV4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:56:07 -0400
Message-ID: <1337204599.18519.22.camel@jlt3.sipsolutions.net> (sfid-20120516_235611_735261_C13DE6EE)
Subject: [PATCH] mac80211: simplify association HT parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 16 May 2012 23:43:19 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of passing around the entire HT information
IE, extract only the HT parameters field and disable
HT if the HT information IE isn't present and well-
formed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm convinced I sent this, seems it got lost somewhere :)

 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/mlme.c        |   26 +++++++++++---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-05-15 20:14:44.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-05-15 20:14:51.000000000 +0200
@@ -399,7 +399,6 @@ struct ieee80211_mgd_auth_data {
 struct ieee80211_mgd_assoc_data {
 	struct cfg80211_bss *bss;
 	const u8 *supp_rates;
-	const u8 *ht_operation_ie;
 
 	unsigned long timeout;
 	int tries;
@@ -414,6 +413,8 @@ struct ieee80211_mgd_assoc_data {
 	bool sent_assoc;
 	bool synced;
 
+	u8 ap_ht_param;
+
 	size_t ie_len;
 	u8 ie[];
 };
--- a/net/mac80211/mlme.c	2012-05-15 20:14:44.000000000 +0200
+++ b/net/mac80211/mlme.c	2012-05-15 20:14:51.000000000 +0200
@@ -258,12 +258,11 @@ static int ieee80211_compatible_rates(co
 }
 
 static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb, const u8 *ht_oper_ie,
+				struct sk_buff *skb, u8 ap_ht_param,
 				struct ieee80211_supported_band *sband,
 				struct ieee80211_channel *channel,
 				enum ieee80211_smps_mode smps)
 {
-	struct ieee80211_ht_operation *ht_oper;
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap;
@@ -271,21 +270,13 @@ static void ieee80211_add_ht_ie(struct i
 
 	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
 
-	if (!ht_oper_ie)
-		return;
-
-	if (ht_oper_ie[1] < sizeof(struct ieee80211_ht_operation))
-		return;
-
 	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
 	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
 
-	ht_oper = (struct ieee80211_ht_operation *)(ht_oper_ie + 2);
-
 	/* determine capability flags */
 	cap = ht_cap.cap;
 
-	switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	switch (ap_ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
 			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -509,7 +500,7 @@ static void ieee80211_send_assoc(struct
 	}
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_operation_ie,
+		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
 				    sband, local->oper_channel, ifmgd->ap_smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
@@ -3276,7 +3267,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_mgd_assoc_data *assoc_data;
 	struct ieee80211_supported_band *sband;
-	const u8 *ssidie;
+	const u8 *ssidie, *ht_ie;
 	int i, err;
 
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
@@ -3363,8 +3354,13 @@ int ieee80211_mgd_assoc(struct ieee80211
 			  (local->hw.queues >= IEEE80211_NUM_ACS);
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
-	assoc_data->ht_operation_ie =
-		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
+
+	ht_ie = ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
+	if (ht_ie && ht_ie[1] >= sizeof(struct ieee80211_ht_operation))
+		assoc_data->ap_ht_param =
+			((struct ieee80211_ht_operation *)(ht_ie + 2))->ht_param;
+	else
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {


