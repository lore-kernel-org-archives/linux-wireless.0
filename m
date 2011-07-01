Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab1GAWT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:19:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Qcm3b-0007OI-Ih
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:19:27 +0200
Subject: [RFC] wpa_supplicant/nl80211: support GTK rekey offload
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110701221321.478559320@sipsolutions.net> (sfid-20110702_001559_666877_5A8663AA)
References: <20110701221321.478559320@sipsolutions.net>
	 (sfid-20110702_001559_666877_5A8663AA)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 00:19:30 +0200
Message-ID: <1309558770.3888.6.camel@jlt3.sipsolutions.net> (sfid-20110702_001941_852128_B509616E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support to wpa_supplicant for device-based
GTK rekeying. In order to support that, pass the
KEK, KCK and replay counter to the driver, and
handle rekey events that update the latter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Not included is a massive nl80211_copy.h update, that'd just pollute the
patch as you can see in the diffstat...

 src/drivers/driver.h         |   23 +
 src/drivers/driver_nl80211.c |   76 ++++++
 src/drivers/nl80211_copy.h   |  504 +++++++++++++++++++++++++++++++++++++++++--
 src/rsn_supp/wpa.c           |    7 
 src/rsn_supp/wpa.h           |    9 
 src/rsn_supp/wpa_i.h         |    8 
 wpa_supplicant/driver_i.h    |    9 
 wpa_supplicant/events.c      |    9 
 wpa_supplicant/wpas_glue.c   |   10 
 9 files changed, 634 insertions(+), 21 deletions(-)

--- a/src/drivers/driver.h	2011-07-01 19:18:00.000000000 +0200
+++ b/src/drivers/driver.h	2011-07-01 23:40:06.000000000 +0200
@@ -2253,6 +2253,12 @@ struct wpa_driver_ops {
 	 * implementation, there is no need to implement this function.
 	 */
 	int (*set_authmode)(void *priv, int authmode);
+
+	/**
+	 * set_rekey_info - set rekey information
+	 */
+	void (*set_rekey_info)(void *priv, const u8 *kek, const u8 *kck,
+			       const u8 *replay_ctr);
 };
 
 
@@ -2655,7 +2661,14 @@ enum wpa_event_type {
 	/**
 	 * EVENT_IBSS_PEER_LOST - IBSS peer not reachable anymore
 	 */
-	EVENT_IBSS_PEER_LOST
+	EVENT_IBSS_PEER_LOST,
+
+	/**
+	 * EVENT_DRIVER_GTK_REKEY - device/driver did rekey
+	 *
+	 * This event carries the new replay counter.
+	 */
+	EVENT_DRIVER_GTK_REKEY
 };
 
 
@@ -3187,6 +3200,14 @@ union wpa_event_data {
 	struct ibss_peer_lost {
 		u8 peer[ETH_ALEN];
 	} ibss_peer_lost;
+
+	/**
+	 * struct driver_gtk_rekey
+	 */
+	struct driver_gtk_rekey {
+		const u8 *bssid;
+		const u8 *replay_ctr;
+	} driver_gtk_rekey;
 };
 
 /**
--- a/wpa_supplicant/driver_i.h	2011-07-01 19:18:01.000000000 +0200
+++ b/wpa_supplicant/driver_i.h	2011-07-01 19:23:37.000000000 +0200
@@ -704,4 +704,13 @@ static inline int wpa_drv_tdls_oper(stru
 	return wpa_s->driver->tdls_oper(wpa_s->drv_priv, oper, peer);
 }
 
+static inline void wpa_drv_set_rekey_info(struct wpa_supplicant *wpa_s,
+					  const u8 *kek, const u8 *kck,
+					  const u8 *replay_ctr)
+{
+	if (!wpa_s->driver->set_rekey_info)
+		return;
+	wpa_s->driver->set_rekey_info(wpa_s->drv_priv, kek, kck, replay_ctr);
+}
+
 #endif /* DRIVER_I_H */
--- a/src/rsn_supp/wpa.c	2011-07-01 19:18:00.000000000 +0200
+++ b/src/rsn_supp/wpa.c	2011-07-01 19:23:37.000000000 +0200
@@ -1172,6 +1172,8 @@ static void wpa_supplicant_process_3_of_
 		goto failed;
 	}
 
+	wpa_sm_set_rekey_offload(sm);
+
 	return;
 
 failed:
@@ -2642,3 +2644,8 @@ int wpa_sm_has_ptk(struct wpa_sm *sm)
 		return 0;
 	return sm->ptk_set;
 }
+
+void wpa_sm_update_replay_ctr(struct wpa_sm *sm, const u8 *replay_ctr)
+{
+	os_memcpy(sm->rx_replay_counter, replay_ctr, WPA_REPLAY_COUNTER_LEN);
+}
--- a/src/rsn_supp/wpa_i.h	2011-07-01 19:18:00.000000000 +0200
+++ b/src/rsn_supp/wpa_i.h	2011-07-01 19:23:37.000000000 +0200
@@ -244,6 +244,14 @@ static inline int wpa_sm_mark_authentica
 	return -1;
 }
 
+static inline void wpa_sm_set_rekey_offload(struct wpa_sm *sm)
+{
+	if (!sm->ctx->set_rekey_offload)
+		return;
+	sm->ctx->set_rekey_offload(sm->ctx->ctx, sm->ptk.kek,
+				   sm->ptk.kck, sm->rx_replay_counter);
+}
+
 #ifdef CONFIG_TDLS
 static inline int wpa_sm_send_tdls_mgmt(struct wpa_sm *sm, const u8 *dst,
 					u8 action_code, u8 dialog_token,
--- a/src/rsn_supp/wpa.h	2011-07-01 19:18:00.000000000 +0200
+++ b/src/rsn_supp/wpa.h	2011-07-01 19:23:37.000000000 +0200
@@ -61,6 +61,8 @@ struct wpa_sm_ctx {
 			      u16 status_code, const u8 *buf, size_t len);
 	int (*tdls_oper)(void *ctx, int oper, const u8 *peer);
 #endif /* CONFIG_TDLS */
+	void (*set_rekey_offload)(void *ctx, const u8 *kek, const u8 *kck,
+				  const u8 *replay_ctr);
 };
 
 
@@ -132,6 +134,8 @@ int wpa_sm_pmksa_cache_list(struct wpa_s
 void wpa_sm_drop_sa(struct wpa_sm *sm);
 int wpa_sm_has_ptk(struct wpa_sm *sm);
 
+void wpa_sm_update_replay_ctr(struct wpa_sm *sm, const u8 *replay_ctr);
+
 #else /* CONFIG_NO_WPA */
 
 static inline struct wpa_sm * wpa_sm_init(struct wpa_sm_ctx *ctx)
@@ -277,6 +281,11 @@ static inline int wpa_sm_has_ptk(struct
 	return 0;
 }
 
+static inline void wpa_sm_update_replay_ctr(struct wpa_sm *sm,
+					    const u8 *replay_ctr)
+{
+}
+
 #endif /* CONFIG_NO_WPA */
 
 #ifdef CONFIG_PEERKEY
--- a/wpa_supplicant/events.c	2011-07-01 19:23:31.000000000 +0200
+++ b/wpa_supplicant/events.c	2011-07-01 19:23:37.000000000 +0200
@@ -2203,6 +2203,15 @@ void wpa_supplicant_event(void *ctx, enu
 		ibss_rsn_stop(wpa_s->ibss_rsn, data->ibss_peer_lost.peer);
 #endif /* CONFIG_IBSS_RSN */
 		break;
+	case EVENT_DRIVER_GTK_REKEY:
+		if (os_memcmp(data->driver_gtk_rekey.bssid,
+			      wpa_s->bssid, ETH_ALEN))
+			break;
+		if (!wpa_s->wpa)
+			break;
+		wpa_sm_update_replay_ctr(wpa_s->wpa,
+					 data->driver_gtk_rekey.replay_ctr);
+		break;
 	default:
 		wpa_msg(wpa_s, MSG_INFO, "Unknown event %d", event);
 		break;
--- a/wpa_supplicant/wpas_glue.c	2011-07-01 19:18:00.000000000 +0200
+++ b/wpa_supplicant/wpas_glue.c	2011-07-01 19:23:37.000000000 +0200
@@ -655,6 +655,15 @@ int wpa_supplicant_init_eapol(struct wpa
 }
 
 
+static void wpa_supplicant_set_rekey_offload(void *ctx, const u8 *kek,
+					     const u8 *kck, const u8 *replay_ctr)
+{
+	struct wpa_supplicant *wpa_s = ctx;
+
+	wpa_drv_set_rekey_info(wpa_s, kek, kck, replay_ctr);
+}
+
+
 int wpa_supplicant_init_wpa(struct wpa_supplicant *wpa_s)
 {
 #ifndef CONFIG_NO_WPA
@@ -694,6 +703,7 @@ int wpa_supplicant_init_wpa(struct wpa_s
 	ctx->send_tdls_mgmt = wpa_supplicant_send_tdls_mgmt;
 	ctx->tdls_oper = wpa_supplicant_tdls_oper;
 #endif /* CONFIG_TDLS */
+	ctx->set_rekey_offload = wpa_supplicant_set_rekey_offload;
 
 	wpa_s->wpa = wpa_sm_init(ctx);
 	if (wpa_s->wpa == NULL) {
--- a/src/drivers/driver_nl80211.c	2011-07-01 19:23:31.000000000 +0200
+++ b/src/drivers/driver_nl80211.c	2011-07-01 23:39:16.000000000 +0200
@@ -1376,6 +1376,44 @@ static void nl80211_del_station_event(st
 }
 
 
+static void nl80211_rekey_offload_event(struct wpa_driver_nl80211_data *drv,
+					struct nlattr **tb)
+{
+	struct nlattr *rekey_info[NUM_NL80211_REKEY_DATA];
+	static struct nla_policy rekey_policy[NUM_NL80211_REKEY_DATA] = {
+		[NL80211_REKEY_DATA_KEK] = {
+			.minlen = NL80211_KEK_LEN,
+			.maxlen = NL80211_KEK_LEN,
+		},
+		[NL80211_REKEY_DATA_KCK] = {
+			.minlen = NL80211_KCK_LEN,
+			.maxlen = NL80211_KCK_LEN,
+		},
+		[NL80211_REKEY_DATA_REPLAY_CTR] = {
+			.minlen = NL80211_REPLAY_CTR_LEN,
+			.maxlen = NL80211_REPLAY_CTR_LEN,
+		},
+	};
+	union wpa_event_data data;
+
+	if (!tb[NL80211_ATTR_MAC])
+		return;
+	if (!tb[NL80211_ATTR_REKEY_DATA])
+		return;
+	if (nla_parse_nested(rekey_info, MAX_NL80211_REKEY_DATA,
+			     tb[NL80211_ATTR_REKEY_DATA], rekey_policy))
+		return;
+	if (!rekey_info[NL80211_REKEY_DATA_REPLAY_CTR])
+		return;
+
+	os_memset(&data, 0, sizeof(data));
+	data.driver_gtk_rekey.bssid = nla_data(tb[NL80211_ATTR_MAC]);
+	data.driver_gtk_rekey.replay_ctr =
+		nla_data(rekey_info[NL80211_REKEY_DATA_REPLAY_CTR]);
+	wpa_supplicant_event(drv->ctx, EVENT_DRIVER_GTK_REKEY, &data);
+}
+
+
 static int process_event(struct nl_msg *msg, void *arg)
 {
 	struct wpa_driver_nl80211_data *drv = arg;
@@ -1494,6 +1532,8 @@ static int process_event(struct nl_msg *
 	case NL80211_CMD_DEL_STATION:
 		nl80211_del_station_event(drv, tb);
 		break;
+	case NL80211_CMD_SET_REKEY_OFFLOAD:
+		nl80211_rekey_offload_event(drv, tb);
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", gnlh->cmd);
@@ -6639,6 +6679,41 @@ static int nl80211_flush_pmkid(void *pri
 }
 
 
+static void nl80211_set_rekey_info(void *priv, const u8 *kek, const u8 *kck,
+				   const u8 *replay_ctr)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nlattr *replay_nested;
+	struct nl_msg *msg;
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return;
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0, 0,
+		    NL80211_CMD_SET_REKEY_OFFLOAD, 0);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, bss->ifindex);
+
+	replay_nested = nla_nest_start(msg, NL80211_ATTR_REKEY_DATA);
+	if (!replay_nested)
+		goto nla_put_failure;
+
+	NLA_PUT(msg, NL80211_REKEY_DATA_KEK, NL80211_KEK_LEN, kek);
+	NLA_PUT(msg, NL80211_REKEY_DATA_KCK, NL80211_KCK_LEN, kck);
+	NLA_PUT(msg, NL80211_REKEY_DATA_REPLAY_CTR, NL80211_REPLAY_CTR_LEN,
+		replay_ctr);
+
+	nla_nest_end(msg, replay_nested);
+
+	send_and_recv_msgs(drv, msg, NULL, NULL);
+	return;
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+
+
 const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.name = "nl80211",
 	.desc = "Linux nl80211/cfg80211",
@@ -6711,4 +6786,5 @@ const struct wpa_driver_ops wpa_driver_n
 	.add_pmkid = nl80211_add_pmkid,
 	.remove_pmkid = nl80211_remove_pmkid,
 	.flush_pmkid = nl80211_flush_pmkid,
+	.set_rekey_info = nl80211_set_rekey_info,
 };


