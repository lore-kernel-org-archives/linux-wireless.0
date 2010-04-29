Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab0D3SIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:38 -0400
Subject: [PATCH v2] mac80211: notify driver about IBSS status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1272469243.3565.27.camel@jlt3.sipsolutions.net>
References: <1272469243.3565.27.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 11:18:27 +0200
Message-ID: <1272532707.3736.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (e.g. iwlwifi) need to know and try
to figure it out based on other things, but making
it explicit is definitely better.

When merging, first indicate to the driver that we
leave the old IBSS BSSID and then indicate joining
the new one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    6 +++++-
 net/mac80211/ibss.c    |   12 +++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

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
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -92,6 +92,12 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (memcmp(ifibss->bssid, bssid, ETH_ALEN))
 		sta_info_flush(sdata->local, sdata);
 
+	/* if merging, indicate to driver that we leave the old IBSS */
+	if (sdata->vif.bss_conf.ibss_joined) {
+		sdata->vif.bss_conf.ibss_joined = false;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
+	}
+
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
@@ -171,6 +177,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BSSID;
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
+	bss_change |= BSS_CHANGED_IBSS;
+	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
@@ -951,7 +959,9 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	kfree(sdata->u.ibss.ie);
 	skb = sdata->u.ibss.presp;
 	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+	sdata->vif.bss_conf.ibss_joined = false;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_IBSS);
 	synchronize_rcu();
 	kfree_skb(skb);
 


