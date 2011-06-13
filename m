Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56263 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1FMWhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:38 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 7967618CF6C
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:36 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 33FE01C6386
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:35 +0300 (EEST)
Subject: [PATCH v2 19/27] mac80211: rename ieee80211_if_managed to
	mac80211_if_managed
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:34 +0300
Message-ID: <20110613223734.10517.70222.stgit@localhost6.localdomain6> (sfid-20110614_005722_929985_E202E4DB)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
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
index d1efd25..d62abf4 100644
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
index 02b3778..6f99524 100644
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
@@ -266,7 +266,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   void *cookie, bool send_frame)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
@@ -380,7 +380,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -409,7 +409,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 
 	sdata = vif_to_sdata(vif);
 	ifmgd = &sdata->u.mgd;
@@ -433,7 +433,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (sdata->local->quiescing) {
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
@@ -451,7 +451,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
 						      cbss->channel->band);
 
@@ -606,7 +606,7 @@ static void ieee80211_change_ps(struct mac80211_local *local)
 
 static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *mgd = &sdata->u.mgd;
+	struct mac80211_if_managed *mgd = &sdata->u.mgd;
 	struct sta_info *sta = NULL;
 	u32 sta_flags = 0;
 
@@ -749,7 +749,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		container_of(work, struct mac80211_local,
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	unsigned long flags;
 	int q;
 
@@ -820,7 +820,7 @@ static void ieee80211_sta_wmm_params(struct mac80211_local *local,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
 	int count;
 	u8 *pos, uapsd_queues = 0;
@@ -1025,7 +1025,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   bool remove_sta, bool tx)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
@@ -1131,7 +1131,7 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!(ifmgd->flags & (MAC80211_STA_BEACON_POLL |
 			      MAC80211_STA_CONNECTION_POLL)))
@@ -1179,7 +1179,7 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
 	u8 *dst = ifmgd->associated->bssid;
 	u8 unicast_limit = max(1, max_probe_tries - 3);
@@ -1215,7 +1215,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 				   bool beacon)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool already = false;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -1275,7 +1275,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	const u8 *ssid;
 
@@ -1297,7 +1297,7 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
 static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	u8 bssid[ETH_ALEN];
 
@@ -1369,7 +1369,7 @@ static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *bssid = NULL;
 	u16 reason_code;
 
@@ -1398,7 +1398,7 @@ static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
 	if (len < 24 + 2)
@@ -1429,7 +1429,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
@@ -1652,7 +1652,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	struct ieee80211_rx_status *rx_status = (void *) skb->cb;
 	size_t baselen, len = skb->len;
 	struct ieee802_11_elems elems;
@@ -1704,7 +1704,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	size_t baselen;
 	struct ieee802_11_elems elems;
@@ -1897,7 +1897,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
@@ -2002,7 +2002,7 @@ static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
@@ -2017,7 +2017,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 					  u8 *bssid)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	ifmgd->flags &= ~(MAC80211_STA_CONNECTION_POLL |
 			  MAC80211_STA_BEACON_POLL);
@@ -2041,7 +2041,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
@@ -2137,7 +2137,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing)
@@ -2172,7 +2172,7 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 #ifdef CONFIG_PM
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/*
 	 * we need to use atomic bitops for the running bits
@@ -2198,7 +2198,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
@@ -2212,7 +2212,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
@@ -2406,7 +2406,7 @@ static enum work_done_result ieee80211_assoc_done(struct mac80211_work *wk,
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_bss *bss = (void *)req->bss->priv;
 	struct mac80211_work *wk;
 	const u8 *ssid;
@@ -2533,7 +2533,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 void *cookie)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_work *wk;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
@@ -2605,7 +2605,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
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
index 12ed372..f0218ac 100644
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
@@ -2323,7 +2323,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct mac80211_if_managed *ifmgd;
 	struct ieee80211_pspoll *pspoll;
 	struct mac80211_local *local;
 	struct sk_buff *skb;
@@ -2364,7 +2364,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
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

