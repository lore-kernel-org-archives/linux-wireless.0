Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45449 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1FMWhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:23 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 82613EBBCC
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:22 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 497FC2BD43
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:21 +0300 (EEST)
Subject: [PATCH v2 17/27] mac80211: rename ieee80211_work to mac80211_work
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:15 +0300
Message-ID: <20110613223715.10517.94732.stgit@localhost6.localdomain6> (sfid-20110614_005723_017885_DBF89740)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/cfg.c        |    6 +++---
 net/mac80211/iface.c      |    2 +-
 net/mac80211/mac80211_i.h |    8 ++++----
 net/mac80211/mlme.c       |   14 +++++++-------
 net/mac80211/status.c     |    2 +-
 net/mac80211/work.c       |   44 ++++++++++++++++++++++----------------------
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a05bc6f..22d8ccb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1798,7 +1798,7 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 }
 
 static enum work_done_result
-ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
+ieee80211_offchan_tx_done(struct mac80211_work *wk, struct sk_buff *skb)
 {
 	/*
 	 * Use the data embedded in the work struct for reporting
@@ -1829,7 +1829,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
 	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 		    IEEE80211_TX_CTL_REQ_TX_STATUS;
@@ -1996,7 +1996,7 @@ static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	int ret = -ENOENT;
 
 	mutex_lock(&local->mtx);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5c44737..f28f68d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1274,7 +1274,7 @@ u32 __ieee80211_recalc_idle(struct mac80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
 	bool working = false, scanning = false, hw_roc = false;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index eb95457..a697921 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -279,14 +279,14 @@ enum work_done_result {
 	WORK_DONE_REQUEUE,
 };
 
-struct ieee80211_work {
+struct mac80211_work {
 	struct list_head list;
 
 	struct rcu_head rcu_head;
 
 	struct ieee80211_sub_if_data *sdata;
 
-	enum work_done_result (*done)(struct ieee80211_work *wk,
+	enum work_done_result (*done)(struct mac80211_work *wk,
 				      struct sk_buff *skb);
 
 	struct ieee80211_channel *chan;
@@ -1371,8 +1371,8 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 
 /* internal work items */
 void ieee80211_work_init(struct mac80211_local *local);
-void ieee80211_add_work(struct ieee80211_work *wk);
-void free_work(struct ieee80211_work *wk);
+void ieee80211_add_work(struct mac80211_work *wk);
+void free_work(struct mac80211_work *wk);
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6902847..d695aa2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1425,7 +1425,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 }
 
 
-static bool ieee80211_assoc_success(struct ieee80211_work *wk,
+static bool ieee80211_assoc_success(struct mac80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
@@ -1958,7 +1958,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
 	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
 		struct mac80211_local *local = sdata->local;
-		struct ieee80211_work *wk;
+		struct mac80211_work *wk;
 
 		mutex_lock(&local->mtx);
 		list_for_each_entry(wk, &local->work_list, list) {
@@ -2268,7 +2268,7 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 
 /* config hooks */
 static enum work_done_result
-ieee80211_probe_auth_done(struct ieee80211_work *wk,
+ieee80211_probe_auth_done(struct mac80211_work *wk,
 			  struct sk_buff *skb)
 {
 	if (!skb) {
@@ -2294,7 +2294,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req)
 {
 	const u8 *ssid;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	u16 auth_alg;
 
 	if (req->local_state_change)
@@ -2357,7 +2357,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
+static enum work_done_result ieee80211_assoc_done(struct mac80211_work *wk,
 						  struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt;
@@ -2408,7 +2408,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_bss *bss = (void *)req->bss->priv;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	const u8 *ssid;
 	int i;
 
@@ -2534,7 +2534,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 {
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 108e6b1..86d971b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -327,7 +327,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
-		struct ieee80211_work *wk;
+		struct mac80211_work *wk;
 		u64 cookie = (unsigned long)skb;
 
 		rcu_read_lock();
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 4168d4a..197704a 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -65,7 +65,7 @@ static void run_again(struct mac80211_local *local,
 		mod_timer(&local->work_timer, timeout);
 }
 
-void free_work(struct ieee80211_work *wk)
+void free_work(struct mac80211_work *wk)
 {
 	kfree_rcu(wk, rcu_head);
 }
@@ -184,7 +184,7 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 }
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_work *wk)
+				 struct mac80211_work *wk)
 {
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -402,7 +402,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_remove_auth_bss(struct mac80211_local *local,
-				      struct ieee80211_work *wk)
+				      struct mac80211_work *wk)
 {
 	struct cfg80211_bss *cbss;
 	u16 capa_val = WLAN_CAPABILITY_ESS;
@@ -422,7 +422,7 @@ static void ieee80211_remove_auth_bss(struct mac80211_local *local,
 }
 
 static enum work_action __must_check
-ieee80211_direct_probe(struct ieee80211_work *wk)
+ieee80211_direct_probe(struct mac80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
@@ -460,7 +460,7 @@ ieee80211_direct_probe(struct ieee80211_work *wk)
 
 
 static enum work_action __must_check
-ieee80211_authenticate(struct ieee80211_work *wk)
+ieee80211_authenticate(struct mac80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
@@ -493,7 +493,7 @@ ieee80211_authenticate(struct ieee80211_work *wk)
 }
 
 static enum work_action __must_check
-ieee80211_associate(struct ieee80211_work *wk)
+ieee80211_associate(struct mac80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
@@ -525,7 +525,7 @@ ieee80211_associate(struct ieee80211_work *wk)
 }
 
 static enum work_action __must_check
-ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
+ieee80211_remain_on_channel_timeout(struct mac80211_work *wk)
 {
 	/*
 	 * First time we run, do nothing -- the generic code will
@@ -545,7 +545,7 @@ ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
 }
 
 static enum work_action __must_check
-ieee80211_offchannel_tx(struct ieee80211_work *wk)
+ieee80211_offchannel_tx(struct mac80211_work *wk)
 {
 	if (!wk->started) {
 		wk->timeout = jiffies + msecs_to_jiffies(wk->offchan_tx.wait);
@@ -564,7 +564,7 @@ ieee80211_offchannel_tx(struct ieee80211_work *wk)
 }
 
 static enum work_action __must_check
-ieee80211_assoc_beacon_wait(struct ieee80211_work *wk)
+ieee80211_assoc_beacon_wait(struct mac80211_work *wk)
 {
 	if (wk->started)
 		return WORK_ACT_TIMEOUT;
@@ -579,7 +579,7 @@ ieee80211_assoc_beacon_wait(struct ieee80211_work *wk)
 	return WORK_ACT_NONE;
 }
 
-static void ieee80211_auth_challenge(struct ieee80211_work *wk,
+static void ieee80211_auth_challenge(struct mac80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
@@ -599,7 +599,7 @@ static void ieee80211_auth_challenge(struct ieee80211_work *wk,
 }
 
 static enum work_action __must_check
-ieee80211_rx_mgmt_auth(struct ieee80211_work *wk,
+ieee80211_rx_mgmt_auth(struct mac80211_work *wk,
 		       struct ieee80211_mgmt *mgmt, size_t len)
 {
 	u16 auth_alg, auth_transaction, status_code;
@@ -646,7 +646,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_work *wk,
 }
 
 static enum work_action __must_check
-ieee80211_rx_mgmt_assoc_resp(struct ieee80211_work *wk,
+ieee80211_rx_mgmt_assoc_resp(struct mac80211_work *wk,
 			     struct ieee80211_mgmt *mgmt, size_t len,
 			     bool reassoc)
 {
@@ -704,7 +704,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_work *wk,
 }
 
 static enum work_action __must_check
-ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
+ieee80211_rx_mgmt_probe_resp(struct mac80211_work *wk,
 			     struct ieee80211_mgmt *mgmt, size_t len,
 			     struct ieee80211_rx_status *rx_status)
 {
@@ -729,7 +729,7 @@ ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
 }
 
 static enum work_action __must_check
-ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
+ieee80211_rx_mgmt_beacon(struct mac80211_work *wk,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
@@ -752,7 +752,7 @@ static void ieee80211_work_rx_queued_mgmt(struct mac80211_local *local,
 {
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	enum work_action rma = WORK_ACT_NONE;
 	u16 fc;
 
@@ -910,7 +910,7 @@ static void ieee80211_work_work(struct work_struct *work)
 	struct mac80211_local *local =
 		container_of(work, struct mac80211_local, work_work);
 	struct sk_buff *skb;
-	struct ieee80211_work *wk, *tmp;
+	struct mac80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum work_action rma;
 	bool remain_off_channel = false;
@@ -1109,7 +1109,7 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 }
 
-void ieee80211_add_work(struct ieee80211_work *wk)
+void ieee80211_add_work(struct mac80211_work *wk)
 {
 	struct mac80211_local *local;
 
@@ -1147,7 +1147,7 @@ void ieee80211_work_init(struct mac80211_local *local)
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	bool cleanup = false;
 
 	mutex_lock(&local->mtx);
@@ -1180,7 +1180,7 @@ ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 {
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 	u16 fc;
 
 	if (skb->len < 24)
@@ -1212,7 +1212,7 @@ ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 	return RX_CONTINUE;
 }
 
-static enum work_done_result ieee80211_remain_done(struct ieee80211_work *wk,
+static enum work_done_result ieee80211_remain_done(struct mac80211_work *wk,
 						   struct sk_buff *skb)
 {
 	/*
@@ -1230,7 +1230,7 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 				   enum nl80211_channel_type channel_type,
 				   unsigned int duration, u64 *cookie)
 {
-	struct ieee80211_work *wk;
+	struct mac80211_work *wk;
 
 	wk = kzalloc(sizeof(*wk), GFP_KERNEL);
 	if (!wk)
@@ -1255,7 +1255,7 @@ int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 					  u64 cookie)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_work *wk, *tmp;
+	struct mac80211_work *wk, *tmp;
 	bool found = false;
 
 	mutex_lock(&local->mtx);

