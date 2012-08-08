Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:58651 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997Ab2HHMCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:23 -0400
Received: by obqv19 with SMTP id v19so2480071obq.16
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:19 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 3/7] hostapd: add dfs events
Date: Wed,  8 Aug 2012 14:55:34 +0300
Message-Id: <1344426938-1883-4-git-send-email-victorg@ti.com> (sfid-20120808_140225_898026_93C2EA27)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add EVENT_RADAR_DETECTED and EVENT_AP_CH_SWITCH_COMPLETE
events.

EVENT_RADAR_DETECTED indicates that radar was detected on
operational channel. EVENT_AP_CH_SWITCH_COMPLETE indicates
that device has finished the channel switch process.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/drv_callbacks.c      |   45 +++++++++++++++++++++++++++++++++++++++++++
 src/drivers/driver.h        |   20 ++++++++++++++++++-
 src/drivers/driver_common.c |    2 +
 3 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index c793c6a..d7148b0 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -684,6 +684,34 @@ static void hostapd_event_eapol_rx(struct hostapd_data *hapd, const u8 *src,
 	ieee802_1x_receive(hapd, src, data, data_len);
 }
 
+static void hostapd_event_radar_detected(struct hostapd_data *hapd,
+					 struct radar_detected *radar)
+{
+	if (!hapd->iconf->ieee80211h)
+		return;
+
+	if ((!(hapd->iface->dfs_state & DFS_INIT_PHASE_CAC)) &&
+	    (hapd->iface->freq != radar->freq)) {
+		wpa_printf(MSG_WARNING, "False radar detection, op_freq(%d) != "
+			   "radar_freq(%d)", hapd->iface->freq, radar->freq);
+		return;
+	}
+
+	if (ieee802_11_radar_detected(hapd))
+		ieee802_11_start_channel_switch(hapd, TRUE);
+	else
+		wpa_printf(MSG_DEBUG, "False radar detection");
+}
+
+static void hostapd_event_ap_ch_switch(struct hostapd_data *hapd, int freq)
+{
+	if (hapd->next_channel->freq != freq)
+		wpa_printf(MSG_WARNING, "Switched to wrong freq, next_freq(%d) "
+			   "!= ch_switch_freq(%d)", hapd->next_channel->freq,
+			   freq);
+
+	ieee802_11_complete_channel_switch(hapd);
+}
 
 void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			  union wpa_event_data *data)
@@ -707,6 +735,13 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 		event_to_string(event), event);
 #endif /* CONFIG_NO_STDOUT_DEBUG */
 
+	if ((hapd->iface->dfs_state & DFS_INIT_PHASE_CAC) &&
+	    (event != EVENT_RADAR_DETECTED)) {
+		wpa_dbg(hapd->msg_ctx, level, "Irrelevant event "
+			"during DFS init phase");
+		return;
+	}
+
 	switch (event) {
 	case EVENT_MICHAEL_MIC_FAILURE:
 		michael_mic_failure(hapd, data->michael_mic_failure.src, 1);
@@ -816,6 +851,16 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 					data->ch_switch.ht_enabled,
 					data->ch_switch.ch_offset);
 		break;
+	case EVENT_AP_CH_SWITCH_COMPLETE:
+		if (!data)
+			break;
+		hostapd_event_ap_ch_switch(hapd, data->ch_switch.freq);
+		break;
+	case EVENT_RADAR_DETECTED:
+		if (!data)
+			break;
+		hostapd_event_radar_detected(hapd, &data->radar_detected);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "Unknown event %d", event);
 		break;
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 047a5aa..5b031a8 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -3111,7 +3111,17 @@ enum wpa_event_type {
 	 *
 	 * This event can be used to request a WNM operation to be performed.
 	 */
-	EVENT_WNM
+	EVENT_WNM,
+
+	/**
+	 * EVENT_AP_CH_SWITCH_COMPLETE - notify of channel switch complete
+	 */
+	EVENT_AP_CH_SWITCH_COMPLETE,
+
+	/**
+	 * EVENT_RADAR_DETECTED - notify of radar detection
+	 */
+	EVENT_RADAR_DETECTED
 };
 
 
@@ -3736,6 +3746,14 @@ union wpa_event_data {
 		int ht_enabled;
 		int ch_offset;
 	} ch_switch;
+
+	/**
+	 * struct radar_detected
+	 * @freq: Frequency of new channel in MHz
+	 */
+	struct radar_detected {
+		int freq;
+	} radar_detected;
 };
 
 /**
diff --git a/src/drivers/driver_common.c b/src/drivers/driver_common.c
index 418cf1a..2232ade 100644
--- a/src/drivers/driver_common.c
+++ b/src/drivers/driver_common.c
@@ -79,6 +79,8 @@ const char * event_to_string(enum wpa_event_type event)
 	E2S(EAPOL_TX_STATUS);
 	E2S(CH_SWITCH);
 	E2S(WNM);
+	E2S(AP_CH_SWITCH_COMPLETE);
+	E2S(RADAR_DETECTED);
 	}
 
 	return "UNKNOWN";
-- 
1.7.5.4

