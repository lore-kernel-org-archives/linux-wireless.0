Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:27286 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1AQQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:05 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:00:17 +0100
Subject: [PATCH 3/8] hostapd: select random channel of the list
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.819592091@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/ap/hw_features.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/hw_features.h |    1 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 133ed74..743d567 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -27,6 +27,58 @@
 #include "hw_features.h"
 
 
+int hostapd_select_random_channel(struct hostapd_iface *iface)
+{
+	int i, j, ret;
+
+	if (iface->conf->channel_list == NULL ||
+	    iface->conf->channel_list[0] == -1)
+		return -1;
+
+	ret = -1;
+	if (iface->conf->channel == 0 && iface->conf->channel_list != NULL) {
+		int *chans, chans_num = 1, hw_chans_num;
+		u8 buf;
+
+		for (i = 0; iface->conf->channel_list[i] > 0; i++)
+			chans_num++;
+
+		chans = os_malloc(sizeof(int) * chans_num);
+		if (chans == NULL)
+			return -1;
+		os_memcpy(chans, iface->conf->channel_list,
+			  sizeof(int) * chans_num);
+
+		hw_chans_num = iface->current_mode->num_channels;
+		buf = chans_num;
+		do {
+			struct hostapd_channel_data *hchan = NULL;
+
+			for (i = j = 0; i < chans_num; i++, j++) {
+				if (i == buf)
+					j++;
+				chans[i] = chans[j];
+			}
+
+			os_get_random(&buf, 1);
+			buf %= chans_num;
+
+			for (i = 0; i < hw_chans_num; i++) {
+				hchan = &iface->current_mode->channels[i];
+				if (hchan->chan == chans[buf] &&
+				    !(hchan->flag & HOSTAPD_CHAN_DISABLED)) {
+					iface->conf->channel = hchan->chan;
+					ret = 0;
+					break;
+				}
+			}
+			chans_num--;
+		} while (iface->conf->channel == 0 && chans_num > 0);
+		os_free(chans);
+	}
+	return ret;
+}
+
 void hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
 			      size_t num_hw_features)
 {
@@ -642,6 +694,8 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
 			break;
 		}
 	}
+	if (iface->conf->channel == 0 && !hostapd_select_random_channel(iface))
+		ok = 1;
 	if (ok && iface->conf->secondary_channel) {
 		int sec_ok = 0;
 		int sec_chan = iface->conf->channel +
diff --git a/src/ap/hw_features.h b/src/ap/hw_features.h
index 88c2322..f800562 100644
--- a/src/ap/hw_features.h
+++ b/src/ap/hw_features.h
@@ -17,6 +17,7 @@
 #define HW_FEATURES_H
 
 #ifdef NEED_AP_MLME
+int hostapd_select_random_channel(struct hostapd_iface *iface);
 void hostapd_free_hw_features(struct hostapd_hw_modes *hw_features,
 			      size_t num_hw_features);
 int hostapd_get_hw_features(struct hostapd_iface *iface);
-- 
1.5.6.5

