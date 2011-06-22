Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33796 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab1FVBHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 21:07:49 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 18:07:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2] hostapd: add Automatic Channel Selection (ACS) support
Date: Tue, 21 Jun 2011 18:07:42 -0700
Message-ID: <1308704862-5684-1-git-send-email-lrodriguez@atheros.com> (sfid-20110622_030800_131156_2EE10410)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds Automatic Channel Selection (ACS) support to hostapd
using the Survery based ACS algorithm [1].

[1] http://wireless.kernel.org/en/users/Documentation/acs#Survey_based_algorithm

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Oopsie, forgot to git add acs.[ch], here is v2 with those pegged.

 hostapd/Makefile             |    5 +
 hostapd/defconfig            |    3 +
 src/ap/acs.c                 |  368 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h                 |   49 ++++++
 src/ap/ap_drv_ops.h          |   27 +++
 src/ap/drv_callbacks.c       |  152 +++++++++++++++++-
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   14 ++
 src/ap/hw_features.c         |  182 +++++++++++++--------
 src/drivers/driver.h         |   97 +++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++++++
 wpa_supplicant/events.c      |    2 +
 12 files changed, 1026 insertions(+), 68 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

diff --git a/hostapd/Makefile b/hostapd/Makefile
index d05975b..5ff51be 100644
--- a/hostapd/Makefile
+++ b/hostapd/Makefile
@@ -736,6 +736,11 @@ CFLAGS += -DCONFIG_P2P_MANAGER
 OBJS += ../src/ap/p2p_hostapd.o
 endif
 
+ifdef CONFIG_ACS
+CFLAGS += -DCONFIG_ACS
+OBJS += ../src/ap/acs.o
+endif
+
 ifdef CONFIG_NO_STDOUT_DEBUG
 CFLAGS += -DCONFIG_NO_STDOUT_DEBUG
 endif
diff --git a/hostapd/defconfig b/hostapd/defconfig
index 26be2a8..097a696 100644
--- a/hostapd/defconfig
+++ b/hostapd/defconfig
@@ -208,3 +208,6 @@ CONFIG_IPV6=y
 # considered for builds that are known to be used on devices that meet the
 # requirements described above.
 #CONFIG_NO_RANDOM_POOL=y
+
+# TODO:
+#CONFIG_ACS=y
diff --git a/src/ap/acs.c b/src/ap/acs.c
new file mode 100644
index 0000000..25c1020
--- /dev/null
+++ b/src/ap/acs.c
@@ -0,0 +1,368 @@
+/*
+ * Copyright 2011	Luis R. Rodriguez <mcgrof@kernel.org>
+ */
+
+#include "includes.h"
+#include "acs.h"
+#include "drivers/driver.h"
+#include "ap/ap_drv_ops.h"
+#include "ap/ap_config.h"
+#include "ap/hw_features.h"
+#include <math.h>
+
+s8 lowest_noise = 100;
+
+/* XXX: move this documentation to the right place */
+
+/**
+ * @interference_factor: computed interference factor observed on this
+ *	channel. This is defined as the ratio of the observed busy time
+ *	over the time we spent on the channel, this value is then
+ * 	amplified by the noise based on the lowest and highest observed
+ * 	noise value on the same frequency. This corresponds to:
+ *
+ *	---
+ *	(busy time - tx time) / (active time - tx time) * 2^(noise + min_noise)
+ *	---
+ *
+ *	The coefficient of of 2 reflects the way power in "far-field" radiation
+ *	decreases as the square of distance from the antenna [1]. What this does
+ *	is it decreases the observed busy time ratio if the noise observed was
+ *	low but increases it if the noise was high, proportionally to the way
+ *	"far field" radiation changes over distance. Since the values obtained
+ * 	here can vary from fractional to millions the sane thing to do here is
+ *	to use log2() to reflect the observed interference factor. log2() values
+ *	less than 0 then represent fractional results, while > 1 values non-fractional
+ *	results. The computation of the interference factor then becomes:
+
+ *	---
+ *	log2( (busy time - tx time) / (active time - tx time) * 2^(noise + min_noise))
+ *	--- or due to logarithm identities:
+ *	log2(busy time - tx time) - log2(active time - tx time) + log2(2^(noise + min_noise))
+ *	---
+ *
+ *	All this is "interference factor" is purely subjective and ony time will tell how
+ *	usable this is. By using the minimum noise floor we remove any possible issues
+ *	due to card calibration. The computation of the interference factor then is
+ *	dependent on what the card itself picks up as the minimum noise, not an actual
+ *	real possible card noise value.
+ *
+ *	Example output:
+ *
+ *	2412 MHz: 7.429173
+ *	2417 MHz: 10.460830
+ *	2422 MHz: 12.671070
+ *	2427 MHz: 13.583892
+ *	2432 MHz: 13.405357
+ *	2442 MHz: 13.566887
+ *	2447 MHz: 15.630824
+ *	2452 MHz: 14.639748
+ *	2457 MHz: 14.139193
+ *	2467 MHz: 11.914643
+ *	2472 MHz: 16.996074
+ *	2484 MHz: 15.175455
+ *	5180 MHz: -0.218548
+ *	5200 MHz: -2.204059
+ *	5220 MHz: -1.762898
+ *	5240 MHz: -1.314665
+ *	5260 MHz: -3.100989
+ *	5280 MHz: -2.157037
+ *	5300 MHz: -1.842629
+ *	5320 MHz: -1.498928
+ *	5500 MHz: 3.304770
+ *	5520 MHz: 2.345992
+ *	5540 MHz: 2.749775
+ *	5560 MHz: 2.390887
+ *	5580 MHz: 2.592958
+ *	5600 MHz: 2.420149
+ *	5620 MHz: 2.650282
+ *	5640 MHz: 2.954027
+ *	5660 MHz: 2.991007
+ *	5680 MHz: 2.955472
+ *	5700 MHz: 2.280499
+ *	5745 MHz: 2.388630
+ *	5765 MHz: 2.332542
+ *	5785 MHz: 0.955708
+ *	5805 MHz: 1.025377
+ *	5825 MHz: 0.843392
+ *	Ideal freq: 5260 MHz
+ *
+ *	[1] http://en.wikipedia.org/wiki/Near_and_far_field
+ */
+
+static void acs_clean_chan_surveys(struct hostapd_channel_data *chan)
+{
+	struct freq_survey *survey, *tmp;
+
+	if (dl_list_empty(&chan->survey_list))
+		return;
+
+	dl_list_for_each_safe(survey, tmp, &chan->survey_list, struct freq_survey, list_member) {
+		dl_list_del(&survey->list_member);
+		os_free(survey);
+	}
+}
+
+static void acs_cleanup(struct hostapd_iface *iface)
+{
+	unsigned int i;
+	struct hostapd_channel_data *chan;
+
+	for (i = 0; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+
+		if (chan->survey_count)
+			acs_clean_chan_surveys(chan);
+
+		dl_list_init(&chan->survey_list);
+		chan->min_noise = 0;
+		chan->survey_count = 0;
+	}
+
+	iface->chans_surveyed = 0;
+	iface->off_channel_freq_idx = 0;
+	iface->acs_num_completed_surveys = 0;
+	iface->acs_num_req_surveys = 0;
+}
+
+void acs_fail(struct hostapd_iface *iface)
+{
+	wpa_printf(MSG_ERROR, "ACS: failed to start");
+	acs_cleanup(iface);
+}
+
+
+static u64 base_to_power(u64 base, u64 pow)
+{
+	u64 result = base;
+
+	if (pow == 0)
+		return 1;
+
+	pow--;
+	while (pow--)
+		result *= base;
+
+	return result;
+}
+
+static long double acs_survey_interference_factor(struct freq_survey *survey, s8 min_noise)
+{
+	long double factor;
+
+	factor = survey->channel_time_busy - survey->channel_time_tx;
+	factor /= (survey->channel_time - survey->channel_time_tx);
+	factor *= (base_to_power(2, survey->noise - min_noise));
+	factor = log2(factor);
+
+	return factor;
+}
+
+static void acs_chan_interference_factor(struct hostapd_iface *iface,
+					 struct hostapd_channel_data *chan)
+{
+	struct freq_survey *survey;
+	unsigned int i = 0;
+	long double int_factor = 0, sum = 0;
+
+	if (dl_list_empty(&chan->survey_list) || chan->flag & HOSTAPD_CHAN_DISABLED)
+		return;
+
+	dl_list_for_each(survey, &chan->survey_list, struct freq_survey, list_member) {
+		int_factor = acs_survey_interference_factor(survey, iface->lowest_noise);
+		/* XXX: remove sum */
+		sum = chan->survey_interference_factor + int_factor;
+		chan->survey_interference_factor = sum;
+		wpa_printf(MSG_DEBUG, "\tSurvey id: %d"
+			   "\tmin noise: %d\tInterference factor: %Lf ",
+			   ++i, chan->min_noise, int_factor);
+	}
+
+	/* XXX: remove survey count */
+
+	chan->survey_interference_factor = chan->survey_interference_factor / chan->survey_count;
+}
+
+static int acs_usable_chan(struct hostapd_channel_data *chan)
+{
+	if (!chan->survey_count)
+		return 0;
+	if (dl_list_empty(&chan->survey_list))
+		return 0;
+	if (chan->flag & HOSTAPD_CHAN_DISABLED)
+		return 0;
+	return 1;
+}
+
+/* At this point its assumed we have the min_noise */
+struct hostapd_channel_data *acs_find_ideal_chan(struct hostapd_iface *iface)
+{
+	unsigned int i;
+	struct hostapd_channel_data *chan, *ideal_chan = NULL;
+
+	for (i = 0; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+
+		if (!acs_usable_chan(chan))
+			continue;
+
+		wpa_printf(MSG_DEBUG, "------------------------- "
+			   "Survey analysis for channel %d (%d MHz) "
+			   "--------------------------------",
+			    chan->chan,
+			    chan->freq);
+
+		acs_chan_interference_factor(iface, chan);
+
+		wpa_printf(MSG_DEBUG, "\tChannel interference factor average: %Lf",
+			   chan->survey_interference_factor);
+
+		if (!ideal_chan)
+			ideal_chan = chan;
+		else {
+			if (chan->survey_interference_factor < ideal_chan->survey_interference_factor)
+				ideal_chan = chan;
+		}
+	}
+
+	return ideal_chan;
+}
+
+static int acs_study_next_freq(struct hostapd_iface *iface)
+{
+	int err;
+	unsigned int i;
+	unsigned int duration_ms = 10; /* XXX: allow dynamic configuration */
+	struct hostapd_channel_data *chan;
+	struct hostapd_data *hapd = iface->bss[0];
+
+	if (iface->off_channel_freq_idx > iface->current_mode->num_channels) {
+		wpa_printf(MSG_ERROR, "ACS: channel index out of bounds");
+		return -1;
+	}
+
+	for (i = iface->off_channel_freq_idx; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+		if (chan->flag & HOSTAPD_CHAN_DISABLED)
+			continue;
+
+		err = hostapd_drv_remain_on_channel(hapd, chan->freq, duration_ms);
+		if (err < 0) {
+			wpa_printf(MSG_ERROR, "ACS: request to go offchannel "
+				   "on freq %d MHz failed",
+				   chan->freq);
+			return err;
+		}
+
+		iface->off_channel_freq_idx = i;
+
+		return 1;
+	}
+
+	if (!iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: unable to survey any channel");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void acs_study_complete(struct hostapd_iface *iface)
+{
+	struct hostapd_channel_data *ideal_chan;
+
+	iface->acs_num_completed_surveys++;
+
+	if (iface->acs_num_completed_surveys < iface->acs_num_req_surveys) {
+		iface->off_channel_freq_idx = 0;
+		acs_study_next_freq(iface);
+		return;
+	}
+
+	if (!iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: unable to collect any "
+			   "useful survey data\n");
+		goto fail;
+	}
+
+	ideal_chan = acs_find_ideal_chan(iface);
+	if (!ideal_chan) {
+		wpa_printf(MSG_ERROR, "ACS: although survey data was collected we "
+			   "were unable to compute an ideal channel\n");
+		goto fail;
+	}
+
+	wpa_printf(MSG_DEBUG, "-------------------------------------------------------------------------");
+	wpa_printf(MSG_INFO, "ACS: Ideal chan: %d (%d MHz) Average interference factor: %Lf",
+		   ideal_chan->chan,
+		   ideal_chan->freq,
+		   ideal_chan->survey_interference_factor);
+	wpa_printf(MSG_DEBUG, "-------------------------------------------------------------------------");
+
+	/* XXX: support HT40 */
+	iface->conf->channel = ideal_chan->chan;
+	iface->conf->secondary_channel = 0;
+
+	hostapd_acs_completed(iface);
+	acs_cleanup(iface);
+
+	return;
+
+fail:
+	acs_fail(iface);
+}
+
+
+void acs_roc_next(struct hostapd_iface *iface,
+		  unsigned int freq,
+		  unsigned int duration)
+{
+	struct hostapd_channel_data *chan;
+	struct hostapd_data *hapd = iface->bss[0];
+	int err;
+
+	chan = &iface->current_mode->channels[iface->off_channel_freq_idx];
+
+	wpa_printf(MSG_EXCESSIVE, "ACS: offchannel on freq %d MHz", freq);
+
+	err = hostapd_drv_survey_freq(hapd, freq);
+	if (err) {
+		/* XXX: figure out why we are not getting out of here */
+		wpa_printf(MSG_ERROR, "ACS: failed to get any survey "
+			   "data for freq %d MHz", freq);
+		goto fail;
+	}
+
+	wpa_printf(MSG_EXCESSIVE, "ACS: going to next channel...");
+
+	iface->off_channel_freq_idx++;
+
+	err = acs_study_next_freq(iface);
+	if (err < 0)
+		goto fail;
+	else if (err == 1)
+		return;
+
+	acs_study_complete(iface);
+	return;
+
+fail:
+	acs_fail(iface);
+}
+
+/* XXX: why is the callback passed ? */
+int acs_init(struct hostapd_iface *iface)
+{
+	int err;
+
+	acs_cleanup(iface);
+
+	iface->acs_num_completed_surveys = 0;
+	iface->acs_num_req_surveys = 10; /* XXX: make configurable */
+
+	err = acs_study_next_freq(iface);
+	if (err)
+		return err;
+
+	return 0;
+}
diff --git a/src/ap/acs.h b/src/ap/acs.h
new file mode 100644
index 0000000..f3f199e
--- /dev/null
+++ b/src/ap/acs.h
@@ -0,0 +1,49 @@
+#ifndef __ACS_H
+#define __ACS_H
+
+#include <stdbool.h>
+
+#include <netlink/genl/ctrl.h>
+
+#include "utils/common.h"
+#include "ap/hostapd.h"
+#include "list.h"
+
+#ifdef CONFIG_ACS
+
+int acs_init(struct hostapd_iface *iface);
+void acs_roc_next(struct hostapd_iface *iface,
+		  unsigned int freq,
+		  unsigned int duration);
+int hostapd_acs_completed(struct hostapd_iface *iface);
+void acs_fail(struct hostapd_iface *iface);
+
+extern struct dl_list freq_list;
+
+int handle_survey_dump(struct nl_msg *msg, void *arg);
+void parse_freq_list(void);
+void parse_freq_int_factor(void);
+void annotate_enabled_chans(void);
+void clean_freq_list(void);
+void clear_freq_surveys(void);
+
+#if 0
+__u32 wait_for_offchan_op(struct nl80211_state *state,
+			  int devidx, int freq,
+			  const int n_waits, const __u32 *waits);
+void clear_offchan_ops_list(void);
+
+int nl_get_multicast_id(struct nl_sock *sock, const char *family, const char *group);
+
+int nl80211_add_membership_mlme(struct nl80211_state *state);
+#endif
+
+#else
+static inline int acs_init(struct hostapd_iface *iface,
+	     int (*acs_completed_cb)(struct hostapd_iface *iface))
+{
+	return 0;
+}
+#endif /* CONFIG_ACS */
+
+#endif /* __ACS_H */
diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index f6076af..c9ff723 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -202,4 +202,31 @@ static inline int hostapd_drv_set_authmode(struct hostapd_data *hapd,
 	return hapd->driver->set_authmode(hapd->drv_priv, auth_algs);
 }
 
+static inline int hostapd_drv_remain_on_channel(struct hostapd_data *hapd,
+						unsigned int freq,
+						unsigned int duration)
+{
+	if (hapd->driver == NULL)
+		return -1;
+        if (!hapd->driver->remain_on_channel)
+		return -1;
+	return hapd->driver->remain_on_channel(hapd->drv_priv, freq, duration);
+}
+
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
+
 #endif /* AP_DRV_OPS */
diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index 02b7ecf..6101831 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -35,7 +35,7 @@
 #include "wps_hostapd.h"
 #include "ap_drv_ops.h"
 #include "ap_config.h"
-
+#include "acs.h"
 
 int hostapd_notif_assoc(struct hostapd_data *hapd, const u8 *addr,
 			const u8 *ie, size_t ielen, int reassoc)
@@ -447,6 +447,143 @@ static void hostapd_event_eapol_rx(struct hostapd_data *hapd, const u8 *src,
 	ieee802_1x_receive(hapd, src, data, data_len);
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
+static void hostapd_update_noise(struct hostapd_iface *iface,
+				 struct hostapd_channel_data *chan,
+				 struct freq_survey *survey)
+{
+	if (!iface->chans_surveyed) {
+		chan->min_noise = survey->noise;
+		iface->lowest_noise = survey->noise;
+	} else {
+		if (!chan->survey_count)
+			chan->min_noise = survey->noise;
+		else if (survey->noise < chan->min_noise)
+			chan->min_noise = survey->noise;
+		if (survey->noise < iface->lowest_noise)
+			iface->lowest_noise = survey->noise;
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
+		hostapd_update_noise(iface, chan, survey);
+
+		chan->survey_count++;
+		iface->chans_surveyed++;
+	}
+
+	return;
+fail:
+	/* XXX: move chan clean thingy here from acs.c */
+	iface->chans_surveyed = 0;
+}
+
+static int hostapd_roc_channel_check(struct hostapd_iface *iface)
+{
+	struct hostapd_channel_data *chan = NULL, *offchan;
+	unsigned int i;
+	int found = 0;
+
+	offchan = &iface->current_mode->channels[iface->off_channel_freq_idx];
+
+	for (i = 0; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+		if (offchan != chan)
+			continue;
+		found = 1;
+		break;
+	}
+
+	if (!found || !chan) {
+		wpa_printf(MSG_ERROR, "ACS: channel requested to go offchannel "
+			   "on freq %d MHz disappeared",
+			   chan->freq);
+		goto fail;
+	}
+
+	if (chan->flag & HOSTAPD_CHAN_DISABLED) {
+		wpa_printf(MSG_ERROR, "ACS: channel requested to go offchannel "
+			   "on freq %d MHz became disabled",
+			   chan->freq);
+		goto fail;
+	}
+
+
+	return 0;
+fail:
+	return -1;
+}
+
+static void hostapd_event_roc(struct hostapd_data *hapd,
+			      unsigned int freq,
+			      unsigned int duration)
+{
+	struct hostapd_iface *iface = hapd->iface;
+	int err;
+
+	err = hostapd_roc_channel_check(iface);
+	if (err)
+		goto fail;
+
+	return;
+fail:
+	acs_fail(iface);
+}
+
+static void hostapd_event_roc_cancel(struct hostapd_data *hapd,
+				     unsigned int freq,
+				     unsigned int duration)
+{
+	struct hostapd_iface *iface = hapd->iface;
+	int err;
+
+	err = hostapd_roc_channel_check(iface);
+	if (err)
+		goto fail;
+
+	acs_roc_next(iface, freq, duration);
+
+	return;
+fail:
+	acs_fail(iface);
+}
 
 void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			  union wpa_event_data *data)
@@ -530,6 +667,19 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			break;
 		hostapd_event_sta_low_ack(hapd, data->low_ack.addr);
 		break;
+	case EVENT_SURVEY:
+		hostapd_event_get_survey(hapd, &data->survey_results);
+		break;
+	case EVENT_REMAIN_ON_CHANNEL:
+		hostapd_event_roc(hapd,
+				  data->remain_on_channel.freq,
+				  data->remain_on_channel.duration);
+		break;
+	case EVENT_CANCEL_REMAIN_ON_CHANNEL:
+		hostapd_event_roc_cancel(hapd,
+					 data->remain_on_channel.freq,
+					 data->remain_on_channel.duration);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "Unknown event %d", event);
 		break;
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index d8af571..79f9b66 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -700,6 +700,8 @@ static int setup_interface(struct hostapd_iface *iface)
 				   "channel. (%d)", ret);
 			return -1;
 		}
+		if (ret == 1)
+			return 0;
 		ret = hostapd_check_ht_capab(iface);
 		if (ret < 0)
 			return -1;
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index d4501a1..3e12093 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -221,6 +221,20 @@ struct hostapd_iface {
 	int olbc_ht;
 
 	u16 ht_op_mode;
+
+	/* Offchannel operation helpers */
+	unsigned int off_channel_freq_idx;
+	unsigned int chans_surveyed;
+
+	/* surveying helpers */
+	s8 lowest_noise;
+
+#ifdef CONFIG_ACS
+	/* ACS helpers */
+	unsigned int acs_num_completed_surveys;
+	unsigned int acs_num_req_surveys;
+#endif
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 86f6811..852c995 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -25,6 +25,7 @@
 #include "ap_config.h"
 #include "ap_drv_ops.h"
 #include "hw_features.h"
+#include "acs.h"
 
 
 void hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
@@ -599,6 +600,114 @@ int hostapd_check_ht_capab(struct hostapd_iface *iface)
 	return 0;
 }
 
+static int hostapd_is_usable_chan(struct hostapd_iface *iface,
+				  int channel,
+				  int primary)
+{
+	unsigned int i;
+	struct hostapd_channel_data *chan;
+
+	for (i = 0; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+		if (chan->chan == channel) {
+			if (chan->flag & HOSTAPD_CHAN_DISABLED) {
+				wpa_printf(MSG_ERROR,
+					   "%schannel [%i] (%i) is disabled for "
+					   "use in AP mode, flags: 0x%x",
+					   primary ? "" : "Configured HT40 secondary ",
+					   i, chan->chan, chan->flag);
+			} else {
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int hostapd_is_usable_chans(struct hostapd_iface *iface)
+{
+	if (!hostapd_is_usable_chan(iface, iface->conf->channel, 1))
+		return 0;
+
+	if (!iface->conf->secondary_channel)
+		return 1;
+
+	if (!hostapd_is_usable_chan(iface, iface->conf->secondary_channel, 0))
+		return 0;
+
+	return 1;
+}
+
+static int hostapd_check_chans(struct hostapd_iface *iface)
+{
+	if (iface->conf->channel) {
+		if (hostapd_is_usable_chans(iface))
+			return 1;
+		else
+			return 0;
+	}
+
+	/*
+	 * We'd reach here if the ACS cb failed to get us a proper channel
+	 * somehow
+	 */
+	if (iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: no usable channels found");
+		return 0;
+	}
+
+	if (!(iface->drv_flags & WPA_DRIVER_FLAGS_OFFCHANNEL_TX)) {
+		wpa_printf(MSG_ERROR, "ACS: offchannel TX support required");
+		return 0;
+	}
+
+	wpa_printf(MSG_ERROR, "ACS: automatic channel selection started...");
+
+	acs_init(iface);
+
+	return 2;
+}
+
+static void hostapd_notify_bad_chans(struct hostapd_iface *iface)
+{
+	iface->current_mode = NULL;
+
+	hostapd_logger(iface->bss[0], NULL,
+		       HOSTAPD_MODULE_IEEE80211,
+		       HOSTAPD_LEVEL_WARNING,
+		       "Configured channel (%d) not found from the "
+		       "channel list of current mode (%d) %s",
+		       iface->conf->channel,
+		       iface->current_mode->mode,
+		       hostapd_hw_mode_txt(iface->current_mode->mode));
+	hostapd_logger(iface->bss[0], NULL, HOSTAPD_MODULE_IEEE80211,
+		       HOSTAPD_LEVEL_WARNING,
+		       "Hardware does not support configured channel");
+}
+
+int hostapd_acs_completed(struct hostapd_iface *iface)
+{
+	int ret;
+
+	if (!hostapd_check_chans(iface)) {
+		hostapd_notify_bad_chans(iface);
+		wpa_printf(MSG_ERROR, "ACS picked unusable channels\n");
+		return -1;
+	}
+
+	ret = hostapd_check_ht_capab(iface);
+	if (ret < 0)
+		return -1;
+	if (ret == 1) {
+		wpa_printf(MSG_DEBUG, "Interface initialization will "
+			   "be completed in a callback");
+		return 0;
+	}
+
+	return hostapd_setup_interface_complete(iface, 0);
+}
+
 
 /**
  * hostapd_select_hw_mode - Select the hardware mode
@@ -610,7 +719,7 @@ int hostapd_check_ht_capab(struct hostapd_iface *iface)
  */
 int hostapd_select_hw_mode(struct hostapd_iface *iface)
 {
-	int i, j, ok;
+	int i, ok = 0;
 
 	if (iface->num_hw_features < 1)
 		return -1;
@@ -634,74 +743,15 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
 		return -2;
 	}
 
-	ok = 0;
-	for (j = 0; j < iface->current_mode->num_channels; j++) {
-		struct hostapd_channel_data *chan =
-			&iface->current_mode->channels[j];
-		if (chan->chan == iface->conf->channel) {
-			if (chan->flag & HOSTAPD_CHAN_DISABLED) {
-				wpa_printf(MSG_ERROR,
-					   "channel [%i] (%i) is disabled for "
-					   "use in AP mode, flags: 0x%x",
-					   j, chan->chan, chan->flag);
-			} else {
-				ok = 1;
-				break;
-			}
-		}
-	}
-	if (ok && iface->conf->secondary_channel) {
-		int sec_ok = 0;
-		int sec_chan = iface->conf->channel +
-			iface->conf->secondary_channel * 4;
-		for (j = 0; j < iface->current_mode->num_channels; j++) {
-			struct hostapd_channel_data *chan =
-				&iface->current_mode->channels[j];
-			if (!(chan->flag & HOSTAPD_CHAN_DISABLED) &&
-			    (chan->chan == sec_chan)) {
-				sec_ok = 1;
-				break;
-			}
-		}
-		if (!sec_ok) {
-			hostapd_logger(iface->bss[0], NULL,
-				       HOSTAPD_MODULE_IEEE80211,
-				       HOSTAPD_LEVEL_WARNING,
-				       "Configured HT40 secondary channel "
-				       "(%d) not found from the channel list "
-				       "of current mode (%d) %s",
-				       sec_chan, iface->current_mode->mode,
-				       hostapd_hw_mode_txt(
-					       iface->current_mode->mode));
-			ok = 0;
-		}
-	}
-	if (iface->conf->channel == 0) {
-		/* TODO: could request a scan of neighboring BSSes and select
-		 * the channel automatically */
-		wpa_printf(MSG_ERROR, "Channel not configured "
-			   "(hw_mode/channel in hostapd.conf)");
-		return -3;
-	}
-	if (ok == 0 && iface->conf->channel != 0) {
-		hostapd_logger(iface->bss[0], NULL,
-			       HOSTAPD_MODULE_IEEE80211,
-			       HOSTAPD_LEVEL_WARNING,
-			       "Configured channel (%d) not found from the "
-			       "channel list of current mode (%d) %s",
-			       iface->conf->channel,
-			       iface->current_mode->mode,
-			       hostapd_hw_mode_txt(iface->current_mode->mode));
-		iface->current_mode = NULL;
-	}
-
-	if (iface->current_mode == NULL) {
-		hostapd_logger(iface->bss[0], NULL, HOSTAPD_MODULE_IEEE80211,
-			       HOSTAPD_LEVEL_WARNING,
-			       "Hardware does not support configured channel");
+	ok = hostapd_check_chans(iface);
+	if (!ok) {
+		hostapd_notify_bad_chans(iface);
 		return -4;
 	}
 
+	if (ok == 2) /* ACS will run and later complete */
+		return 1;
+
 	return 0;
 }
 
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 513580a..76af046 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -26,6 +26,7 @@
 #define WPA_SUPPLICANT_DRIVER_VERSION 4
 
 #include "common/defs.h"
+#include "list.h"
 
 #define HOSTAPD_CHAN_DISABLED 0x00000001
 #define HOSTAPD_CHAN_PASSIVE_SCAN 0x00000002
@@ -58,6 +59,29 @@ struct hostapd_channel_data {
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
+	 * min_noise - minimum observed noise, in dBm, based on all surveyed channel data
+	 */
+	s8 min_noise;
+
+#ifdef CONFIG_ACS
+
+        /*
+	 * interference_factor - see http://wireless.kernel.org/en/users/Documentation/acs
+	 */
+	long double survey_interference_factor;
+#endif
 };
 
 /**
@@ -2253,6 +2277,30 @@ struct wpa_driver_ops {
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
+	 * - the observed channel noise
+	 * - the amount of time we have spent on the channel
+	 * - the amount of time during which we have spent on the channel that
+	 *   the radio has determined the the medium is busy and we cannot transmit
+	 * - the amount of time we have spent RX'ing data
+	 * - the amount of time we have spent TX'ing data
+	 *
+	 * This data can be use for spectrum heuristics, one example is
+	 * Automatic Channel Selection (ACS). The channel survey data is
+	 * kept on a linked list on the channel data, one entry is added
+	 * for each survey. The min_noise of the channel is updated for
+	 * each survey.
+	 */
+	int (*get_survey)(void *priv, unsigned int freq);
 };
 
 
@@ -2655,11 +2703,47 @@ enum wpa_event_type {
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
 
 
 /**
+ * struct survey_info - channel survey info
+ *
+ * @ifidx: interface index in which this survey was observed
+ * @freq: center of frequency of the surveyed channel
+ * @noise: channel noise in dBm
+ * @channel_time: amount of time in ms the radio spent on the channel
+ * @channel_time_busy: amount of time in ms the radio detected some signal
+ *	that indicated to the radio the channel was not clear
+ * @channel_time_rx: amount of time the radio spent receiving data
+ * @channel_time_tx: amount of time the radio spent transmitting data
+ */
+struct freq_survey {
+	u32 ifidx;
+	unsigned int freq;
+	s8 noise;
+	u64 channel_time;
+	u64 channel_time_busy;
+	u64 channel_time_rx;
+	u64 channel_time_tx;
+	struct dl_list list_member;
+};
+
+/**
  * union wpa_event_data - Additional data for wpa_supplicant_event() calls
  */
 union wpa_event_data {
@@ -3187,6 +3271,17 @@ union wpa_event_data {
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
index 9fa253e..f0f2c0c 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -6554,6 +6554,198 @@ static const char * nl80211_get_radio_name(void *priv)
 	return drv->phyname;
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
+	survey->noise = (int8_t) nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]);
+	survey->channel_time = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME]);
+	survey->channel_time_busy = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY]);
+	survey->channel_time_rx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]);
+	survey->channel_time_tx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX]);
+
+	wpa_printf(MSG_DEBUG, "nl80211: Freq survey dump event  (freq=%d MHz noise=%d "
+		   "channel_time=%ld busy_time=%ld tx_time=%ld rx_time=%ld)",
+		   survey->freq,
+		   survey->noise,
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
@@ -6624,4 +6816,5 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.set_intra_bss = nl80211_set_intra_bss,
 	.set_param = nl80211_set_param,
 	.get_radio_name = nl80211_get_radio_name,
+	.get_survey = wpa_driver_nl80211_get_survey,
 };
diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index e58abdc..5120046 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -2037,11 +2037,13 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 		break;
 #ifdef CONFIG_P2P
 	case EVENT_REMAIN_ON_CHANNEL:
+		/* TODO - ACS call (if acs active) - or p2p if not */
 		wpas_p2p_remain_on_channel_cb(
 			wpa_s, data->remain_on_channel.freq,
 			data->remain_on_channel.duration);
 		break;
 	case EVENT_CANCEL_REMAIN_ON_CHANNEL:
+		/* TODO - ACS call (if acs active) - or p2p if not */
 		wpas_p2p_cancel_remain_on_channel_cb(
 			wpa_s, data->remain_on_channel.freq);
 		break;
-- 
1.7.4.15.g7811d

