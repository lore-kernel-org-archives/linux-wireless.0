Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657769;
	b=V9OAW0TE1ctdlAqe/QtidHNwngSOJNrzv7ghHbcBehoF1kTQkKAF+LdFCCOOMLCXGiTW
	 oKnfz6q8Ug6MAGddqbdPELzxJq3RXac7rj3jOip0uSj2iq/v8xFRbXkF4k8z6JRwCW1rB
	 vjETEtuAI+/3vhnpk8yePIMVbvMzs9raP+FaSGJpImDX3jqTLVhKYz3BX/wennGXi/qEJ
	 Ql05JZXDxMY9Yq7jX4Yy4E+EgWQcIzYdKZmHIB6BTQau+VJ49re8ePHxbVq+eF2dSVUi1
	 o+CezotetWlJlv0L0uUAcuzBUVwkrpxbXz38HJvlvR15C6XCmzRt0PFLr9e1kJHzRFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657769;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sZdlmHIW8cxEZOgNQZJn1GdC3G870Oba7IMMx33vyck=;
	b=nB1Jx/I2sgSlq1zKPVdRqpYGDw/PMRItjiv5YlAlLxAqgxgkY/CyHFwZgHMoUcmDMt4a
	 OY4nxcz7E0QewrlXffswDWtmGAQmlovqfcpvgQW/7L6709LDJYKR3MFOCLi+TNWpXrDq2
	 aitNb3Qhe7JBPUALvxmnnD5WYwPPJ7iI7u0oOj0IalVUP/HhiMhQa+LNfDRmX1szXDwXA
	 rYc8TizCfIyKTqCJhUmdO26bEnKy+dgWFZt3XnFbMq1moJ4fZmmIzNbmynG0EHb0VkhnZ
	 YlQFwRS/ZDaXphpNpUeJK7t7RAXhbBVK1Kl9zVETHMrGv7tXW7PGStsyHoJ2Rnr1Oww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=YIlJvqhN;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAE7606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=YIlJvqhN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=sZdlmHIW8cxEZOgNQZJn1GdC3G870Oba7IMMx33vyck=; t=1793657768; x=1794867368; 
	b=YIlJvqhN4K3NcqRW8w5w5Sc1HVROkOTxraaH5E11DRnFRVoHqcUUs6BEyTK0FiPj2a0C/fQbcWk
	ViCjHvxMko64M9mjX9Nsft0YSfdySDVIiH32uFOMz4R0efw6R8nVGNdXTbCELcYRrcXiWTMW4v0MN
	KvauvMBgxtzS7+enP3NiJCAYF2EX4gW38tzBY1zDGyKjuuSaNa8PLnbdb+3id58+e7+iizrXmsrKh
	kIssrJK4oQVx7p0SgKCijlNg7CgqNDT5knJfiy0iSaohMsS3qGUXMb0epmIxZuTx5w5hRn+ec79O7
	ehxEBZrfx3smU4nfNRwVtjiZWR3Jh+xXL7Ig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Jx-000000023ND-1uuH;
	Mon, 02 Nov 2026 23:16:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: add and use sta_from_pub()
Date: Mon,  2 Nov 2026 23:16:03 +0100
Message-ID: <20261102231603.db7b4b756449.Ibc6b2f1c95a7f3a2460d1d18f93b1254b475f47f@changeid>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

All the container_of() instances are tedious, add a new
inline helper and use it everywhere.

Assisted-by: spatch
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c              |  6 +++---
 net/mac80211/airtime.c             |  5 ++---
 net/mac80211/driver-ops.c          |  2 +-
 net/mac80211/he.c                  |  6 ++----
 net/mac80211/rate.c                |  6 +++---
 net/mac80211/rc80211_minstrel_ht.c |  4 ++--
 net/mac80211/rx.c                  | 13 ++++++-------
 net/mac80211/sta_info.c            | 14 +++++++-------
 net/mac80211/sta_info.h            |  5 +++++
 net/mac80211/status.c              |  8 ++++----
 net/mac80211/tx.c                  | 24 +++++++++++-------------
 net/mac80211/util.c                |  2 +-
 12 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..f9285ff081fc 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -555,7 +555,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 void ieee80211_refresh_tx_agg_session_timer(struct ieee80211_sta *pubsta,
 					    u16 tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct tid_ampdu_tx *tid_tx;
 
 	if (WARN_ON_ONCE(tid >= IEEE80211_NUM_TIDS))
@@ -600,7 +600,7 @@ static void sta_tx_agg_session_timer_expired(struct timer_list *t)
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 				  u16 timeout)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
@@ -868,7 +868,7 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index a4e1f33c0377..53a455b6425f 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: ISC
 /*
  * Copyright (C) 2019 Felix Fietkau <nbd@nbd.name>
- * Copyright (C) 2021-2022 Intel Corporation
+ * Copyright (C) 2021-2022, 2026 Intel Corporation
  */
 
 #include <net/mac80211.h>
@@ -838,8 +838,7 @@ u32 ieee80211_calc_expected_tx_airtime(struct ieee80211_hw *hw,
 		band = conf->def.chan->band;
 
 	if (pubsta) {
-		struct sta_info *sta = container_of(pubsta, struct sta_info,
-						    sta);
+		struct sta_info *sta = sta_from_pub(pubsta);
 		struct ieee80211_tx_rate *tx_rate = &sta->deflink.tx_stats.last_rate;
 		struct rate_info *ri = &sta->deflink.tx_stats.last_rate_info;
 		u32 duration;
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1f3e0765a8ab..12ea71036e4a 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -583,7 +583,7 @@ int drv_change_sta_links(struct ieee80211_local *local,
 			 struct ieee80211_sta *sta,
 			 u16 old_links, u16 new_links)
 {
-	struct sta_info *info = container_of(sta, struct sta_info, sta);
+	struct sta_info *info = sta_from_pub(sta);
 	struct link_sta_info *link_sta;
 	unsigned long links_to_add;
 	unsigned long links_to_rem;
diff --git a/net/mac80211/he.c b/net/mac80211/he.c
index 5acf482c177a..0278892ae91f 100644
--- a/net/mac80211/he.c
+++ b/net/mac80211/he.c
@@ -265,8 +265,7 @@ ieee80211_he_spr_ie_to_bss_conf(struct ieee80211_vif *vif,
 bool ieee80211_prepare_rx_omi_bw(struct ieee80211_link_sta *pub_link_sta,
 				 enum ieee80211_sta_rx_bandwidth bw)
 {
-	struct sta_info *sta = container_of(pub_link_sta->sta,
-					    struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pub_link_sta->sta);
 	struct ieee80211_local *local = sta->sdata->local;
 	struct link_sta_info *link_sta =
 		sdata_dereference(sta->link[pub_link_sta->link_id], sta->sdata);
@@ -318,8 +317,7 @@ EXPORT_SYMBOL_GPL(ieee80211_prepare_rx_omi_bw);
 
 void ieee80211_finalize_rx_omi_bw(struct ieee80211_link_sta *pub_link_sta)
 {
-	struct sta_info *sta = container_of(pub_link_sta->sta,
-					    struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pub_link_sta->sta);
 	struct ieee80211_local *local = sta->sdata->local;
 	struct link_sta_info *link_sta =
 		sdata_dereference(sta->link[pub_link_sta->link_id], sta->sdata);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 10e6ad537261..d74413fdaf06 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -88,7 +88,7 @@ void rate_control_tx_status(struct ieee80211_local *local,
 			    struct ieee80211_tx_status *st)
 {
 	struct rate_control_ref *ref = local->rate_ctrl;
-	struct sta_info *sta = container_of(st->sta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(st->sta);
 	void *priv_sta = sta->rate_ctrl_priv;
 	struct ieee80211_supported_band *sband;
 
@@ -442,7 +442,7 @@ static bool rate_control_send_low(struct ieee80211_sta *pubsta,
 			}
 			use_basicrate = true;
 		} else if (pubsta) {
-			sta = container_of(pubsta, struct sta_info, sta);
+			sta = sta_from_pub(pubsta);
 			if (ieee80211_vif_is_mesh(&sta->sdata->vif))
 				use_basicrate = true;
 		}
@@ -970,7 +970,7 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_sta_rates *old;
 	struct ieee80211_supported_band *sband;
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 45e7a7ea7690..d46b6780bfdb 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2010-2013 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2019-2022 Intel Corporation
+ * Copyright (C) 2019-2022, 2026 Intel Corporation
  */
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -1865,7 +1865,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 				vht_cap->vht_mcs.tx_mcs_map);
 	}
 
-	sta_info = container_of(sta, struct sta_info, sta);
+	sta_info = sta_from_pub(sta);
 	mi->use_short_preamble = test_sta_flag(sta_info, WLAN_STA_SHORT_PREAMBLE) &&
 				 sta_info->sdata->vif.bss_conf.use_short_preamble;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..acf1188ff426 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1724,7 +1724,7 @@ static void sta_ps_end(struct sta_info *sta)
 
 void ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	bool in_ps;
 
 	WARN_ON(!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS));
@@ -1743,7 +1743,7 @@ EXPORT_SYMBOL(ieee80211_sta_ps_transition);
 
 void ieee80211_sta_pspoll(struct ieee80211_sta *pubsta)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 
 	if (test_sta_flag(sta, WLAN_STA_SP))
 		return;
@@ -1757,7 +1757,7 @@ EXPORT_SYMBOL(ieee80211_sta_pspoll);
 
 void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	int ac = ieee80211_ac_from_tid(tid);
 
 	/*
@@ -4439,7 +4439,7 @@ void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
 
 	__skb_queue_head_init(&frames);
 
-	sta = container_of(pubsta, struct sta_info, sta);
+	sta = sta_from_pub(pubsta);
 
 	local = sta->sdata->local;
 	WARN_ONCE(local->hw.max_rx_aggregation_subframes > 64,
@@ -5289,7 +5289,7 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	if (!link_pubsta)
 		goto drop;
 
-	sta = container_of(link_pubsta->sta, struct sta_info, sta);
+	sta = sta_from_pub(link_pubsta->sta);
 	if (sta->sta.valid_links)
 		link_id = link_pubsta->link_id;
 	if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
@@ -5398,8 +5398,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	 */
 	if (ieee80211_is_data(fc)) {
 		if (link_pubsta) {
-			sta = container_of(link_pubsta->sta, struct sta_info,
-					   sta);
+			sta = sta_from_pub(link_pubsta->sta);
 			link_sta = rcu_dereference(sta->link[link_pubsta->link_id]);
 
 			rx.sdata = sta->sdata;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..6e9c06f3e4db 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2349,7 +2349,7 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta)
 void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *pubsta, bool block)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 
 	trace_api_sta_block_awake(sta->local, pubsta, block);
 
@@ -2380,7 +2380,7 @@ EXPORT_SYMBOL(ieee80211_sta_block_awake);
 
 void ieee80211_sta_eosp(struct ieee80211_sta *pubsta)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_local *local = sta->local;
 
 	trace_api_eosp(local, pubsta);
@@ -2391,7 +2391,7 @@ EXPORT_SYMBOL(ieee80211_sta_eosp);
 
 void ieee80211_send_eosp_nullfunc(struct ieee80211_sta *pubsta, int tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	enum ieee80211_frame_release_type reason;
 	bool more_data;
 
@@ -2408,7 +2408,7 @@ EXPORT_SYMBOL(ieee80211_send_eosp_nullfunc);
 void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 				u8 tid, bool buffered)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 
 	if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
 		return;
@@ -2427,7 +2427,7 @@ EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 				    u32 tx_airtime, u32 rx_airtime)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_local *local = sta->sdata->local;
 	u8 ac = ieee80211_ac_from_tid(tid);
 	u32 airtime = 0;
@@ -2495,7 +2495,7 @@ void __ieee80211_sta_recalc_aggregates(struct sta_info *sta, u16 active_links)
 
 void ieee80211_sta_recalc_aggregates(struct ieee80211_sta *pubsta)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 
 	__ieee80211_sta_recalc_aggregates(sta, sta->sdata->vif.active_links);
 }
@@ -3683,7 +3683,7 @@ void ieee80211_sta_set_max_amsdu_subframes(struct sta_info *sta,
 #ifdef CONFIG_LOCKDEP
 bool lockdep_sta_mutex_held(struct ieee80211_sta *pubsta)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 
 	return lockdep_is_held(&sta->local->hw.wiphy->mtx);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..0e8f7794fd01 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -793,6 +793,11 @@ struct sta_info {
 	struct ieee80211_sta sta;
 };
 
+static inline struct sta_info *sta_from_pub(struct ieee80211_sta *sta)
+{
+	return container_of(sta, struct sta_info, sta);
+}
+
 static inline int ieee80211_tdls_sta_link_id(struct sta_info *sta)
 {
 	/* TDLS STA can only have a single link */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 414979e2a1d9..5d1807ab46ef 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1013,7 +1013,7 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 	fc = hdr->frame_control;
 
 	if (status->sta) {
-		sta = container_of(status->sta, struct sta_info, sta);
+		sta = sta_from_pub(status->sta);
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
 			clear_sta_flag(sta, WLAN_STA_SP);
@@ -1246,7 +1246,7 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	ieee80211_tx_status_drop_invalid_rates(status);
 
 	if (pubsta) {
-		sta = container_of(pubsta, struct sta_info, sta);
+		sta = sta_from_pub(pubsta);
 
 		if (status->n_rates)
 			sta->deflink.tx_stats.last_rate_info =
@@ -1363,7 +1363,7 @@ void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
 			      struct ieee80211_tx_info *info)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_tx_status status = {
 		.info = info,
 		.sta = pubsta,
@@ -1379,7 +1379,7 @@ EXPORT_SYMBOL(ieee80211_tx_rate_update);
 
 void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
 				    num_packets, GFP_ATOMIC);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..22335ea362aa 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4031,7 +4031,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.sdata = vif_to_sdata(info->control.vif);
 
 	if (txq->sta) {
-		tx.sta = container_of(txq->sta, struct sta_info, sta);
+		tx.sta = sta_from_pub(txq->sta);
 
 		if (unlikely(ieee80211_drop_unauth_port(&tx))) {
 			I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
@@ -4067,8 +4067,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 	if (info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
-		struct sta_info *sta = container_of(txq->sta, struct sta_info,
-						    sta);
+		struct sta_info *sta = sta_from_pub(txq->sta);
 		u8 pn_offs = 0;
 
 		if (tx.key &&
@@ -4176,7 +4175,7 @@ ieee80211_txq_set_active(struct txq_info *txqi)
 	if (!txqi->txq.sta)
 		return;
 
-	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+	sta = sta_from_pub(txqi->txq.sta);
 	sta->airtime[txqi->txq.ac].last_active = jiffies;
 }
 
@@ -4188,7 +4187,7 @@ ieee80211_txq_keep_active(struct txq_info *txqi)
 	if (!txqi->txq.sta)
 		return false;
 
-	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+	sta = sta_from_pub(txqi->txq.sta);
 	if (ieee80211_sta_deficit(sta, txqi->txq.ac) >= 0)
 		return false;
 
@@ -4230,8 +4229,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 		found_eligible_txq = true;
 
 	if (txqi->txq.sta) {
-		struct sta_info *sta = container_of(txqi->txq.sta,
-						    struct sta_info, sta);
+		struct sta_info *sta = sta_from_pub(txqi->txq.sta);
 
 		if (ieee80211_sta_deficit(sta, txqi->txq.ac) < 0) {
 			sta->airtime[txqi->txq.ac].deficit +=
@@ -4319,7 +4317,7 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 	if (unlikely(txq->tid == IEEE80211_NUM_TIDS))
 		return true;
 
-	sta = container_of(txq->sta, struct sta_info, sta);
+	sta = sta_from_pub(txq->sta);
 	if (atomic_read(&sta->airtime[txq->ac].aql_tx_pending) <
 	    sta->airtime[txq->ac].aql_limit_low)
 		return true;
@@ -4346,7 +4344,7 @@ u32 ieee80211_txq_aql_pending(struct ieee80211_hw *hw,
 	if (!txq->sta)
 		return atomic_read(&local->aql_mc_pending_airtime);
 
-	sta = container_of(txq->sta, struct sta_info, sta);
+	sta = sta_from_pub(txq->sta);
 
 	return atomic_read(&sta->airtime[txq->ac].aql_tx_pending);
 }
@@ -4400,13 +4398,13 @@ bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 				       &local->active_txqs[ac]);
 			continue;
 		}
-		sta = container_of(iter->txq.sta, struct sta_info, sta);
+		sta = sta_from_pub(iter->txq.sta);
 		if (ieee80211_sta_deficit(sta, ac) < 0)
 			sta->airtime[ac].deficit += sta->airtime_weight;
 		list_move_tail(&iter->schedule_order, &local->active_txqs[ac]);
 	}
 
-	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+	sta = sta_from_pub(txqi->txq.sta);
 	if (sta->airtime[ac].deficit >= 0)
 		goto out;
 
@@ -6446,7 +6444,7 @@ EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
 int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	int ret;
@@ -6510,7 +6508,7 @@ EXPORT_SYMBOL(ieee80211_reserve_tid);
 
 void ieee80211_unreserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 {
-	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct sta_info *sta = sta_from_pub(pubsta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 44feb80274c6..2706f6a5a8fb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -904,7 +904,7 @@ __ieee80211_iterate_stations(struct ieee80211_hw *hw,
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	if (prev)
-		sta = container_of(prev, struct sta_info, sta);
+		sta = sta_from_pub(prev);
 
 	sta = list_prepare_entry(sta, &local->sta_list, list);
 	list_for_each_entry_continue(sta, &local->sta_list, list) {
-- 
2.56.0

