Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32955 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZXTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 19:19:35 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so1632346pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 16:19:35 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: [PATCH v5 2/4] hostapd: add offchannel support
Date: Tue, 26 Jul 2011 16:19:20 -0700
Message-Id: <1311722362-4070-3-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110727_011937_565359_25D254F8)
In-Reply-To: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com>
References: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although unused at the moment, this will be used later by
ACS code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
---
 src/ap/ap_drv_ops.h    |   11 ++++++++
 src/ap/drv_callbacks.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/hostapd.h       |    4 +++
 3 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index 6f947f9..660a36b 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -203,4 +203,15 @@ static inline int hostapd_drv_set_authmode(struct hostapd_data *hapd,
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
 #endif /* AP_DRV_OPS */
diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index db2d5f2..fb3e0dd 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -487,6 +487,63 @@ static void hostapd_event_eapol_rx(struct hostapd_data *hapd, const u8 *src,
 	ieee802_1x_receive(hapd, src, data, data_len);
 }
 
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
+		wpa_printf(MSG_ERROR, "channel requested to go offchannel "
+			   "on freq %d MHz disappeared",
+			   chan->freq);
+		goto fail;
+	}
+
+	if (chan->flag & HOSTAPD_CHAN_DISABLED) {
+		wpa_printf(MSG_ERROR, "channel requested to go offchannel "
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
+	/* XXX: pass err to listeners, no one yet */
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
+	/* XXX: pass err to listeners, no one yet */
+}
 
 void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			  union wpa_event_data *data)
@@ -580,6 +637,16 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 		hostapd_rx_action(hapd, &data->rx_action);
 		break;
 #endif /* NEED_AP_MLME */
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
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index 7436823..dedd2ce 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -228,6 +228,10 @@ struct hostapd_iface {
 	int olbc_ht;
 
 	u16 ht_op_mode;
+
+	/* Offchannel operation helper */
+	unsigned int off_channel_freq_idx;
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
-- 
1.7.4.15.g7811d

