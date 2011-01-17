Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:59715 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1AQQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:04 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:14:21 +0100
Subject: [PATCH 5/8] hostap: pull in additional chan flags
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.91E792095@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/ap/drv_callbacks.c       |    4 +++
 src/ap/hostapd.c             |    5 ++++
 src/ap/hostapd.h             |    2 +
 src/ap/hw_features.c         |   44 +++++++++++++++++++++++++++++++++++++++++-
 src/ap/hw_features.h         |   14 +++++++++++++
 src/drivers/driver.h         |   22 ++++++++++++++++++++-
 src/drivers/driver_nl80211.c |   31 +++++++++++++++++++++++++++++
 7 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index a49248f..c55c42a 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -521,6 +521,10 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			break;
 		hostapd_event_sta_low_ack(hapd, data->low_ack.addr);
 		break;
+	case EVENT_RADAR_FLAGS_CHANGED:
+		hostapd_radar_flags_changed(hapd, data->radar.freq,
+					    data->radar.flags);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "Unknown event %d", event);
 		break;
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index 16d7c45..592a01f 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -916,3 +916,8 @@ void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 	} else
 		wpa_auth_sta_associated(hapd->wpa_auth, sta->wpa_sm);
 }
+
+void hostapd_radar_flags_changed(struct hostapd_data *hapd, int freq, u32 flags)
+{
+	hostapd_hw_set_radar_flags(hapd, freq, flags);
+}
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index 0346408..e2e4234 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -235,6 +235,8 @@ void hostapd_interface_deinit(struct hostapd_iface *iface);
 void hostapd_interface_free(struct hostapd_iface *iface);
 void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 			   int reassoc);
+void hostapd_radar_flags_changed(struct hostapd_data *hapd, int freq,
+				 u32 flags);
 
 /* utils.c */
 int hostapd_register_probereq_cb(struct hostapd_data *hapd,
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 743d567..04bf210 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -66,7 +66,8 @@ int hostapd_select_random_channel(struct hostapd_iface *iface)
 			for (i = 0; i < hw_chans_num; i++) {
 				hchan = &iface->current_mode->channels[i];
 				if (hchan->chan == chans[buf] &&
-				    !(hchan->flag & HOSTAPD_CHAN_DISABLED)) {
+				    !(hchan->flag & HOSTAPD_CHAN_DISABLED) &&
+				    !(hchan->flag & HOSTAPD_CHAN_RADAR_INTERFERENCE)) {
 					iface->conf->channel = hchan->chan;
 					ret = 0;
 					break;
@@ -801,3 +802,44 @@ int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq)
 
 	return 0;
 }
+
+u32 hostapd_hw_get_radar_flags(struct hostapd_data *hapd, int chan)
+{
+	int i;
+
+	if (!hapd->iface->current_mode)
+		return 0;
+
+	for (i = 0; i < hapd->iface->current_mode->num_channels; i++) {
+		struct hostapd_channel_data *ch =
+			&hapd->iface->current_mode->channels[i];
+		if (ch->chan == chan) {
+			return (ch->flag & (HOSTAPD_CHAN_RADAR |
+					    HOSTAPD_CHAN_RADAR_CLEAR |
+					    HOSTAPD_CHAN_RADAR_INTERFERENCE));
+		}
+	}
+
+	return 0;
+}
+
+int hostapd_hw_set_radar_flags(struct hostapd_data *hapd, int freq, u32 flags)
+{
+	int i;
+
+	if (!hapd->iface->current_mode)
+		return 0;
+
+	for (i = 0; i < hapd->iface->current_mode->num_channels; i++) {
+		struct hostapd_channel_data *ch =
+			&hapd->iface->current_mode->channels[i];
+		if (ch->freq == freq) {
+			ch->flag &= ~(HOSTAPD_CHAN_RADAR_CLEAR |
+				      HOSTAPD_CHAN_RADAR_INTERFERENCE);
+			ch->flag |= flags;
+			break;
+		}
+	}
+
+	return 0;
+}
diff --git a/src/ap/hw_features.h b/src/ap/hw_features.h
index f800562..466b16b 100644
--- a/src/ap/hw_features.h
+++ b/src/ap/hw_features.h
@@ -25,6 +25,8 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface);
 const char * hostapd_hw_mode_txt(int mode);
 int hostapd_hw_get_freq(struct hostapd_data *hapd, int chan);
 int hostapd_hw_get_channel(struct hostapd_data *hapd, int freq);
+u32 hostapd_hw_get_radar_flags(struct hostapd_data *hapd, int chan);
+int hostapd_hw_set_radar_flags(struct hostapd_data *hapd, int freq, u32 flags);
 int hostapd_check_ht_capab(struct hostapd_iface *iface);
 int hostapd_prepare_rates(struct hostapd_data *hapd,
 			  struct hostapd_hw_modes *mode);
@@ -55,6 +57,18 @@ static inline int hostapd_hw_get_freq(struct hostapd_data *hapd, int chan)
 	return -1;
 }
 
+static inline u32 hostapd_hw_get_radar_flags(struct hostapd_data *hapd,
+					     int chan)
+{
+	return 0;
+}
+
+static inline int hostapd_hw_set_radar_flags(struct hostapd_data *hapd,
+					     int freq, u32 flags)
+{
+	return 0;
+}
+
 static inline int hostapd_check_ht_capab(struct hostapd_iface *iface)
 {
 	return 0;
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index b8684fa..777f854 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -34,6 +34,8 @@
 #define HOSTAPD_CHAN_HT40PLUS 0x00000010
 #define HOSTAPD_CHAN_HT40MINUS 0x00000020
 #define HOSTAPD_CHAN_HT40 0x00000040
+#define HOSTAPD_CHAN_RADAR_CLEAR 0x00000080
+#define HOSTAPD_CHAN_RADAR_INTERFERENCE 0x00000100
 
 /**
  * struct hostapd_channel_data - Channel information
@@ -2577,7 +2579,9 @@ enum wpa_event_type {
 	EVENT_P2P_PROV_DISC_REQUEST,
 	EVENT_P2P_PROV_DISC_RESPONSE,
 	EVENT_P2P_SD_REQUEST,
-	EVENT_P2P_SD_RESPONSE
+	EVENT_P2P_SD_RESPONSE,
+
+	EVENT_RADAR_FLAGS_CHANGED,
 };
 
 
@@ -3091,6 +3095,22 @@ union wpa_event_data {
 		const u8 *tlvs;
 		size_t tlvs_len;
 	} p2p_sd_resp;
+
+	/**
+	 * struct radar_flags - Data for radar related flag changes
+	 */
+	struct radar_flags {
+		/**
+		 * freq - Frequency (in MHz) of the channel which needs a
+		 *	flag update.
+		 */
+		int freq;
+
+		/**
+		 * flags - New HOSTAPD_CHAN_RADAR_* flags
+		 */
+		u32 flags;
+	} radar;
 };
 
 /**
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index acb8f33..d919a73 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -1288,6 +1288,26 @@ static void nl80211_new_station_event(struct wpa_driver_nl80211_data *drv,
 	wpa_supplicant_event(drv->ctx, EVENT_IBSS_RSN_START, &data);
 }
 
+static void nl80211_radar_event(struct wpa_driver_nl80211_data *drv, u32 cmd,
+				struct nlattr **tb)
+{
+	union wpa_event_data data;
+
+	switch (cmd) {
+	case NL80211_CMD_RADAR_FLAGS_CHANGED:
+		if (!tb[NL80211_FREQUENCY_ATTR_FREQ])
+			return;
+		data.radar.flags = 0;
+		data.radar.freq = nla_get_u32(tb[NL80211_FREQUENCY_ATTR_FREQ]);
+		if (tb[NL80211_FREQUENCY_ATTR_RADAR_CLEAR])
+			data.radar.flags |= HOSTAPD_CHAN_RADAR_CLEAR;
+		if (tb[NL80211_FREQUENCY_ATTR_RADAR_INTEFERENCE])
+			data.radar.flags |= HOSTAPD_CHAN_RADAR_INTERFERENCE;
+		wpa_supplicant_event(drv->ctx, EVENT_RADAR_FLAGS_CHANGED,
+				     &data);
+		break;
+	}
+}
 
 static int process_event(struct nl_msg *msg, void *arg)
 {
@@ -1404,6 +1424,9 @@ static int process_event(struct nl_msg *msg, void *arg)
 	case NL80211_CMD_NEW_STATION:
 		nl80211_new_station_event(drv, tb);
 		break;
+	case NL80211_CMD_RADAR_FLAGS_CHANGED:
+		nl80211_radar_event(drv, gnlh->cmd, tb);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", gnlh->cmd);
@@ -3059,6 +3082,8 @@ static int phy_info_handler(struct nl_msg *msg, void *arg)
 		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_RADAR] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] = { .type = NLA_U32 },
+		[NL80211_FREQUENCY_ATTR_RADAR_CLEAR] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_RADAR_INTEFERENCE] = { .type = NLA_FLAG },
 	};
 
 	struct nlattr *tb_rate[NL80211_BITRATE_ATTR_MAX + 1];
@@ -3172,6 +3197,12 @@ static int phy_info_handler(struct nl_msg *msg, void *arg)
 			if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
 				mode->channels[idx].flag |=
 					HOSTAPD_CHAN_RADAR;
+			if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR_CLEAR])
+				mode->channels[idx].flag |=
+					HOSTAPD_CHAN_RADAR_CLEAR;
+			if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR_INTEFERENCE])
+				mode->channels[idx].flag |=
+					HOSTAPD_CHAN_RADAR_INTERFERENCE;
 
 			if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] &&
 			    !tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
-- 
1.5.6.5

