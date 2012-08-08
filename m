Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39545 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997Ab2HHMCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:16 -0400
Received: by ghrr11 with SMTP id r11so704288ghr.33
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:15 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 2/7] hostapd: add channel switch ability
Date: Wed,  8 Aug 2012 14:55:33 +0300
Message-Id: <1344426938-1883-3-git-send-email-victorg@ti.com> (sfid-20120808_140220_885327_67B4A25C)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add channel switch command and handle channel switch
complete event.

New hostapd_eid_csa() which builds the channel switch
announcement IE. Add this CSA to the beacon frame prior
performing a channel switch and remove it once it's
completed.

Set WLAN_CAPABILITY_SPECTRUM_MGMT bit in the capability
information field in beacon frames and probe response
frames.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 hostapd/config_file.c |   10 ++++
 src/ap/ap_config.h    |    1 +
 src/ap/beacon.c       |   16 ++++++
 src/ap/hostapd.c      |  145 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/hostapd.h      |    7 +++
 src/ap/hw_features.c  |   18 ++++++
 src/ap/hw_features.h  |    1 +
 src/ap/ieee802_11.c   |  117 +++++++++++++++++++++++++++++++++++++++
 src/ap/ieee802_11.h   |    4 ++
 src/drivers/driver.h  |   16 ++++++
 10 files changed, 335 insertions(+), 0 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index 03f29ad..2f28375 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1304,6 +1304,12 @@ static int hostapd_config_check(struct hostapd_config *conf)
 		return -1;
 	}
 
+	if (conf->ieee80211h && (!conf->ieee80211d)) {
+		wpa_printf(MSG_ERROR, "Cannot enable IEEE 802.11h without "
+			   "IEEE 802.11d enabled");
+		return -1;
+	}
+
 	for (i = 0; i < conf->num_bss; i++) {
 		if (hostapd_config_check_bss(&conf->bss[i], conf))
 			return -1;
@@ -1526,6 +1532,10 @@ static int hostapd_config_fill(struct hostapd_config *conf,
 			conf->country[2] = ' ';
 		} else if (os_strcmp(buf, "ieee80211d") == 0) {
 			conf->ieee80211d = atoi(pos);
+		} else if (os_strcmp(buf, "ieee80211h") == 0) {
+			conf->ieee80211h = atoi(pos);
+		} else if (os_strcmp(buf, "channel_switch_count") == 0) {
+			conf->channel_switch_count = atoi(pos);
 		} else if (os_strcmp(buf, "ieee8021x") == 0) {
 			bss->ieee802_1x = atoi(pos);
 		} else if (os_strcmp(buf, "eapol_version") == 0) {
diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index c21a7a8..2b88546 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -456,6 +456,7 @@ struct hostapd_config {
 
 	/* DFS */
 	int channel_switch_count;
+	int ieee80211h;
 
 	struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];
 
diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index ca3f054..9455d2b 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -172,6 +172,19 @@ static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
 	return pos;
 }
 
+static u8 *hostapd_eid_csa(struct hostapd_data *hapd, u8 *eid)
+{
+	if (!(hapd->iconf->ieee80211h) || !(hapd->next_channel))
+		return eid;
+
+	*eid++ = WLAN_EID_CHANNEL_SWITCH;
+	*eid++ = 3; /* IE length */
+	*eid++ = 1; /* STAs should cease transmit */
+	*eid++ = (u8)hapd->next_channel->chan;
+	*eid++ = (u8)hapd->iconf->channel_switch_count;
+	return eid;
+}
+
 
 static u8 * hostapd_eid_wpa(struct hostapd_data *hapd, u8 *eid, size_t len)
 {
@@ -578,6 +591,9 @@ void ieee802_11_set_beacon(struct hostapd_data *hapd)
 	tailpos = hostapd_eid_country(hapd, tailpos,
 				      tail + BEACON_TAIL_BUF_SIZE - tailpos);
 
+	/* Channel Switch Announcement */
+	tailpos = hostapd_eid_csa(hapd, tailpos);
+
 	/* ERP Information element */
 	tailpos = hostapd_eid_erp_info(hapd, tailpos);
 
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index ba8d832..2fbc6ef 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -1103,3 +1103,148 @@ void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 	eloop_register_timeout(hapd->conf->ap_max_inactivity, 0,
 			       ap_handle_timer, hapd, sta);
 }
+
+struct hostapd_channel_data *hostapd_dfs_get_valid_channel(struct hostapd_data
+							   *hapd)
+{
+	struct hostapd_hw_modes *mode;
+	struct hostapd_channel_data *chan;
+	int i, channel_idx = 0, new_channel_idx;
+	struct os_time now;
+	u32 rand;
+
+	wpa_printf(MSG_DEBUG, "Selecting next channel");
+
+	if (hapd->iface->current_mode == NULL)
+		return NULL;
+
+	mode = hapd->iface->current_mode;
+	if (mode->mode != HOSTAPD_MODE_IEEE80211A)
+		return NULL;
+
+	os_get_time(&now);
+
+	for (i = 0; i < mode->num_channels; i++) {
+		chan = &mode->channels[i];
+
+		if (chan->flag & HOSTAPD_CHAN_DISABLED)
+			continue;
+
+		/*
+		 * Reactivate the disabled channels after
+		 * Non-Occupancy Period.
+		 */
+		if (chan->flag & HOSTAPD_CHAN_RADAR_DETECTED) {
+			if ((chan->last_radar_detection.sec +
+			    DFS_MIN_NON_OCC_TIME_SEC) < now.sec) {
+				wpa_printf(MSG_DEBUG, "Activating channel %d.",
+					   chan->chan);
+				chan->flag &= ~HOSTAPD_CHAN_RADAR_DETECTED;
+				chan->last_radar_detection.sec = 0;
+				chan->last_radar_detection.usec = 0;
+			} else
+				continue;
+		}
+		channel_idx++;
+	}
+
+	os_get_random((u8 *)&rand, sizeof(rand));
+	new_channel_idx = rand % channel_idx;
+
+	for (i = 0, channel_idx = 0; i < mode->num_channels; i++) {
+		chan = &mode->channels[i];
+		if (chan->flag & (HOSTAPD_CHAN_DISABLED |
+		    HOSTAPD_CHAN_RADAR_DETECTED))
+			continue;
+		if (channel_idx == new_channel_idx) {
+			wpa_printf(MSG_DEBUG, "Selected ch. #%d", chan->chan);
+			return chan;
+		}
+		channel_idx++;
+	}
+
+	return NULL;
+}
+
+void hostapd_resume_dfs_cac(void *eloop_ctx, void *timeout_ctx)
+{
+	struct hostapd_data *hapd = eloop_ctx;
+	int flag;
+
+	wpa_printf(MSG_DEBUG, "Resuming DFS channel availability check");
+
+	flag = hostapd_hw_get_channel_flag(hapd, hapd->iconf->channel);
+
+	/*
+	 * We get here after successful CAC (channel availability check) during:
+	 * 1. Initialization: in this case we continue with the init flow.
+	 * 2. Operational mode: system switched to a DFS channel (probably due
+	 * to radar event), which requires to perform a CAC prior enabling the
+	 * tx on the new channel.
+	 */
+
+	if (hapd->iface->dfs_state & DFS_INIT_PHASE_CAC) {
+		eloop_terminate();
+		hapd->iface->dfs_state &= ~DFS_INIT_PHASE_CAC;
+	}
+
+	/* Enable TX on operational channel */
+	hostapd_enable_tx(hapd, hapd->iface->freq, flag);
+}
+
+int hostapd_check_set_freq(struct hostapd_data *hapd)
+{
+	int flag;
+
+	wpa_printf(MSG_DEBUG, "Check and set freq %d, channel %d",
+		   hapd->iface->freq, hapd->iconf->channel);
+
+	flag = hostapd_hw_get_channel_flag(hapd, hapd->iconf->channel);
+
+	if ((flag & HOSTAPD_CHAN_RADAR) &&
+	    !(hapd->iface->dfs_state & DFS_ENABLED)) {
+		wpa_printf(MSG_ERROR, "Can't set DFS frequency, "
+			   "DFS functionality is not enabled/supported");
+		return -1;
+	}
+
+	if (hostapd_set_freq(hapd, hapd->iconf->hw_mode,
+				   hapd->iface->freq,
+				   hapd->iconf->channel,
+				   hapd->iconf->ieee80211n,
+				   hapd->iconf->secondary_channel)) {
+		wpa_printf(MSG_ERROR, "Could not set channel for "
+			   "kernel driver");
+		return -1;
+	}
+
+	if (flag & HOSTAPD_CHAN_RADAR) {
+		if (hostapd_start_radar_detection(hapd, hapd->iface->freq,
+						  flag)) {
+			wpa_printf(MSG_ERROR, "Could not start "
+				   "radar detection for kernel driver");
+			return -1;
+		}
+		wpa_printf(MSG_DEBUG, "CAC, listen %d seconds for radar "
+			   "interference", DFS_MIN_CAC_TIME_SEC);
+
+		eloop_register_timeout(DFS_MIN_CAC_TIME_SEC, 0,
+				       hostapd_resume_dfs_cac, hapd, NULL);
+
+		/*
+		 * Listen for radar interference for CAC period, eloop_run()
+		 * will be terminated after CAC timeout.
+		 */
+		if (!(hapd->iface->dfs_state & DFS_INIT_PHASE_CAC)) {
+			hapd->iface->dfs_state |= DFS_INIT_PHASE_CAC;
+			eloop_run();
+		}
+
+	} else if (hapd->iface->dfs_state & DFS_INIT_PHASE_CAC) {
+		wpa_printf(MSG_DEBUG, "moved to non-DFS channel");
+		hapd->iface->dfs_state &= ~DFS_INIT_PHASE_CAC;
+		hostapd_enable_tx(hapd, hapd->iface->freq, flag);
+		eloop_terminate();
+	}
+	return 0;
+}
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index cdd7556..4465e82 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -156,6 +156,8 @@ struct hostapd_data {
 	void (*setup_complete_cb)(void *ctx);
 	void *setup_complete_cb_ctx;
 
+	struct hostapd_channel_data *next_channel;
+
 #ifdef CONFIG_P2P
 	struct p2p_data *p2p;
 	struct p2p_group *p2p_group;
@@ -271,6 +273,8 @@ void hostapd_interface_deinit(struct hostapd_iface *iface);
 void hostapd_interface_free(struct hostapd_iface *iface);
 void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 			   int reassoc);
+struct hostapd_channel_data *hostapd_dfs_get_valid_channel(struct hostapd_data
+							   *hapd);
 
 /* utils.c */
 int hostapd_register_probereq_cb(struct hostapd_data *hapd,
@@ -291,5 +295,8 @@ int hostapd_probe_req_rx(struct hostapd_data *hapd, const u8 *sa, const u8 *da,
 			 int ssi_signal);
 void hostapd_event_ch_switch(struct hostapd_data *hapd, int freq, int ht,
 			     int offset);
+void hostapd_resume_dfs_cac(void *eloop_ctx, void *timeout_ctx);
+int hostapd_check_set_freq(struct hostapd_data *hapd);
+
 
 #endif /* HOSTAPD_H */
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 76c4211..bbd2b03 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -794,3 +794,21 @@ int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq)
 
 	return 0;
 }
+
+
+int hostapd_hw_get_channel_flag(struct hostapd_data *hapd, int chan)
+{
+	int i;
+
+	if (!hapd->iface->current_mode)
+		return 0;
+
+	for (i = 0; i < hapd->iface->current_mode->num_channels; i++) {
+		struct hostapd_channel_data *ch =
+			&hapd->iface->current_mode->channels[i];
+		if (ch->chan == chan)
+			return ch->flag;
+	}
+
+	return 0;
+}
diff --git a/src/ap/hw_features.h b/src/ap/hw_features.h
index abadcd1..b8e287b 100644
--- a/src/ap/hw_features.h
+++ b/src/ap/hw_features.h
@@ -28,6 +28,7 @@ int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq);
 int hostapd_check_ht_capab(struct hostapd_iface *iface);
 int hostapd_prepare_rates(struct hostapd_iface *iface,
 			  struct hostapd_hw_modes *mode);
+int hostapd_hw_get_channel_flag(struct hostapd_data *hapd, int chan);
 #else /* NEED_AP_MLME */
 static inline void
 hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
diff --git a/src/ap/ieee802_11.c b/src/ap/ieee802_11.c
index 3996c90..2269cd5 100644
--- a/src/ap/ieee802_11.c
+++ b/src/ap/ieee802_11.c
@@ -153,6 +153,9 @@ u16 hostapd_own_capab_info(struct hostapd_data *hapd, struct sta_info *sta,
 	    hapd->iface->num_sta_no_short_slot_time == 0)
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 
+	if (hapd->iconf->ieee80211h)
+		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+
 	return capab;
 }
 
@@ -1849,4 +1852,118 @@ void ieee802_11_rx_from_unknown(struct hostapd_data *hapd, const u8 *src,
 }
 
 
+int ieee802_11_radar_detected(struct hostapd_data *hapd)
+{
+	struct hostapd_hw_modes *mode;
+	struct hostapd_channel_data *chan = NULL;
+	struct os_time now;
+	int i;
+
+	eloop_cancel_timeout(hostapd_resume_dfs_cac, hapd, NULL);
+
+	if (hapd->iface->current_mode == NULL)
+		return 0;
+
+	mode = hapd->iface->current_mode;
+	if (mode->mode != HOSTAPD_MODE_IEEE80211A) {
+		wpa_printf(MSG_WARNING, "current_mode != IEEE80211A");
+		return 0;
+	}
+
+	for (i = 0; i < hapd->iface->current_mode->num_channels; i++) {
+		chan = &hapd->iface->current_mode->channels[i];
+		if (chan->freq == hapd->iface->freq) {
+			if (chan->flag & HOSTAPD_CHAN_RADAR) {
+				chan->flag |= HOSTAPD_CHAN_RADAR_DETECTED;
+				os_get_time(&now);
+				chan->last_radar_detection.sec = now.sec;
+				wpa_printf(MSG_DEBUG, "Disabling channel %d, "
+					   "for %d seconds", chan->chan,
+					   DFS_MIN_NON_OCC_TIME_SEC);
+				return 1; /* Channel found */
+			}
+		}
+	}
+	wpa_printf(MSG_WARNING, "Should'n get a radar event on "
+		   "the current freq (%d)", hapd->iface->freq);
+	return 0;
+}
+
+int ieee802_11_start_channel_switch(struct hostapd_data *hapd,
+				    u8 radar_detected)
+{
+	struct hostapd_channel_data *next_channel;
+
+	next_channel = hostapd_dfs_get_valid_channel(hapd);
+
+	if (!next_channel)
+		return -1;
+
+	if (!(hapd->iface->dfs_state & DFS_INIT_PHASE_CAC)) {
+		hapd->next_channel = next_channel;
+		u8 radar_on_next_channel =
+			(next_channel->flag & HOSTAPD_CHAN_RADAR) ? 1 : 0;
+		wpa_printf(MSG_DEBUG, "switching to %sch. #%d, freq %d",
+			   radar_on_next_channel ? "(DFS) " : "",
+			   next_channel->chan, next_channel->freq);
+
+		/* Add CSA */
+		ieee802_11_set_beacon(hapd);
+
+		if (hostapd_channel_switch(hapd, next_channel->freq,
+					   next_channel->flag,
+					   radar_detected,
+					   radar_on_next_channel)) {
+			wpa_printf(MSG_ERROR, "Channel switch failed");
+			return -1;
+		}
+	} else {
+		hapd->iconf->channel = next_channel->chan;
+		hapd->iface->freq = next_channel->freq;
+
+		if (hostapd_check_set_freq(hapd)) {
+			wpa_printf(MSG_ERROR, "Couldn't check/set freq, "
+				   "terminating");
+			eloop_terminate();
+			return -1;
+		}
+	}
+	return 0;
+}
+
+int ieee802_11_complete_channel_switch(struct hostapd_data *hapd)
+{
+
+	wpa_printf(MSG_DEBUG, "Completing channel switch");
+
+	if (hapd->next_channel == NULL) {
+		wpa_printf(MSG_WARNING, "next_channel is not defined");
+		return 0;
+	}
+
+	hapd->iconf->channel = (u8)hapd->next_channel->chan;
+	hapd->iface->freq = hapd->next_channel->freq;
+
+	if (hapd->next_channel->flag & HOSTAPD_CHAN_RADAR) {
+		if (hostapd_start_radar_detection(hapd, hapd->iface->freq,
+						  hapd->next_channel->flag)) {
+			wpa_printf(MSG_ERROR, "Could not start radar "
+				   "detection for kernel driver");
+		    return -1;
+		}
+		eloop_register_timeout(DFS_MIN_CAC_TIME_SEC, 0,
+				       hostapd_resume_dfs_cac, hapd, NULL);
+		wpa_printf(MSG_DEBUG, "listen %d seconds for radar "
+			   "interference prior enabling the tx",
+			   DFS_MIN_CAC_TIME_SEC);
+	}
+
+	hapd->next_channel = NULL;
+	/* Remove CSA */
+	ieee802_11_set_beacon(hapd);
+
+	return 0;
+}
+
+
 #endif /* CONFIG_NATIVE_WINDOWS */
diff --git a/src/ap/ieee802_11.h b/src/ap/ieee802_11.h
index 9993bee..1539045 100644
--- a/src/ap/ieee802_11.h
+++ b/src/ap/ieee802_11.h
@@ -75,5 +75,9 @@ u8 * hostapd_eid_time_zone(struct hostapd_data *hapd, u8 *eid);
 int hostapd_update_time_adv(struct hostapd_data *hapd);
 void hostapd_client_poll_ok(struct hostapd_data *hapd, const u8 *addr);
 u8 * hostapd_eid_bss_max_idle_period(struct hostapd_data *hapd, u8 *eid);
+int ieee802_11_radar_detected(struct hostapd_data *hapd);
+int ieee802_11_start_channel_switch(struct hostapd_data *hapd,
+				    u8 radar_detected);
+int ieee802_11_complete_channel_switch(struct hostapd_data *hapd);
 
 #endif /* IEEE802_11_H */
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index bc714e8..047a5aa 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -28,6 +28,7 @@
 #define HOSTAPD_CHAN_HT40PLUS 0x00000010
 #define HOSTAPD_CHAN_HT40MINUS 0x00000020
 #define HOSTAPD_CHAN_HT40 0x00000040
+#define HOSTAPD_CHAN_RADAR_DETECTED 0x00000080
 
 /*
  * DFS functionality is enabled.
@@ -35,6 +36,11 @@
 #define DFS_ENABLED			BIT(0)
 
 /*
+ * DFS channel availability check during initialization.
+ */
+#define DFS_INIT_PHASE_CAC		BIT(1)
+
+/*
  * DFS Channel Availability Check Time - the time a system shall monitor a
  * 'radar channel' for presence of radar prior to initiating a TX, spec defines
  * it as 60 seconds.
@@ -42,6 +48,14 @@
  */
 #define DFS_MIN_CAC_TIME_SEC		60
 
+/*
+ * DFS Non-Occupancy Time - a period of time after radar is detected on a
+ * channel that the channel may not be used.
+ *
+ */
+#define DFS_MIN_NON_OCC_TIME_SEC	1800
+
+
 /**
  * struct hostapd_channel_data - Channel information
  */
@@ -65,6 +79,8 @@ struct hostapd_channel_data {
 	 * max_tx_power - maximum transmit power in dBm
 	 */
 	u8 max_tx_power;
+
+	struct os_time last_radar_detection;
 };
 
 #define HOSTAPD_MODE_FLAG_HT_INFO_KNOWN BIT(0)
-- 
1.7.5.4

