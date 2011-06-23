Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51081 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab1FWSpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 14:45:04 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 11:44:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 2/4] hostapd: add offchannel support
Date: Thu, 23 Jun 2011 11:44:49 -0700
Message-ID: <1308854691-5958-3-git-send-email-lrodriguez@atheros.com> (sfid-20110623_204513_455915_444E321E)
In-Reply-To: <1308854691-5958-1-git-send-email-lrodriguez@atheros.com>
References: <1308854691-5958-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although unused at the moment, this will be used later by
ACS code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 src/ap/ap_drv_ops.h    |   11 ++++++++
 src/ap/drv_callbacks.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++-
 src/ap/hostapd.h       |    4 +++
 3 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index f6076af..a62e1e5 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -202,4 +202,15 @@ static inline int hostapd_drv_set_authmode(struct hostapd_data *hapd,
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
index fc4bc31..064eb65 100644
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
@@ -576,8 +633,17 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 		    data->rx_action.bssid == NULL)
 			break;
 		hostapd_rx_action(hapd, &data->rx_action);
-		break;
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
index 6e4cc4f..d8318ee 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -227,6 +227,10 @@ struct hostapd_iface {
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

