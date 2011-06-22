Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab1FVAcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 20:32:24 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 17:31:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] hostapd: add Automatic Channel Selection (ACS) support
Date: Tue, 21 Jun 2011 17:32:20 -0700
Message-ID: <1308702740-4757-1-git-send-email-lrodriguez@atheros.com> (sfid-20110622_023229_021241_C87443AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds Automatic Channel Selection (ACS) support to hostapd
using the Survery based ACS algorithm [1].

[1] http://wireless.kernel.org/en/users/Documentation/acs#Survey_based_algorithm

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This is an all in one patch which I intend on splitting up later but
for now I'd like to review / testing. The patch is a bit crude as
I have just finished it and have not gone back to cleanup the
documentation and style everywhere but should be enough for
first review.

 hostapd/Makefile             |    5 +
 hostapd/defconfig            |    3 +
 src/ap/ap_drv_ops.h          |   27 ++++++
 src/ap/drv_callbacks.c       |  152 ++++++++++++++++++++++++++++++++-
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   14 +++
 src/ap/hw_features.c         |  182 +++++++++++++++++++++++++--------------
 src/drivers/driver.h         |   97 +++++++++++++++++++++-
 src/drivers/driver_nl80211.c |  195 ++++++++++++++++++++++++++++++++++++++++++
 wpa_supplicant/events.c      |    2 +
 10 files changed, 611 insertions(+), 68 deletions(-)

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
index 9fa253e..05bd8cd 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -171,6 +171,8 @@ struct wpa_driver_nl80211_data {
 
 	struct i802_bss first_bss;
 
+	unsigned int survey_freq_filter;
+
 #ifdef HOSTAPD
 	int eapol_sock; /* socket for EAPOL frames */
 
@@ -6554,6 +6556,198 @@ static const char * nl80211_get_radio_name(void *priv)
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
@@ -6624,4 +6818,5 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
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

