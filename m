Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2757 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:43:18 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20578.31128.207010.660580@gargle.gargle.HOWL> (sfid-20120926_054322_128189_D4D138FB)
Date: Wed, 26 Sep 2012 09:12:16 +0530
To: <johannes.berg@intel.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Notify new IBSS network creation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialization of beacon transmission in IBSS mode depends
on whether a new BSS is being created or joined. When joining
an existing IBSS network, beaconing has to start only after
a TSF-sync has happened - this is explained in 11.1.4.

Introduce a new parameter in the BSS information structure to
indicate creator/joiner mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 include/net/mac80211.h |  2 ++
 net/mac80211/ibss.c    | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82558c8..512dc4b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -223,6 +223,7 @@ enum ieee80211_rssi_event {
  * @assoc: association status
  * @ibss_joined: indicates whether this station is part of an IBSS
  *	or not
+ * @ibss_creator: indicates if a new IBSS network is being created
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble;
@@ -278,6 +279,7 @@ struct ieee80211_bss_conf {
 	const u8 *bssid;
 	/* association related data */
 	bool assoc, ibss_joined;
+	bool ibss_creator;
 	u16 aid;
 	/* erp related data */
 	bool use_cts_prot;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5f3620f..5c6c773 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -39,7 +39,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
 				      const u32 basic_rates,
-				      const u16 capability, u64 tsf)
+				      const u16 capability, u64 tsf,
+				      bool creator)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -72,6 +73,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* if merging, indicate to driver that we leave the old IBSS */
 	if (sdata->vif.bss_conf.ibss_joined) {
 		sdata->vif.bss_conf.ibss_joined = false;
+		sdata->vif.bss_conf.ibss_creator = false;
 		netif_carrier_off(sdata->dev);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
 	}
@@ -197,6 +199,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_HT;
 	bss_change |= BSS_CHANGED_IBSS;
 	sdata->vif.bss_conf.ibss_joined = true;
+	sdata->vif.bss_conf.ibss_creator = creator;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
@@ -249,7 +252,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  cbss->channel,
 				  basic_rates,
 				  cbss->capability,
-				  cbss->tsf);
+				  cbss->tsf,
+				  false);
 }
 
 static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
@@ -715,7 +719,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, ifibss->basic_rates,
-				  capability, 0);
+				  capability, 0, true);
 }
 
 /*
@@ -1197,6 +1201,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 					lockdep_is_held(&sdata->u.ibss.mtx));
 	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
+	sdata->vif.bss_conf.ibss_creator = false;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
 	synchronize_rcu();
-- 
1.7.12

