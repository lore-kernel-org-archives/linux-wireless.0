Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57465 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622Ab2FROxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:53:07 -0400
Received: by ggnk3 with SMTP id k3so3276545ggn.10
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:53:06 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 3/7] hostapd: add dfs events
Date: Mon, 18 Jun 2012 17:49:42 +0300
Message-Id: <1340030986-29118-4-git-send-email-victorg@ti.com> (sfid-20120618_165330_443268_B3A04E65)
In-Reply-To: <1340030986-29118-1-git-send-email-victorg@ti.com>
References: <1340030986-29118-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add EVENT_RADAR_DETECTED and EVENT_CHANNEL_SWITCH_COMPLETE
events.

EVENT_RADAR_DETECTED indicates that radar was detected on
operational channel. EVENT_CHANNEL_SWITCH_COMPLETE indicates
that device has finished the channel switch process.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/drv_callbacks.c      |   47 +++++++++++++++++++++++++++++++++++++++++++
 src/drivers/driver.h        |   22 +++++++++++++++++++-
 src/drivers/driver_common.c |    2 +
 3 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index 4c0d0ab..603820f 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -469,6 +469,37 @@ static void hostapd_event_eapol_rx(struct hostapd_data *hapd, const u8 *src,
 	ieee802_1x_receive(hapd, src, data, data_len);
 }
 
+static void hostapd_event_radar_detected(struct hostapd_data *hapd,
+		struct radar_detected *radar)
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
+static void hostapd_event_complete_channel_switch(struct hostapd_data *hapd,
+		struct channel_switch_complete *channel_switch)
+{
+	if (hapd->next_channel->freq != channel_switch->freq) {
+		wpa_printf(MSG_WARNING, "Switched to wrong freq, next_freq(%d) "
+			   "!= ch_switch_freq(%d)", hapd->next_channel->freq,
+			   channel_switch->freq);
+	}
+
+	if (channel_switch->status)
+		ieee802_11_complete_channel_switch(hapd);
+}
 
 void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			  union wpa_event_data *data)
@@ -492,6 +523,13 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
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
@@ -582,6 +620,15 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			break;
 		hostapd_event_sta_low_ack(hapd, data->low_ack.addr);
 		break;
+	case EVENT_RADAR_DETECTED:
+		if (data)
+			hostapd_event_radar_detected(hapd, &data->radar_detected);
+		break;
+	case EVENT_CHANNEL_SWITCH_COMPLETE:
+		if (data)
+			hostapd_event_complete_channel_switch(hapd,
+				&data->channel_switch_complete);
+		break;
 #ifdef NEED_AP_MLME
 	case EVENT_RX_ACTION:
 		if (data->rx_action.da == NULL || data->rx_action.sa == NULL ||
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 780fac8..44f6af0 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -3042,7 +3042,17 @@ enum wpa_event_type {
 	/**
 	 * EVENT_EAPOL_TX_STATUS - notify of EAPOL TX status
 	 */
-	EVENT_EAPOL_TX_STATUS
+	EVENT_EAPOL_TX_STATUS,
+
+	/**
+	 * EVENT_RADAR_DETECTED - notify of radar detection
+	 */
+	EVENT_RADAR_DETECTED,
+
+	/**
+	 * EVENT_CHANNEL_SWITCH_COMPLETE - notify of channel switch complete
+	 */
+	EVENT_CHANNEL_SWITCH_COMPLETE
 };
 
 
@@ -3637,6 +3647,16 @@ union wpa_event_data {
 		int data_len;
 		int ack;
 	} eapol_tx_status;
+
+	struct radar_detected {
+		int status;
+		int freq;
+	} radar_detected;
+
+	struct channel_switch_complete {
+		int status;
+		int freq;
+	} channel_switch_complete;
 };
 
 /**
diff --git a/src/drivers/driver_common.c b/src/drivers/driver_common.c
index 345e851..321b057 100644
--- a/src/drivers/driver_common.c
+++ b/src/drivers/driver_common.c
@@ -77,6 +77,8 @@ const char * event_to_string(enum wpa_event_type event)
 	E2S(SCHED_SCAN_STOPPED);
 	E2S(DRIVER_CLIENT_POLL_OK);
 	E2S(EAPOL_TX_STATUS);
+	E2S(RADAR_DETECTED);
+	E2S(CHANNEL_SWITCH_COMPLETE);
 	}
 
 	return "UNKNOWN";
-- 
1.7.5.4

