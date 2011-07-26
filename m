Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35890 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZXTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 19:19:32 -0400
Received: by gwaa18 with SMTP id a18so679772gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 16:19:32 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: [PATCH v5 1/4] hostapd: split up channel checking into helpers
Date: Tue, 26 Jul 2011 16:19:19 -0700
Message-Id: <1311722362-4070-2-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110727_011937_023398_690C205B)
In-Reply-To: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com>
References: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits up the channel checking upon initialization
into a few helpers. This should make this a bit easier
to follow. This also paves the way for some initial
ACS entry code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
---
 src/ap/hostapd.h     |    6 ++
 src/ap/hw_features.c |  148 +++++++++++++++++++++++++++-----------------------
 2 files changed, 86 insertions(+), 68 deletions(-)

diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index 8d12d8b..7436823 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -30,6 +30,12 @@ struct full_dynamic_vlan;
 enum wps_event;
 union wps_event_data;
 
+enum hostapd_chan_status {
+	HOSTAPD_CHAN_VALID = 0, /* channel is ready */
+	HOSTAPD_CHAN_INVALID = 1, /* no usable channel found */
+	HOSTAPD_CHAN_ACS = 2, /* ACS work being performed */
+};
+
 struct hostapd_probereq_cb {
 	int (*cb)(void *ctx, const u8 *sa, const u8 *da, const u8 *bssid,
 		  const u8 *ie, size_t ie_len);
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 86f6811..887744b 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -599,6 +599,77 @@ int hostapd_check_ht_capab(struct hostapd_iface *iface)
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
+static enum hostapd_chan_status hostapd_check_chans(struct hostapd_iface *iface)
+{
+	if (iface->conf->channel) {
+		if (hostapd_is_usable_chans(iface))
+			return HOSTAPD_CHAN_VALID;
+		else
+			return HOSTAPD_CHAN_INVALID;
+	}
+
+	/*
+	 * The user set channel=0 which is used to trigger ACS,
+	 * which we do not yet support.
+	 */
+	return HOSTAPD_CHAN_INVALID;
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
 
 /**
  * hostapd_select_hw_mode - Select the hardware mode
@@ -610,7 +681,7 @@ int hostapd_check_ht_capab(struct hostapd_iface *iface)
  */
 int hostapd_select_hw_mode(struct hostapd_iface *iface)
 {
-	int i, j, ok;
+	int i;
 
 	if (iface->num_hw_features < 1)
 		return -1;
@@ -634,75 +705,16 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
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
+	switch (hostapd_check_chans(iface)) {
+	case HOSTAPD_CHAN_VALID:
+		return 0;
+	case HOSTAPD_CHAN_ACS: /* ACS not supported yet */
+	case HOSTAPD_CHAN_INVALID:
+	default:
+		hostapd_notify_bad_chans(iface);
 		return -4;
+		return HOSTAPD_CHAN_INVALID;
 	}
-
-	return 0;
 }
 
 
-- 
1.7.4.15.g7811d

