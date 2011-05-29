Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:32972 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1E2UGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:06:24 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id AC113C7DB8
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:22 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 6952CE51A5
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:21 +0300 (EEST)
Subject: [RFC PATCH 19/27] mac80211: rename ieee80211_if_managed to
	mac80211_if_managed
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:06:20 +0300
Message-ID: <20110529200620.16479.31739.stgit@localhost6.localdomain6> (sfid-20110529_220628_189406_F4B16348)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    6 ++--
 net/mac80211/main.c       |    2 +
 net/mac80211/mlme.c       |   66 +++++++++++++++++++++++----------------------
 net/mac80211/offchannel.c |    2 +
 net/mac80211/tx.c         |    6 ++--
 net/mac80211/util.c       |    2 +
 6 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index bc18582..aa927ba 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -336,7 +336,7 @@ struct mac80211_work {
 	u8 ie[0];
 };
 
-/* flags used in struct ieee80211_if_managed.flags */
+/* flags used in struct mac80211_if_managed.flags */
 enum mac80211_sta_flags {
 	MAC80211_STA_BEACON_POLL	= BIT(0),
 	MAC80211_STA_CONNECTION_POLL	= BIT(1),
@@ -349,7 +349,7 @@ enum mac80211_sta_flags {
 	MAC80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 };
 
-struct ieee80211_if_managed {
+struct mac80211_if_managed {
 	struct timer_list timer;
 	struct timer_list conn_mon_timer;
 	struct timer_list bcn_mon_timer;
@@ -596,7 +596,7 @@ struct ieee80211_sub_if_data {
 		struct mac80211_if_ap ap;
 		struct mac80211_if_wds wds;
 		struct mac80211_if_vlan vlan;
-		struct ieee80211_if_managed mgd;
+		struct mac80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
 		u32 mntr_flags;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 244f588..bd8c543 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -409,7 +409,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	struct in_device *idev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_bss_conf *bss_conf;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	int c = 0;
 
 	/* Make sure it's our interface that got changed */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d06ba14..55c97b5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -98,7 +98,7 @@ enum rx_mgmt_action {
 };
 
 /* utils */
-static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
+static inline void ASSERT_MGD_MTX(struct mac80211_if_managed *ifmgd)
 {
 	lockdep_assert_held(&ifmgd->mtx);
 }
@@ -113,7 +113,7 @@ static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
  * has happened -- the work that runs from this timer will
  * do that.
  */
-static void run_again(struct ieee80211_if_managed *ifmgd,
+static void run_again(struct mac80211_if_managed *ifmgd,
 			     unsigned long timeout)
 {
 	ASSERT_MGD_MTX(ifmgd);
@@ -134,7 +134,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (unlikely(!sdata->u.mgd.associated))
 		return;
@@ -272,7 +272,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   void *cookie, bool send_frame)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
@@ -386,7 +386,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -415,7 +415,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 
 	sdata = vif_to_sdata(vif);
 	ifmgd = &sdata->u.mgd;
@@ -439,7 +439,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (sdata->local->quiescing) {
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
@@ -457,7 +457,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
 						      cbss->channel->band);
 
@@ -612,7 +612,7 @@ static void ieee80211_change_ps(struct mac80211_local *local)
 
 static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *mgd = &sdata->u.mgd;
+	struct mac80211_if_managed *mgd = &sdata->u.mgd;
 	struct sta_info *sta = NULL;
 	u32 sta_flags = 0;
 
@@ -755,7 +755,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		container_of(work, struct mac80211_local,
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	unsigned long flags;
 	int q;
 
@@ -826,7 +826,7 @@ static void ieee80211_sta_wmm_params(struct mac80211_local *local,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
 	int count;
 	u8 *pos, uapsd_queues = 0;
@@ -1031,7 +1031,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   bool remove_sta, bool tx)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
@@ -1137,7 +1137,7 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!(ifmgd->flags & (MAC80211_STA_BEACON_POLL |
 			      MAC80211_STA_CONNECTION_POLL)))
@@ -1185,7 +1185,7 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
 	u8 *dst = ifmgd->associated->bssid;
 	u8 unicast_limit = max(1, max_probe_tries - 3);
@@ -1221,7 +1221,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 				   bool beacon)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool already = false;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -1281,7 +1281,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	const u8 *ssid;
 
@@ -1303,7 +1303,7 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
 static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	u8 bssid[ETH_ALEN];
 
@@ -1375,7 +1375,7 @@ static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *bssid = NULL;
 	u16 reason_code;
 
@@ -1404,7 +1404,7 @@ static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
 	if (len < 24 + 2)
@@ -1435,7 +1435,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
@@ -1658,7 +1658,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	struct ieee80211_rx_status *rx_status = (void *) skb->cb;
 	size_t baselen, len = skb->len;
 	struct ieee802_11_elems elems;
@@ -1710,7 +1710,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	size_t baselen;
 	struct ieee802_11_elems elems;
@@ -1903,7 +1903,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
@@ -2008,7 +2008,7 @@ static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
@@ -2023,7 +2023,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 					  u8 *bssid)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	ifmgd->flags &= ~(MAC80211_STA_CONNECTION_POLL |
 			  MAC80211_STA_BEACON_POLL);
@@ -2047,7 +2047,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
@@ -2143,7 +2143,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing)
@@ -2178,7 +2178,7 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 #ifdef CONFIG_PM
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/*
 	 * we need to use atomic bitops for the running bits
@@ -2204,7 +2204,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
@@ -2218,7 +2218,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
@@ -2412,7 +2412,7 @@ static enum work_done_result ieee80211_assoc_done(struct mac80211_work *wk,
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_bss *bss = (void *)req->bss->priv;
 	struct mac80211_work *wk;
 	const u8 *ssid;
@@ -2539,7 +2539,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 void *cookie)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_work *wk;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
@@ -2611,7 +2611,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
 
 	mutex_lock(&ifmgd->mtx);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 46814ee..0c97ef7 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -27,7 +27,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
 					   bool tell_ap)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	local->offchannel_ps_enabled = false;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 22c0e5a..f5c9bc0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -180,7 +180,7 @@ static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct mac80211_tx_data *tx)
 {
 	struct mac80211_local *local = tx->local;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
@@ -2318,7 +2318,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	struct ieee80211_pspoll *pspoll;
 	struct mac80211_local *local;
 	struct sk_buff *skb;
@@ -2359,7 +2359,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	struct mac80211_local *local;
 	struct sk_buff *skb;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5eef7cd..40b0fbe 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1321,7 +1321,7 @@ int ieee80211_reconfig(struct mac80211_local *local)
 	return 0;
 }
 
-static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
+static int check_mgd_smps(struct mac80211_if_managed *ifmgd,
 			  enum ieee80211_smps_mode *smps_mode)
 {
 	if (ifmgd->associated) {

