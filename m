Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:59873 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab2AZMm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:29 -0500
Received: by ghbf1 with SMTP id f1so7003856ghb.30
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:42:27 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>
Subject: [RFC 2/7] hostapd: add channel switch ability
Date: Thu, 26 Jan 2012 14:41:24 +0200
Message-Id: <1327581689-22090-3-git-send-email-victorg@ti.com> (sfid-20120126_134231_859662_5C355173)
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add channel switch command and handle channel switch
complete event.

New hostapd_eid_csa() which builds the channel switch
announcement, add CSA logic into ieee802_11_set_beacon().

Set WLAN_CAPABILITY_SPECTRUM_MGMT bit in the capability
information field in beacon frames and probe response
frames.

Signed-off-by: Boris Presman <boris.presman@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 hostapd/config_file.c |   10 ++++
 src/ap/ap_config.h    |    1 +
 src/ap/beacon.c       |   16 ++++++
 src/ap/hostapd.c      |  141 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/hostapd.h      |   10 ++++
 src/ap/hw_features.c  |   18 ++++++
 src/ap/hw_features.h  |    1 +
 src/ap/ieee802_11.c   |  116 ++++++++++++++++++++++++++++++++++++++++
 src/ap/ieee802_11.h   |    4 ++
 src/drivers/driver.h  |   26 +++++++++
 10 files changed, 343 insertions(+), 0 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index 467d39f..5d412e0 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1141,6 +1141,12 @@ static int hostapd_config_check(struct hostapd_config *conf)
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
@@ -1342,6 +1348,10 @@ struct hostapd_config * hostapd_config_read(const char *fname)
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
index eddc9b7..f635347 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -412,6 +412,7 @@ struct hostapd_config {
 
 	/* DFS */
 	int channel_switch_count;
+	int ieee80211h;
 
 	struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];
 
diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index 4ea8684..714f89d 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -171,6 +171,19 @@ static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
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
@@ -567,6 +580,9 @@ void ieee802_11_set_beacon(struct hostapd_data *hapd)
 	tailpos = hostapd_eid_country(hapd, tailpos,
 				      tail + BEACON_TAIL_BUF_SIZE - tailpos);
 
+	/* Channel Switch Announcement */
+	tailpos = hostapd_eid_csa(hapd, tailpos);
+
 	/* ERP Information element */
 	tailpos = hostapd_eid_erp_info(hapd, tailpos);
 
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index 0c5ee2e..ce37922 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -944,3 +944,144 @@ void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 	} else
 		wpa_auth_sta_associated(hapd->wpa_auth, sta->wpa_sm);
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
+
+	wpa_printf(MSG_DEBUG, "Resuming DFS channel availability check");
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
+	hostapd_enable_tx(hapd);
+}
+
+int hostapd_check_set_freq(struct hostapd_data *hapd)
+{
+	int flag;
+
+	wpa_printf(MSG_DEBUG, "Check and set freq %d, channel %d",
+		   hapd->iface->freq, hapd->iconf->channel);
+
+	flag = hostapd_get_channel_flag(hapd, hapd->iconf->channel);
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
+		if (hostapd_start_radar_detection(hapd)) {
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
+		hostapd_enable_tx(hapd);
+		eloop_terminate();
+	}
+	return 0;
+}
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index c6f6205..c506a69 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -155,6 +155,8 @@ struct hostapd_data {
 	void (*setup_complete_cb)(void *ctx);
 	void *setup_complete_cb_ctx;
 
+	struct hostapd_channel_data *next_channel;
+
 #ifdef CONFIG_P2P
 	struct p2p_data *p2p;
 	struct p2p_group *p2p_group;
@@ -236,6 +238,10 @@ struct hostapd_iface {
 	int olbc_ht;
 
 	u16 ht_op_mode;
+
+	/* dfs states */
+	u8 dfs_state;
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
@@ -258,6 +264,8 @@ void hostapd_interface_deinit(struct hostapd_iface *iface);
 void hostapd_interface_free(struct hostapd_iface *iface);
 void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 			   int reassoc);
+struct hostapd_channel_data *hostapd_dfs_get_valid_channel(struct hostapd_data
+							   *hapd);
 
 /* utils.c */
 int hostapd_register_probereq_cb(struct hostapd_data *hapd,
@@ -274,5 +282,7 @@ void hostapd_notif_disassoc(struct hostapd_data *hapd, const u8 *addr);
 void hostapd_event_sta_low_ack(struct hostapd_data *hapd, const u8 *addr);
 int hostapd_probe_req_rx(struct hostapd_data *hapd, const u8 *sa, const u8 *da,
 			 const u8 *bssid, const u8 *ie, size_t ie_len);
+void hostapd_resume_dfs_cac(void *eloop_ctx, void *timeout_ctx);
+int hostapd_check_set_freq(struct hostapd_data *hapd);
 
 #endif /* HOSTAPD_H */
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 8c6fef2..d64fbeb 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -751,3 +751,21 @@ int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq)
 
 	return 0;
 }
+
+
+int hostapd_get_channel_flag(struct hostapd_data *hapd, int chan)
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
index abadcd1..c8a7f60 100644
--- a/src/ap/hw_features.h
+++ b/src/ap/hw_features.h
@@ -28,6 +28,7 @@ int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq);
 int hostapd_check_ht_capab(struct hostapd_iface *iface);
 int hostapd_prepare_rates(struct hostapd_iface *iface,
 			  struct hostapd_hw_modes *mode);
+int hostapd_get_channel_flag(struct hostapd_data *hapd, int chan);
 #else /* NEED_AP_MLME */
 static inline void
 hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
diff --git a/src/ap/ieee802_11.c b/src/ap/ieee802_11.c
index a1a7270..55245d0 100644
--- a/src/ap/ieee802_11.c
+++ b/src/ap/ieee802_11.c
@@ -159,6 +159,9 @@ u16 hostapd_own_capab_info(struct hostapd_data *hapd, struct sta_info *sta,
 	    hapd->iface->num_sta_no_short_slot_time == 0)
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 
+	if (hapd->iconf->ieee80211h)
+		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+
 	return capab;
 }
 
@@ -1850,4 +1853,117 @@ void ieee802_11_rx_from_unknown(struct hostapd_data *hapd, const u8 *src,
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
+		if (hostapd_channel_switch(hapd, next_channel->chan,
+					   next_channel->freq, radar_detected,
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
+		eloop_register_timeout(DFS_MIN_CAC_TIME_SEC, 0,
+				       hostapd_resume_dfs_cac, hapd, NULL);
+		wpa_printf(MSG_DEBUG, "listen %d seconds for radar "
+			   "interference prior enabling the tx",
+			   DFS_MIN_CAC_TIME_SEC);
+
+		if (hostapd_start_radar_detection(hapd)) {
+			wpa_printf(MSG_ERROR, "Could not start radar "
+				   "detection for kernel driver");
+		    return -1;
+		}
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
index 43042a5..16a68e1 100644
--- a/src/ap/ieee802_11.h
+++ b/src/ap/ieee802_11.h
@@ -78,5 +78,9 @@ u8 * hostapd_eid_time_adv(struct hostapd_data *hapd, u8 *eid);
 u8 * hostapd_eid_time_zone(struct hostapd_data *hapd, u8 *eid);
 int hostapd_update_time_adv(struct hostapd_data *hapd);
 void hostapd_client_poll_ok(struct hostapd_data *hapd, const u8 *addr);
+int ieee802_11_radar_detected(struct hostapd_data *hapd);
+int ieee802_11_start_channel_switch(struct hostapd_data *hapd,
+				    u8 radar_detected);
+int ieee802_11_complete_channel_switch(struct hostapd_data *hapd);
 
 #endif /* IEEE802_11_H */
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 512b4c3..1f2e521 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -34,6 +34,7 @@
 #define HOSTAPD_CHAN_HT40PLUS 0x00000010
 #define HOSTAPD_CHAN_HT40MINUS 0x00000020
 #define HOSTAPD_CHAN_HT40 0x00000040
+#define HOSTAPD_CHAN_RADAR_DETECTED 0x00000080
 
 /**
  * struct hostapd_channel_data - Channel information
@@ -58,6 +59,8 @@ struct hostapd_channel_data {
 	 * max_tx_power - maximum transmit power in dBm
 	 */
 	u8 max_tx_power;
+
+	struct os_time last_radar_detection;
 };
 
 #define HOSTAPD_MODE_FLAG_HT_INFO_KNOWN BIT(0)
@@ -964,6 +967,29 @@ struct wpa_signal_info {
 	int current_txrate;
 };
 
+/*
+ * DFS Channel Availability Check Time - the time a system shall monitor a
+ * 'radar channel' for presence of radar prior to initiating a TX.
+ */
+#define DFS_MIN_CAC_TIME_SEC		60
+
+/*
+ * DFS Non-Occupancy Time - a period of time after radar is detected on a
+ * channel that the channel may not be used.
+ *
+ */
+#define DFS_MIN_NON_OCC_TIME_SEC	1800
+
+/*
+ * DFS functionality is enabled.
+ */
+#define DFS_ENABLED			BIT(0)
+
+/*
+ * DFS channel availability check during initialization.
+ */
+#define DFS_INIT_PHASE_CAC		BIT(1)
+
 /**
  * struct wpa_driver_ops - Driver interface API definition
  *
-- 
1.7.5.4

