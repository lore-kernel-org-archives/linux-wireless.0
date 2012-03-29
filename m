Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2C2Obr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 10:31:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: sanity check for null SSID
Date: Thu, 29 Mar 2012 16:30:41 +0200
Message-Id: <1333031441-9754-1-git-send-email-sgruszka@redhat.com> (sfid-20120329_163150_542973_FA732D47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While associated we should never have empty SSID, but life can be full
of surprises, and is allways better to print a warning than crash.

Before memcpy() in ieee80211_probereq_get() check ssid_len instead of
ssid pointer, sice pointer it always passed by "ssidie + 2" expression
to send probe functions, so practically never can be NULL.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |   19 ++++++++++++++++---
 net/mac80211/tx.c   |    2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 576fb25..f1027db 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1567,9 +1567,16 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
 	} else {
+		int ssid_len;
+
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
-		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0,
-					 (u32) -1, true, false);
+		if (WARN_ON_ONCE(ssid == NULL))
+			ssid_len = 0;
+		else
+			ssid_len = ssid[1];
+
+		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
+					 0, (u32) -1, true, false);
 	}
 
 	ifmgd->probe_send_count++;
@@ -1643,6 +1650,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	const u8 *ssid;
+	int ssid_len;
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return NULL;
@@ -1653,8 +1661,13 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 		return NULL;
 
 	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+	if (WARN_ON_ONCE(ssid == NULL))
+		ssid_len = 0;
+	else
+		ssid_len = ssid[1];
+
 	skb = ieee80211_build_probe_req(sdata, ifmgd->associated->bssid,
-					(u32) -1, ssid + 2, ssid[1],
+					(u32) -1, ssid + 2, ssid_len,
 					NULL, 0, true);
 
 	return skb;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..d84818e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2603,7 +2603,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 	pos = skb_put(skb, ie_ssid_len);
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = ssid_len;
-	if (ssid)
+	if (ssid_len)
 		memcpy(pos, ssid, ssid_len);
 	pos += ssid_len;
 
-- 
1.7.1

