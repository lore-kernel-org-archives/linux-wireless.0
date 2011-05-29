Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:54483 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab1E2UGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:06:30 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 5F60AEBE18
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:29 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 3D4862BD44
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:28 +0300 (EEST)
Subject: [RFC PATCH 20/27] mac80211: rename ieee80211_if_ibss to
	mac80211_if_ibss
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:06:27 +0300
Message-ID: <20110529200627.16479.2869.stgit@localhost6.localdomain6> (sfid-20110529_220633_916802_5DD43DF7)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/ibss.c       |   24 ++++++++++++------------
 net/mac80211/mac80211_i.h |    4 ++--
 net/mac80211/tx.c         |    2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 40f14f2..5ae5e73 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -67,7 +67,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 	int rates, i;
 	struct sk_buff *skb;
@@ -420,7 +420,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid,u8 *addr, u32 supp_rates,
 					gfp_t gfp)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
@@ -496,7 +496,7 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -525,7 +525,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	u8 bssid[ETH_ALEN];
 	u16 capability;
 	int i;
@@ -566,7 +566,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_channel *chan = NULL;
@@ -657,7 +657,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 					struct sk_buff *req)
 {
 	struct ieee80211_mgmt *mgmt = (void *)req->data;
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 	int tx_last_beacon, len = req->len;
 	struct sk_buff *skb;
@@ -801,7 +801,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	mutex_lock(&ifibss->mtx);
 
@@ -833,7 +833,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
@@ -847,7 +847,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 #ifdef CONFIG_PM
 void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	if (del_timer_sync(&ifibss->timer))
 		ifibss->timer_running = true;
@@ -855,7 +855,7 @@ void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	if (ifibss->timer_running) {
 		add_timer(&ifibss->timer);
@@ -866,7 +866,7 @@ void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
@@ -957,7 +957,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	u16 capability;
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index aa927ba..b609d9a 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -419,7 +419,7 @@ struct mac80211_if_managed {
 	int last_cqm_event_signal;
 };
 
-struct ieee80211_if_ibss {
+struct mac80211_if_ibss {
 	struct timer_list timer;
 
 	struct mutex mtx;
@@ -597,7 +597,7 @@ struct ieee80211_sub_if_data {
 		struct mac80211_if_wds wds;
 		struct mac80211_if_vlan vlan;
 		struct mac80211_if_managed mgd;
-		struct ieee80211_if_ibss ibss;
+		struct mac80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
 		u32 mntr_flags;
 	} u;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f5c9bc0..2a8c1c0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2231,7 +2231,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		} else
 			goto out;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+		struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 		struct ieee80211_hdr *hdr;
 		struct sk_buff *presp = rcu_dereference(ifibss->presp);
 

