Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59421 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1G2VBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 17:01:23 -0400
Received: by iyb12 with SMTP id 12so4371196iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 14:01:23 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: [PATCH v7 4/4] hostapd: add Automatic Channel Selection (ACS) support
Date: Fri, 29 Jul 2011 14:01:09 -0700
Message-Id: <1311973269-24489-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110729_230128_143624_1632C4BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds Automatic Channel Selection (ACS) support to hostapd
using the Survery based ACS algorithm [1]. You can enable this
with CONFIG_ACS and can use it by setting the channel to "0" or
"acs_survey". Other configurable parameters are:

  * acs_num_req_surveys - must be > 1
  * acs_roc_duration_ms - 1..5000

TODO:

- The current algorithm is heavily based on the amount of time
  we are willing to spend offchannel configurable via acs_roc_duration_ms,
  and acs_num_req_surveys, this will work for the period of time we do
  the analysis, so if these values are too low you'd use an ideal channel
  only based on the short bursts of traffic on the channel. We can also take
  into consideration other data to help us further make a better analysis and
  speed out our decision:

    * Do a scan and count the number of BSSes on each channel:
      * Assign an HT40 primary channel a high interference aggregate value
      * Assign an HT40 secondary channel a lower interference aggregate value
    * Use a frequency broker to collect other PHY RF interference:
      * BT devices, etc, assign interference value aggregates to these

- An ideal result would continue surveying the channels and collect a
  histogram, the ideal channel then will remain ideal for most of the
  collected history.

- Add wpa_supplicant support for ACS, ideal for P2P

- Randomize channel study

- Enable the use passive scan instead of offchannel operation to enable
  drivers that do not support offchannel support

- Get more drivers / firmware to implement / export survey dump

- Any other OSes interested?

[1] http://wireless.kernel.org/en/users/Documentation/acs#Survey_based_algorithm

Signed-off-by: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
---

This v7 fixes an issue reported by MingAnn Ng devil_eddie01@hotmail.com where
busy time is 0. We treat this as log2(0) as 0. Even if busy time is 0 the
interference factor will end up being affected by the detected noise floor on
this channel compared to the lowest noise floor on the band. The amount of time
we dwell on the channel for monitoring will also affect the result.

This v7 also changes the offchannel time from 5ms to 60ms to account possible
calibrations hordware may do right after a channel change, specially for noise
floor calibration. Once we are really happy with these values we may simply
hide them from the user.

 hostapd/Makefile       |   13 ++
 hostapd/config_file.c  |   47 +++++-
 hostapd/defconfig      |   25 +++
 hostapd/hostapd.conf   |   17 ++
 src/ap/acs.c           |  460 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h           |   40 ++++
 src/ap/ap_config.c     |   15 ++
 src/ap/ap_config.h     |    4 +
 src/ap/drv_callbacks.c |    5 +-
 src/ap/hostapd.c       |    2 +
 src/ap/hostapd.h       |    6 +
 src/ap/hw_features.c   |   48 +++++-
 src/drivers/driver.h   |   82 +++++++++
 13 files changed, 757 insertions(+), 7 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

diff --git a/hostapd/Makefile b/hostapd/Makefile
index d2b85af..a4c9f5f 100644
--- a/hostapd/Makefile
+++ b/hostapd/Makefile
@@ -749,6 +749,19 @@ else
 OBJS_c += ../src/utils/edit_simple.o
 endif
 
+#         (__)
+#         (oo)
+#   /------\/
+#  / |    ||
+# *  /\---/\
+#    ~~   ~~
+# ...."Have you mooed today?"...
+ifdef CONFIG_ACS
+CFLAGS += -DCONFIG_ACS
+OBJS += ../src/ap/acs.o
+LIBS += -lm
+endif
+
 ifdef CONFIG_NO_STDOUT_DEBUG
 CFLAGS += -DCONFIG_NO_STDOUT_DEBUG
 endif
diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index bfd4809..8073b41 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1736,7 +1736,18 @@ struct hostapd_config * hostapd_config_read(const char *fname)
 				errors++;
 			}
 		} else if (os_strcmp(buf, "channel") == 0) {
-			conf->channel = atoi(pos);
+			if (os_strcmp(pos, "acs_survey") == 0) {
+				conf->channel = 0;
+			} else
+				conf->channel = atoi(pos);
+#ifndef CONFIG_ACS
+			if (!conf->channel) {
+				wpa_printf(MSG_ERROR, "Line %d: set as '%s' "
+					   "tries to enable ACS but "
+					   "CONFIG_ACS disabled", line, pos);
+				errors++;
+			}
+#endif
 		} else if (os_strcmp(buf, "beacon_int") == 0) {
 			int val = atoi(pos);
 			/* MIB defines range as 1..65535, but very small values
@@ -1751,6 +1762,40 @@ struct hostapd_config * hostapd_config_read(const char *fname)
 				errors++;
 			} else
 				conf->beacon_int = val;
+#ifdef CONFIG_ACS
+		} else if (os_strcmp(buf, "acs_num_req_surveys") == 0) {
+			int val = atoi(pos);
+			if (val <= 0) {
+				wpa_printf(MSG_ERROR, "Line %d: invalid "
+					   "acs_num_req_surveys %d (expected > 1)",
+					   line, val);
+				errors++;
+			} else
+				conf->acs_num_req_surveys = val;
+		} else if (os_strcmp(buf, "acs_roc_duration_ms") == 0) {
+			int val = atoi(pos);
+			/* Well only Linux supports offchannel ops right now ;) */
+			if (val <= 0 || val > 5000) {
+				errors++;
+				wpa_printf(MSG_ERROR, "Line %d: invalid "
+					   "acs_roc_duration_ms %d (expected "
+					   "1..5000)", line, val);
+			} else
+				conf->acs_roc_duration_ms = val;
+#else
+		} else if (os_strcmp(buf, "acs_num_req_surveys") == 0) {
+			int val = atoi(pos);
+			wpa_printf(MSG_ERROR, "Line %d: invalid "
+				   "acs_num_req_surveys %d (CONFIG_ACS disabled)",
+				   line, val);
+			errors++;
+		} else if (os_strcmp(buf, "acs_roc_duration_ms") == 0) {
+			int val = atoi(pos);
+			wpa_printf(MSG_ERROR, "Line %d: invalid "
+				   "acs_roc_duration_ms %d (CONFIG_ACS disabled)"
+				   "1..5000)", line, val);
+			errors++;
+#endif /* CONFIG_ACS */
 		} else if (os_strcmp(buf, "dtim_period") == 0) {
 			bss->dtim_period = atoi(pos);
 			if (bss->dtim_period < 1 || bss->dtim_period > 255) {
diff --git a/hostapd/defconfig b/hostapd/defconfig
index 26be2a8..4e2ec1b 100644
--- a/hostapd/defconfig
+++ b/hostapd/defconfig
@@ -208,3 +208,28 @@ CONFIG_IPV6=y
 # considered for builds that are known to be used on devices that meet the
 # requirements described above.
 #CONFIG_NO_RANDOM_POOL=y
+
+# Enable this to get Automatic Channel Selection support. This will allow
+# hostapd to pick the channel automatically for you when you see the channel to
+# "acs_survey" or "0". Eventually other ACS algorithms can be added in similar way.
+# Automatic selection is currently only done through initialization, later on we
+# hope to do background checks to keep us moving to more ideal channels as time
+# goes by. ACS is currently only supported through the nl80211 driver, and
+# your 802.11 driver must support offchannel TX support and survey dump
+# capablities.
+#
+# You can customize the ACS survey algorithm with the hostapd.conf variables:
+#
+# acs_num_req_surveys requirement is > 1 - number of surverys required per channel
+# acs_roc_duration_ms requirement is 1..5000 - offchannel time
+#
+# Supported ACS drivers:
+#
+# * ath9k
+# * ath5k
+#
+# For more details refer to:
+#
+# http://wireless.kernel.org/en/users/Documentation/acs
+#
+#CONFIG_ACS=y
diff --git a/hostapd/hostapd.conf b/hostapd/hostapd.conf
index cad1caf..9741870 100644
--- a/hostapd/hostapd.conf
+++ b/hostapd/hostapd.conf
@@ -105,8 +105,25 @@ hw_mode=a
 # (default: 0, i.e., not set)
 # Please note that some drivers do not use this value from hostapd and the
 # channel will need to be configured separately with iwconfig.
+#
+# If you enable CONFIG_ACS you can automatically get an ideal channel
+# by setting channel=acs_survey or channel=0, both of these options will
+# trigger the ACS survey based algorithm.
 channel=60
 
+# ACS tuning - Automatic Channel Selection
+# See: http://wireless.kernel.org/en/users/Documentation/acs
+#
+# You can customize the ACS survey algorithm with the hostapd.conf variables:
+#
+# acs_num_req_surveys requirement is > 1 - number of surverys required per channel
+# acs_roc_duration_ms requirement is 1..5000 - offchannel time
+#
+# Defaults:
+#
+#acs_num_req_surveys=10
+#acs_roc_duration_ms=60
+
 # Beacon interval in kus (1.024 ms) (default: 100; range 15..65535)
 beacon_int=100
 
diff --git a/src/ap/acs.c b/src/ap/acs.c
new file mode 100644
index 0000000..04b1e31
--- /dev/null
+++ b/src/ap/acs.c
@@ -0,0 +1,460 @@
+/*
+ * ACS - Automatic Channel Selection module
+ * Copyright (c) 2011, Atheros Communications
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Alternatively, this software may be distributed under the terms of BSD
+ * license.
+ *
+ * See README and COPYING for more details.
+ */
+
+/*
+ * ACS Maintainer: Luis R. Rodriguez <mcgrof@kernel.org>
+ */
+
+#include "includes.h"
+#include "acs.h"
+#include "drivers/driver.h"
+#include "ap/ap_drv_ops.h"
+#include "ap/ap_config.h"
+#include "ap/hw_features.h"
+
+/*
+ * Until we get really bored and implement OS support for
+ * others on os.[ch]
+ */
+#include <math.h>
+
+/*
+ * Automatic Channel Selection
+ *
+ * http://wireless.kernel.org/en/users/Documentation/acs
+ *
+ * This is the hostapd AP ACS implementation
+ *
+ * You get automatic channel selection when you configure hostapd
+ * with a channel=acs_survey or channel=0 on the hostapd.conf file.
+ *
+ * TODO:
+ *
+ * - The current algorithm is heavily based on the amount of time
+ *   we are willing to spend offchannel configurable via acs_roc_duration_ms,
+ *   and acs_num_req_surveys, this will work for the period of time we do
+ *   the analysis, so if these values are too low you'd use an ideal channel
+ *   only based on the short bursts of traffic on the channel. We can also take
+ *   into consideration other data to help us further make a better analysis and
+ *   speed out our decision:
+ *
+ *	* Do a scan and count the number of BSSes on each channel:
+ * 	  * Assign an HT40 primary channel a high interference aggregate value
+ *	  * Assign an HT40 secondary channel a lower interference aggregate value
+ *	* Use a frequency broker to collect other PHY RF interference:
+ *	  * BT devices, etc, assign interference value aggregates to these
+ *
+ * - An ideal result would continue surveying the channels and collect a
+ *   histogram, the ideal channel then will remain ideal for most of the
+ *   collected history.
+ *
+ * - Add wpa_supplicant support for ACS, ideal for P2P
+ *
+ * - Randomize channel study
+ *
+ * - Enable the use passive scan instead of offchannel operation to enable
+ *   drivers that do not support offchannel support
+ *
+ * - Get more drivers / firmware to implement / export survey dump
+ *
+ * - Any other OSes interested?
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
+		chan->min_nf = 0;
+		chan->survey_count = 0;
+	}
+
+	iface->chans_surveyed = 0;
+	iface->off_channel_freq_idx = 0;
+	iface->acs_num_completed_surveys = 0;
+}
+
+void acs_fail(struct hostapd_iface *iface)
+{
+	wpa_printf(MSG_ERROR, "ACS: failed to start");
+	acs_cleanup(iface);
+}
+
+static u64 min(u64 a, u64 b)
+{
+	return (a < b) ? a : b;
+}
+
+/*
+ * Make it fit in the used data type, this is done
+ * so that we always have sane values, otherwise the
+ * values will go out of bounds. We pick 2^30 as that
+ * 2^31 yields -inf on long double -- and we can add
+ * log(2^30) + log(2^30) in a long double as well.
+ */
+static u64 log2_sane(u64 val)
+{
+	return return (!val) ? 0 : log2(min(1073741824, val));
+}
+
+
+static long double acs_survey_interference_factor(struct freq_survey *survey, s8 min_nf)
+{
+	long double factor;
+
+	factor = log2_sane(survey->channel_time_busy - survey->channel_time_tx);
+	factor -= log2_sane(survey->channel_time - survey->channel_time_tx);
+	factor += survey->nf - min_nf;
+
+	return factor;
+}
+
+static void acs_chan_interference_factor(struct hostapd_iface *iface,
+					 struct hostapd_channel_data *chan)
+{
+	struct freq_survey *survey;
+	unsigned int i = 0;
+	long double int_factor = 0;
+
+	if (dl_list_empty(&chan->survey_list) || chan->flag & HOSTAPD_CHAN_DISABLED)
+		return;
+
+	dl_list_for_each(survey, &chan->survey_list, struct freq_survey, list_member) {
+		int_factor = acs_survey_interference_factor(survey, iface->lowest_nf);
+		chan->survey_interference_factor += int_factor;
+		wpa_printf(MSG_DEBUG, "\tsurvey_id: %d"
+			   "\tchan_min_nf: %d\tsurvey_interference_factor: %Lf",
+			   ++i, chan->min_nf, int_factor);
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
+/*
+ * At this point its assumed we have the iface->lowest_nf
+ * and all chan->min_nf values
+ */
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
+		wpa_printf(MSG_DEBUG, "\tChannel survey interference factor average: %Lf",
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
+static enum hostapd_chan_status acs_study_next_freq(struct hostapd_iface *iface)
+{
+	int err;
+	unsigned int i;
+	struct hostapd_channel_data *chan;
+	struct hostapd_data *hapd = iface->bss[0];
+
+	if (iface->off_channel_freq_idx > iface->current_mode->num_channels) {
+		wpa_printf(MSG_ERROR, "ACS: channel index out of bounds");
+		return HOSTAPD_CHAN_INVALID;
+	}
+
+	for (i = iface->off_channel_freq_idx; i < iface->current_mode->num_channels; i++) {
+		chan = &iface->current_mode->channels[i];
+		if (chan->flag & HOSTAPD_CHAN_DISABLED)
+			continue;
+
+		err = hostapd_drv_remain_on_channel(hapd, chan->freq, iface->conf->acs_roc_duration_ms);
+		if (err < 0) {
+			wpa_printf(MSG_ERROR, "ACS: request to go offchannel "
+				   "on freq %d MHz failed",
+				   chan->freq);
+			return HOSTAPD_CHAN_INVALID;
+		}
+
+		iface->off_channel_freq_idx = i;
+
+		return HOSTAPD_CHAN_ACS;
+	}
+
+	if (!iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: unable to survey any channel");
+		return HOSTAPD_CHAN_INVALID;
+	}
+
+	return HOSTAPD_CHAN_VALID;
+}
+
+static void acs_study_complete(struct hostapd_iface *iface)
+{
+	struct hostapd_channel_data *ideal_chan;
+
+	iface->acs_num_completed_surveys++;
+
+	if (iface->acs_num_completed_surveys < iface->conf->acs_num_req_surveys) {
+		iface->off_channel_freq_idx = 0;
+
+		switch (acs_study_next_freq(iface)) {
+		case HOSTAPD_CHAN_ACS:
+			return;
+		case HOSTAPD_CHAN_VALID:
+			/*
+			 * Bullshit, we were expected to do some more bg work
+			 * due to the acs_num_req_surveys.
+			 */
+			wpa_printf(MSG_ERROR, "ACS: odd loop bug, report this...");
+		case HOSTAPD_CHAN_INVALID:
+		default:
+			goto fail;
+		}
+	}
+
+	if (!iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: unable to collect any "
+			   "useful survey data");
+		goto fail;
+	}
+
+	ideal_chan = acs_find_ideal_chan(iface);
+	if (!ideal_chan) {
+		wpa_printf(MSG_ERROR, "ACS: although survey data was collected we "
+			   "were unable to compute an ideal channel");
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
+	iface->conf->channel = ideal_chan->chan;
+	/*
+	 * Note that iface->conf->secondary_channel will be left as
+	 * per your preference for enabling HT40+, HT40- or not using
+	 * HT40 at all.
+	 */
+
+	/*
+	 * hostapd_setup_interface_complete() will return -1 on failure,
+	 * 0 on success and 0 is HOSTAPD_CHAN_VALID :)
+	 */
+	switch (hostapd_acs_completed(iface)) {
+	case HOSTAPD_CHAN_VALID:
+		acs_cleanup(iface);
+		return;
+	case HOSTAPD_CHAN_INVALID:
+	case HOSTAPD_CHAN_ACS:
+	default:
+		wpa_printf(MSG_ERROR, "ACS: although things seemed "
+			   "fine we failed in the end");
+		goto fail;
+	}
+
+fail:
+	acs_fail(iface);
+}
+
+
+static void acs_roc_next(struct hostapd_iface *iface,
+			 unsigned int freq,
+			 unsigned int duration)
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
+	switch (acs_study_next_freq(iface)) {
+	case HOSTAPD_CHAN_VALID:
+		acs_study_complete(iface);
+		return;
+	case HOSTAPD_CHAN_ACS:
+		return;
+	case HOSTAPD_CHAN_INVALID:
+	default:
+		goto fail;
+	}
+
+fail:
+	acs_fail(iface);
+}
+
+void hostapd_notify_acs_roc(struct hostapd_iface *iface,
+			    unsigned int freq,
+			    unsigned int duration,
+			    int roc_status)
+{
+	if (roc_status) {
+		acs_fail(iface);
+		return;
+	}
+
+	/* We'll get an event once completed or cancelled */
+}
+
+void hostapd_notify_acs_roc_cancel(struct hostapd_iface *iface,
+				   unsigned int freq,
+				   unsigned int duration,
+				   int roc_status)
+{
+	if (roc_status) {
+		acs_fail(iface);
+		return;
+	}
+
+	acs_roc_next(iface, freq, duration);
+}
+
+static void acs_init_scan_complete(struct hostapd_iface *iface)
+{
+	wpa_printf(MSG_DEBUG, "ACS: using survey based algorithm "
+		   "(acs_num_req_surveys=%d acs_roc_duration_ms=%d)",
+		   iface->conf->acs_num_req_surveys,
+		   iface->conf->acs_roc_duration_ms);
+
+	acs_cleanup(iface);
+
+	iface->acs_num_completed_surveys = 0;
+
+	switch (acs_study_next_freq(iface)) {
+	case HOSTAPD_CHAN_ACS:
+		return;
+	case HOSTAPD_CHAN_VALID:
+	case HOSTAPD_CHAN_INVALID:
+	default:
+		acs_fail(iface);
+	}
+}
+
+static int acs_init_scan(struct hostapd_iface *iface)
+{
+	struct wpa_driver_scan_params params;
+
+	wpa_printf(MSG_DEBUG, "ACS: initial scan just to kick off the hw a bit...");
+	os_memset(&params, 0, sizeof(params));
+
+	if (hostapd_driver_scan(iface->bss[0], &params) < 0) {
+		wpa_printf(MSG_ERROR, "ACS: Failed to request initial scan");
+		return -1;
+	}
+
+	iface->scan_cb = acs_init_scan_complete;
+	return 1;
+}
+
+static int acs_sanity_check(struct hostapd_iface *iface)
+{
+
+	/* Meh? */
+	if (iface->chans_surveyed) {
+		wpa_printf(MSG_ERROR, "ACS: no usable channels found");
+		return -1;
+        }
+
+	if (!(iface->drv_flags & WPA_DRIVER_FLAGS_OFFCHANNEL_TX)) {
+		wpa_printf(MSG_ERROR, "ACS: offchannel TX support required");
+		return -1;
+        }
+
+	return 0;
+}
+
+enum hostapd_chan_status acs_init(struct hostapd_iface *iface)
+{
+	int err;
+
+	wpa_printf(MSG_INFO, "ACS: automatic channel selection started, this may take a bit");
+
+	err = acs_sanity_check(iface);
+	if (err < 0)
+		return HOSTAPD_CHAN_INVALID;
+
+	err = acs_init_scan(iface);
+	if (err < 0)
+		return HOSTAPD_CHAN_INVALID;
+	else if (err == 1)
+		return HOSTAPD_CHAN_ACS;
+	else
+		return HOSTAPD_CHAN_INVALID;
+}
diff --git a/src/ap/acs.h b/src/ap/acs.h
new file mode 100644
index 0000000..1397160
--- /dev/null
+++ b/src/ap/acs.h
@@ -0,0 +1,40 @@
+#ifndef __ACS_H
+#define __ACS_H
+
+#include "utils/common.h"
+#include "ap/hostapd.h"
+#include "list.h"
+
+#ifdef CONFIG_ACS
+enum hostapd_chan_status acs_init(struct hostapd_iface *iface);
+void hostapd_notify_acs_roc(struct hostapd_iface *iface,
+			    unsigned int freq,
+			    unsigned int duration,
+			    int roc_status);
+void hostapd_notify_acs_roc_cancel(struct hostapd_iface *iface,
+				   unsigned int freq,
+				   unsigned int duration,
+				   int roc_status);
+int hostapd_acs_completed(struct hostapd_iface *iface);
+#else
+static inline enum hostapd_chan_status acs_init(struct hostapd_iface *iface)
+{
+	wpa_printf(MSG_ERROR, "ACS was disabled on your build, "
+		   "rebuild hostapd with CONFIG_ACS=1");
+	return HOSTAPD_CHAN_INVALID;
+}
+static inline void hostapd_notify_acs_roc(struct hostapd_iface *iface,
+					  unsigned int freq,
+					  unsigned int duration,
+					  int roc_status)
+{
+}
+static inline void hostapd_notify_acs_roc_cancel(struct hostapd_iface *iface,
+						 unsigned int freq,
+						 unsigned int duration,
+						 int roc_status)
+{
+}
+#endif /* CONFIG_ACS */
+
+#endif /* __ACS_H */
diff --git a/src/ap/ap_config.c b/src/ap/ap_config.c
index e77716b..35f028c 100644
--- a/src/ap/ap_config.c
+++ b/src/ap/ap_config.c
@@ -96,6 +96,19 @@ void hostapd_config_defaults_bss(struct hostapd_bss_config *bss)
 }
 
 
+#ifdef CONFIG_ACS
+static void hostapd_config_acs_defaults(struct hostapd_config *conf)
+{
+	conf->acs_num_req_surveys = 10;
+	conf->acs_roc_duration_ms = 60;
+}
+#else
+static void hostapd_config_acs_defaults(struct hostapd_config *conf)
+{
+}
+#endif
+
+
 struct hostapd_config * hostapd_config_defaults(void)
 {
 #define ecw2cw(ecw) ((1 << (ecw)) - 1)
@@ -162,6 +175,8 @@ struct hostapd_config * hostapd_config_defaults(void)
 
 	conf->ht_capab = HT_CAP_INFO_SMPS_DISABLED;
 
+	hostapd_config_acs_defaults(conf);
+
 	return conf;
 }
 
diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 09eed5a..b145e60 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -394,6 +394,10 @@ struct hostapd_config {
 	int ieee80211n;
 	int secondary_channel;
 	int require_ht;
+#ifdef CONFIG_ACS
+	unsigned int acs_num_req_surveys;
+	unsigned int acs_roc_duration_ms;
+#endif
 };
 
 
diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index 44e1147..24383a5 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -35,6 +35,7 @@
 #include "wps_hostapd.h"
 #include "ap_drv_ops.h"
 #include "ap_config.h"
+#include "acs.h"
 
 
 int hostapd_notif_assoc(struct hostapd_data *hapd, const u8 *addr,
@@ -531,7 +532,7 @@ static void hostapd_event_roc(struct hostapd_data *hapd,
 	int err;
 
 	err = hostapd_roc_channel_check(iface);
-	/* XXX: pass err to listeners, no one yet */
+	hostapd_notify_acs_roc(iface, freq, duration, err);
 }
 
 static void hostapd_event_roc_cancel(struct hostapd_data *hapd,
@@ -542,7 +543,7 @@ static void hostapd_event_roc_cancel(struct hostapd_data *hapd,
 	int err;
 
 	err = hostapd_roc_channel_check(iface);
-	/* XXX: pass err to listeners, no one yet */
+	hostapd_notify_acs_roc_cancel(iface, freq, duration, err);
 }
 
 struct hostapd_channel_data *hostapd_get_mode_channel(struct hostapd_iface *iface,
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index f00a544..c8a583c 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -702,6 +702,8 @@ static int setup_interface(struct hostapd_iface *iface)
 				   "channel. (%d)", ret);
 			return -1;
 		}
+		if (ret == 1)
+			return 0;
 		ret = hostapd_check_ht_capab(iface);
 		if (ret < 0)
 			return -1;
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index 18e582b..19c5806 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -240,6 +240,12 @@ struct hostapd_iface {
 	/* lowest observed noise floor in dBm */
 	s8 lowest_nf;
 
+#ifdef CONFIG_ACS
+	/* ACS helpers */
+	unsigned int acs_num_completed_surveys;
+	unsigned int acs_num_req_surveys;
+#endif
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 887744b..4596681 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -25,6 +25,7 @@
 #include "ap_config.h"
 #include "ap_drv_ops.h"
 #include "hw_features.h"
+#include "acs.h"
 
 
 void hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
@@ -648,10 +649,18 @@ static enum hostapd_chan_status hostapd_check_chans(struct hostapd_iface *iface)
 	}
 
 	/*
-	 * The user set channel=0 which is used to trigger ACS,
-	 * which we do not yet support.
+	 * The user set channel=0 or channel=acs_survey
+	 * which is used to trigger ACS.
 	 */
-	return HOSTAPD_CHAN_INVALID;
+
+	switch (acs_init(iface)) {
+	case HOSTAPD_CHAN_ACS:
+		return HOSTAPD_CHAN_ACS;
+	case HOSTAPD_CHAN_VALID:
+	case HOSTAPD_CHAN_INVALID:
+	default:
+		return HOSTAPD_CHAN_INVALID;
+	}
 }
 
 static void hostapd_notify_bad_chans(struct hostapd_iface *iface)
@@ -671,6 +680,36 @@ static void hostapd_notify_bad_chans(struct hostapd_iface *iface)
 		       "Hardware does not support configured channel");
 }
 
+int hostapd_acs_completed(struct hostapd_iface *iface)
+{
+	int ret;
+
+	switch (hostapd_check_chans(iface)) {
+	case HOSTAPD_CHAN_VALID:
+		break;
+	case HOSTAPD_CHAN_ACS: /* WTF */
+		wpa_printf(MSG_ERROR, "ACS complete but not.. odd report this..");
+		hostapd_notify_bad_chans(iface);
+		return -1;
+	case HOSTAPD_CHAN_INVALID:
+	default:
+		wpa_printf(MSG_ERROR, "ACS picked unusable channels");
+		hostapd_notify_bad_chans(iface);
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
  * @iface: Pointer to interface data.
@@ -708,7 +747,8 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
 	switch (hostapd_check_chans(iface)) {
 	case HOSTAPD_CHAN_VALID:
 		return 0;
-	case HOSTAPD_CHAN_ACS: /* ACS not supported yet */
+	case HOSTAPD_CHAN_ACS: /* ACS will run and later complete */
+		return 1;
 	case HOSTAPD_CHAN_INVALID:
 	default:
 		hostapd_notify_bad_chans(iface);
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 7ebba43..546fc85 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -75,6 +75,88 @@ struct hostapd_channel_data {
 	 */
 	s8 min_nf;
 
+#ifdef CONFIG_ACS
+	/**
+	 * survey_interference_factor - computed interference factor on this channel
+	 * The survey interference factor is defined as the ratio of the observed busy time
+	 * over the time we spent on the channel, this value is then amplified by the observed
+	 * noise floor on the channel in comparison to the lowest noise floor observed on the
+	 * entire band.
+	 *
+	 * This corresponds to:
+	 * ---
+	 * (busy time - tx time) / (active time - tx time) * 2^(chan_nf + band_min_nf)
+	 * ---
+	 *
+	 * The coefficient of of 2 reflects the way power in "far-field"
+	 * radiation decreases as the square of distance from the antenna [1].
+	 * What this does is it decreases the observed busy time ratio if the
+	 * noise observed was low but increases it if the noise was high,
+	 * proportionally to the way "far field" radiation changes over
+	 * distance. Since the values obtained here can vary from fractional to
+	 * millions the sane thing to do here is to use log2() to reflect the
+	 * observed interference factor. log2() values less than 0 then
+	 * represent fractional results, while > 1 values non-fractional
+	 * results. The computation of the interference factor then becomes:
+	 *
+	 * ---
+	 * log2( (busy time - tx time) / (active time - tx time) * 2^(chan_nf + band_min_nf))
+	 * --- or due to logarithm identities:
+	 * log2(busy time - tx time) - log2(active time - tx time) + log2(2^(chan_nf + band_min_nf))
+	 * ---
+	 *
+	 * All this is "interference factor" is purely subjective and ony time
+	 * will tell how usable this is. By using the minimum noise floor we
+	 * remove any possible issues due to card calibration. The computation
+	 * of the interference factor then is dependent on what the card itself
+	 * picks up as the minimum noise, not an actual real possible card
+	 * noise value.
+	 *
+	 * Example values:
+	 *
+	 * 2412 MHz: 7.429173
+	 * 2417 MHz: 10.460830
+	 * 2422 MHz: 12.671070
+	 * 2427 MHz: 13.583892
+	 * 2432 MHz: 13.405357
+	 * 2442 MHz: 13.566887
+	 * 2447 MHz: 15.630824
+	 * 2452 MHz: 14.639748
+	 * 2457 MHz: 14.139193
+	 * 2467 MHz: 11.914643
+	 * 2472 MHz: 16.996074
+	 * 2484 MHz: 15.175455
+	 * 5180 MHz: -0.218548
+	 * 5200 MHz: -2.204059
+	 * 5220 MHz: -1.762898
+	 * 5240 MHz: -1.314665
+	 * 5260 MHz: -3.100989
+	 * 5280 MHz: -2.157037
+	 * 5300 MHz: -1.842629
+	 * 5320 MHz: -1.498928
+	 * 5500 MHz: 3.304770
+	 * 5520 MHz: 2.345992
+	 * 5540 MHz: 2.749775
+	 * 5560 MHz: 2.390887
+	 * 5580 MHz: 2.592958
+	 * 5600 MHz: 2.420149
+	 * 5620 MHz: 2.650282
+	 * 5640 MHz: 2.954027
+	 * 5660 MHz: 2.991007
+	 * 5680 MHz: 2.955472
+	 * 5700 MHz: 2.280499
+	 * 5745 MHz: 2.388630
+	 * 5765 MHz: 2.332542
+	 * 5785 MHz: 0.955708
+	 * 5805 MHz: 1.025377
+	 * 5825 MHz: 0.843392
+	 *
+	 * In this example the ideal channel then is 5260 MHz
+	 *
+	 * [1] http://en.wikipedia.org/wiki/Near_and_far_field
+	 */
+	long double survey_interference_factor;
+#endif
 };
 
 /**
-- 
1.7.4.15.g7811d

