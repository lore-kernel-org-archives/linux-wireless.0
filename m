Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60592 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab1FWSpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 14:45:06 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 11:44:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/4] hostapd: add survey dump support
Date: Thu, 23 Jun 2011 11:44:50 -0700
Message-ID: <1308854691-5958-4-git-send-email-lrodriguez@atheros.com> (sfid-20110623_204516_642124_74342363)
In-Reply-To: <1308854691-5958-1-git-send-email-lrodriguez@atheros.com>
References: <1308854691-5958-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds survey dump support for all frequencies
and for specific desired frequencies. This will later
be used by ACS code for spectrum heuristics.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 src/ap/ap_drv_ops.h          |   15 +++
 src/ap/drv_callbacks.c       |   70 +++++++++++++++
 src/ap/hostapd.h             |    8 ++
 src/drivers/driver.h         |   89 +++++++++++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 374 insertions(+), 1 deletions(-)

diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index a62e1e5..24c7e95 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -213,4 +213,19 @@ static inline int hostapd_drv_remain_on_channel(struct hostapd_data *hapd,
 	return hapd->driver->remain_on_channel(hapd->drv_priv, freq, duration);
 }
 
+static inline int hostapd_drv_survey_freq(struct hostapd_data *hapd,
+					  unsigned int freq)
+{
+	if (hapd->driver == NULL)
+		return -1;
+        if (!hapd->driver->get_survey)
+		return -1;
+	return hapd->driver->get_survey(hapd->drv_priv, freq);
+}
+
+static inline int hostapd_drv_survey(struct hostapd_data *hapd)
+{
+	return hostapd_drv_survey_freq(hapd, 0);
+}
+
 #endif /* AP_DRV_OPS */
diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index 064eb65..6953b71 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -545,6 +545,73 @@ static void hostapd_event_roc_cancel(struct hostapd_data *hapd,
 	/* XXX: pass err to listeners, no one yet */
 }
 
+struct hostapd_channel_data *hostapd_get_mode_channel(struct hostapd_iface *iface,
+						      unsigned int freq)
+{
+	unsigned int i;
+	struct hostapd_channel_data *chan;
+
+	for (i = 0; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+		if (!chan)
+			return NULL;
+		if (chan->freq == freq)
+			return chan;
+	}
+
+	return NULL;
+}
+
+static void hostapd_update_nf(struct hostapd_iface *iface,
+			      struct hostapd_channel_data *chan,
+			      struct freq_survey *survey)
+{
+	if (!iface->chans_surveyed) {
+		chan->min_nf = survey->nf;
+		iface->lowest_nf = survey->nf;
+	} else {
+		if (!chan->survey_count)
+			chan->min_nf = survey->nf;
+		else if (survey->nf < chan->min_nf)
+			chan->min_nf = survey->nf;
+		if (survey->nf < iface->lowest_nf)
+			iface->lowest_nf = survey->nf;
+	}
+}
+
+static void hostapd_event_get_survey(struct hostapd_data *hapd,
+				     struct survey_results *survey_results)
+{
+	struct hostapd_iface *iface = hapd->iface;
+	struct freq_survey *survey, *tmp;
+	struct hostapd_channel_data *chan;
+
+	if (dl_list_empty(&survey_results->survey_list)) {
+		wpa_printf(MSG_DEBUG, "ACS: no survey data received");
+                return;
+	}
+
+	dl_list_for_each_safe(survey, tmp, &survey_results->survey_list, struct freq_survey, list_member) {
+		chan = hostapd_get_mode_channel(iface, survey->freq);
+		if (!chan)
+			goto fail;
+		if (chan->flag & HOSTAPD_CHAN_DISABLED)
+			continue;
+
+		dl_list_del(&survey->list_member);
+		dl_list_add_tail(&chan->survey_list, &survey->list_member);
+
+		hostapd_update_nf(iface, chan, survey);
+
+		chan->survey_count++;
+		iface->chans_surveyed++;
+	}
+
+	return;
+fail:
+	iface->chans_surveyed = 0;
+}
+
 void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			  union wpa_event_data *data)
 {
@@ -644,6 +711,9 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 					 data->remain_on_channel.freq,
 					 data->remain_on_channel.duration);
 		break;
+	case EVENT_SURVEY:
+		hostapd_event_get_survey(hapd, &data->survey_results);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "Unknown event %d", event);
 		break;
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index d8318ee..1095d2b 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -231,6 +231,14 @@ struct hostapd_iface {
 	/* Offchannel operation helper */
 	unsigned int off_channel_freq_idx;
 
+	/* surveying helpers */
+
+	/* number of channels surveyed */
+	unsigned int chans_surveyed;
+
+	/* lowest observed noise floor in dBm */
+	s8 lowest_nf;
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 513580a..0e1c5c1 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -26,6 +26,7 @@
 #define WPA_SUPPLICANT_DRIVER_VERSION 4
 
 #include "common/defs.h"
+#include "list.h"
 
 #define HOSTAPD_CHAN_DISABLED 0x00000001
 #define HOSTAPD_CHAN_PASSIVE_SCAN 0x00000002
@@ -58,6 +59,22 @@ struct hostapd_channel_data {
 	 * max_tx_power - maximum transmit power in dBm
 	 */
 	u8 max_tx_power;
+
+	/*
+	 * survey_count - number of surveys XXX: can we remove this and use the count of the linked list?
+	 */
+        unsigned int survey_count;
+
+	/*
+	 * survey_list - linked list of surveys
+	 */
+	struct dl_list survey_list;
+
+	/**
+	 * min_nf - minimum observed noise floor, in dBm, based on all surveyed channel data
+	 */
+	s8 min_nf;
+
 };
 
 /**
@@ -2253,6 +2270,30 @@ struct wpa_driver_ops {
 	 * implementation, there is no need to implement this function.
 	 */
 	int (*set_authmode)(void *priv, int authmode);
+
+	/**
+	 * get_survey - Retrieve survey data
+	 * @priv: Private driver interface data
+	 * @freq: if set survey data for the specified frequency is only
+	 *	being requested. If not set all survey data is requested.
+	 * Returns: 0 on success, -1 on failure
+	 *
+	 * Use this to retreieve:
+	 *
+	 * - the observed channel noise floor
+	 * - the amount of time we have spent on the channel
+	 * - the amount of time during which we have spent on the channel that
+	 *   the radio has determined the the medium is busy and we cannot transmit
+	 * - the amount of time we have spent RX'ing data
+	 * - the amount of time we have spent TX'ing data
+	 *
+	 * This data can be use for spectrum heuristics, one example is
+	 * Automatic Channel Selection (ACS). The channel survey data is
+	 * kept on a linked list on the channel data, one entry is added
+	 * for each survey. The min_nf of the channel is updated for
+	 * each survey.
+	 */
+	int (*get_survey)(void *priv, unsigned int freq);
 };
 
 
@@ -2655,9 +2696,44 @@ enum wpa_event_type {
 	/**
 	 * EVENT_IBSS_PEER_LOST - IBSS peer not reachable anymore
 	 */
-	EVENT_IBSS_PEER_LOST
+	EVENT_IBSS_PEER_LOST,
+
+	/**
+	 * EVENT_SURVEY - Received survey data
+	 *
+	 * This event gets triggered when a driver query is issued for survey
+	 * data and its returned. The returned data is stored in
+	 * struct survey_results. The results provide at most one survey
+	 * entry for each frequency and at minimum will provide survey
+	 * one survey entry for one frequency. The survey data can be
+	 * os_malloc()'d and then os_free()'d, so the event callback must
+	 * only copy data.
+	 */
+	EVENT_SURVEY,
 };
 
+/**
+ * struct survey_info - channel survey info
+ *
+ * @ifidx: interface index in which this survey was observed
+ * @freq: center of frequency of the surveyed channel
+ * @nf: channel noise floor in dBm
+ * @channel_time: amount of time in ms the radio spent on the channel
+ * @channel_time_busy: amount of time in ms the radio detected some signal
+ *	that indicated to the radio the channel was not clear
+ * @channel_time_rx: amount of time the radio spent receiving data
+ * @channel_time_tx: amount of time the radio spent transmitting data
+ */
+struct freq_survey {
+	u32 ifidx;
+	unsigned int freq;
+	s8 nf;
+	u64 channel_time;
+	u64 channel_time_busy;
+	u64 channel_time_rx;
+	u64 channel_time_tx;
+	struct dl_list list_member;
+};
 
 /**
  * union wpa_event_data - Additional data for wpa_supplicant_event() calls
@@ -3187,6 +3263,17 @@ union wpa_event_data {
 	struct ibss_peer_lost {
 		u8 peer[ETH_ALEN];
 	} ibss_peer_lost;
+
+	/**
+	 * survey_results - survey result data for EVENT_SURVEY
+	 * @freq_filter: requested frequency survey filter, 0 if request
+	 *	was for all survey data
+	 * @survey_list: linked list of survey data
+	 */
+	struct survey_results {
+		unsigned int freq_filter;
+		struct dl_list survey_list;
+	} survey_results;
 };
 
 /**
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index cfc9372..e5c4962 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -6603,6 +6603,198 @@ static int nl80211_flush_pmkid(void *priv)
 	return nl80211_pmkid(bss, NL80211_CMD_FLUSH_PMKSA, NULL, NULL);
 }
 
+static void clean_survey_results(struct survey_results *survey_results)
+{
+	struct freq_survey *survey, *tmp;
+
+	if (dl_list_empty(&survey_results->survey_list))
+		return;
+
+	dl_list_for_each_safe(survey, tmp, &survey_results->survey_list, struct freq_survey, list_member) {
+		dl_list_del(&survey->list_member);
+		os_free(survey);
+	}
+}
+
+static void add_survey(struct nlattr **sinfo, u32 ifidx, struct dl_list *survey_list)
+{
+	struct freq_survey *survey;
+
+	survey = (struct freq_survey*) os_malloc(sizeof(struct freq_survey));
+	if  (!survey)
+		return;
+	os_memset(survey, 0, sizeof(struct freq_survey));
+
+	survey->ifidx = ifidx;
+	survey->freq = nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]);
+	survey->nf = (int8_t) nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]);
+	survey->channel_time = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME]);
+	survey->channel_time_busy = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY]);
+	survey->channel_time_rx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]);
+	survey->channel_time_tx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX]);
+
+	wpa_printf(MSG_DEBUG, "nl80211: Freq survey dump event  (freq=%d MHz noise=%d "
+		   "channel_time=%ld busy_time=%ld tx_time=%ld rx_time=%ld)",
+		   survey->freq,
+		   survey->nf,
+		   survey->channel_time,
+		   survey->channel_time_busy,
+		   survey->channel_time_rx,
+		   survey->channel_time_tx);
+
+	dl_list_add_tail(survey_list, &survey->list_member);
+}
+
+static int survey_check(struct nlattr **sinfo)
+{
+	if (!sinfo[NL80211_SURVEY_INFO_NOISE] ||
+	    !sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME] ||
+	    !sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY] ||
+	    !sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX])
+		return 0;
+	return 1;
+}
+
+static void survey_fail_reason(struct nlattr **sinfo, u32 surveyed_freq)
+{
+	wpa_printf(MSG_ERROR,
+		   "nl80211: Following survey data missing "
+		   "for freq %d MHz:",
+		   surveyed_freq);
+
+	if (!sinfo[NL80211_SURVEY_INFO_NOISE])
+		wpa_printf(MSG_ERROR, "\tnoise");
+
+	if (!sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME])
+		wpa_printf(MSG_ERROR, "\tchannel time");
+
+	if (!sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY])
+		wpa_printf(MSG_ERROR, "\tchannel busy time");
+
+	if (!sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX])
+		wpa_printf(MSG_ERROR, "\tchannel tx time");
+}
+
+static int check_survey_ok(struct nlattr **sinfo,
+			   u32 surveyed_freq,
+			   unsigned int freq_filter)
+{
+	int good_survey = survey_check(sinfo);
+
+	/* If no filter is specified we just drop data for any bogus survey */
+	if (!freq_filter) {
+		if (good_survey)
+			return 1;
+		/* No filter used but no usable survey data found */
+		survey_fail_reason(sinfo, surveyed_freq);
+		return 0;
+	}
+
+	if (freq_filter != surveyed_freq)
+		return 0;
+
+	if (good_survey)
+		return 1;
+	/* Filter matches now, lets be verbose why this is a bad survey */
+
+	survey_fail_reason(sinfo, surveyed_freq);
+	return 0;
+}
+
+static int survey_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *tb[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *sinfo[NL80211_SURVEY_INFO_MAX + 1];
+	struct survey_results *survey_results;
+	u32 surveyed_freq = 0;
+	u32 ifidx;
+
+	static struct nla_policy survey_policy[NL80211_SURVEY_INFO_MAX + 1] = {
+		[NL80211_SURVEY_INFO_FREQUENCY] = { .type = NLA_U32 },
+		[NL80211_SURVEY_INFO_NOISE] = { .type = NLA_U8 },
+	};
+
+	survey_results = (struct survey_results *) arg;
+
+	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
+
+	if (!tb[NL80211_ATTR_SURVEY_INFO])
+		return NL_SKIP;
+
+	if (nla_parse_nested(sinfo, NL80211_SURVEY_INFO_MAX,
+			     tb[NL80211_ATTR_SURVEY_INFO],
+			     survey_policy))
+		return NL_SKIP;
+
+	if (!sinfo[NL80211_SURVEY_INFO_FREQUENCY]) {
+		wpa_printf(MSG_ERROR, "nl80211: invalid survey data");
+		return NL_SKIP;
+	}
+
+	surveyed_freq = nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]);
+
+	if (!check_survey_ok(sinfo, surveyed_freq, survey_results->freq_filter))
+		return NL_SKIP;
+
+	if (survey_results->freq_filter &&
+	    survey_results->freq_filter != surveyed_freq) {
+		wpa_printf(MSG_EXCESSIVE, "nl80211: ignoring survey data "
+			   "for freq %d MHz", surveyed_freq);
+		return NL_SKIP;
+	}
+
+	add_survey(sinfo, ifidx, &survey_results->survey_list);
+
+	return NL_SKIP;
+}
+
+static int wpa_driver_nl80211_get_survey(void *priv, unsigned int freq)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nl_msg *msg;
+	int err = -ENOBUFS;
+	union wpa_event_data data;
+	struct survey_results *survey_results;
+
+	os_memset(&data, 0, sizeof(data));
+	survey_results = &data.survey_results;
+
+	dl_list_init(&survey_results->survey_list);
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		goto nla_put_failure;
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0, NLM_F_DUMP,
+		    NL80211_CMD_GET_SURVEY, 0);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+
+	if (freq)
+		data.survey_results.freq_filter = freq;
+
+	do {
+		err = send_and_recv_msgs(drv, msg, survey_handler, survey_results);
+	} while (err > 0);
+
+	if (err) {
+		wpa_printf(MSG_ERROR, "nl80211: failed to process survey data");
+		goto out_clean;
+	}
+
+	wpa_supplicant_event(drv->ctx, EVENT_SURVEY, &data);
+
+out_clean:
+	clean_survey_results(survey_results);
+nla_put_failure:
+	return err;
+}
+
 
 const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.name = "nl80211",
@@ -6676,4 +6868,5 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.add_pmkid = nl80211_add_pmkid,
 	.remove_pmkid = nl80211_remove_pmkid,
 	.flush_pmkid = nl80211_flush_pmkid,
+	.get_survey = wpa_driver_nl80211_get_survey,
 };
-- 
1.7.4.15.g7811d

