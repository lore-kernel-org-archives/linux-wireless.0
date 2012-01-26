Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55554 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab2AZMme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:34 -0500
Received: by ggnp1 with SMTP id p1so200819ggn.23
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:42:33 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>
Subject: [RFC 3/7] hostapd: add dfs events
Date: Thu, 26 Jan 2012 14:41:25 +0200
Message-Id: <1327581689-22090-4-git-send-email-victorg@ti.com> (sfid-20120126_134237_064991_63A77977)
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add EVENT_RADAR_DETECTED and EVENT_CHANNEL_SWITCH_COMPLETE
events.

EVENT_RADAR_DETECTED indicates that radar was detected on
operational channel. EVENT_CHANNEL_SWITCH_COMPLETE indicates
that device has finished the channel switch process.

Signed-off-by: Boris Presman <boris.presman@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/drv_callbacks.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 src/drivers/driver.h        |   22 +++++++++++++++++++++-
 src/drivers/driver_common.c |    2 ++
 3 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index b7febdc..d5079c4 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -464,6 +464,37 @@ static void hostapd_event_eapol_rx(struct hostapd_data *hapd, const u8 *src,
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
@@ -576,6 +607,15 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
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
index 1f2e521..68bf2e7 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -2973,7 +2973,17 @@ enum wpa_event_type {
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
 
 
@@ -3563,6 +3573,16 @@ union wpa_event_data {
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
index 26ca8d6..8e0492a 100644
--- a/src/drivers/driver_common.c
+++ b/src/drivers/driver_common.c
@@ -83,6 +83,8 @@ const char * event_to_string(enum wpa_event_type event)
 	E2S(SCHED_SCAN_STOPPED);
 	E2S(DRIVER_CLIENT_POLL_OK);
 	E2S(EAPOL_TX_STATUS);
+	E2S(RADAR_DETECTED);
+	E2S(CHANNEL_SWITCH_COMPLETE);
 	}
 
 	return "UNKNOWN";
-- 
1.7.5.4

