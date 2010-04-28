Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0D1Pkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 11:40:46 -0400
Subject: [PATCH] mac80211: notify driver about IBSS status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 17:40:43 +0200
Message-ID: <1272469243.3565.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (e.g. iwlwifi) need to know and try
to figure it out based on other things, but making
it explicit is definitely better.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Yay. cfg80211 really made things easy. Not a billion of code paths to go
through for ifdown and all that :)

 include/net/mac80211.h |    6 +++++-
 net/mac80211/ibss.c    |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -145,6 +145,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_BEACON_ENABLED: Beaconing should be
  *	enabled/disabled (beaconing modes)
  * @BSS_CHANGED_CQM: Connection quality monitor config changed
+ * @BSS_CHANGED_IBSS: IBSS join status changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -158,6 +159,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BEACON		= 1<<8,
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
 	BSS_CHANGED_CQM			= 1<<10,
+	BSS_CHANGED_IBSS		= 1<<11,
 };
 
 /**
@@ -167,6 +169,8 @@ enum ieee80211_bss_change {
  * to that BSS) that can change during the lifetime of the BSS.
  *
  * @assoc: association status
+ * @ibss_joined: indicates whether this station is part of an IBSS
+ *	or not
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble;
@@ -194,7 +198,7 @@ enum ieee80211_bss_change {
 struct ieee80211_bss_conf {
 	const u8 *bssid;
 	/* association related data */
-	bool assoc;
+	bool assoc, ibss_joined;
 	u16 aid;
 	/* erp related data */
 	bool use_cts_prot;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e6f3b0c..e47ad17 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -171,6 +171,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BSSID;
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
+	bss_change |= BSS_CHANGED_IBSS;
+	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
@@ -951,7 +953,9 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	kfree(sdata->u.ibss.ie);
 	skb = sdata->u.ibss.presp;
 	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+	sdata->vif.bss_conf.ibss_joined = false;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_IBSS);
 	synchronize_rcu();
 	kfree_skb(skb);
 


