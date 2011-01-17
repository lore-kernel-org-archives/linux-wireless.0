Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:35777 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab1AQQVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:21:33 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:26:20 +0100
Subject: [PATCH 7/8] hostap: handle interference on current channel
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.A049E2099@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/ap/hostapd.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index a065fc9..1024d73 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -993,6 +993,34 @@ void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 		wpa_auth_sta_associated(hapd->wpa_auth, sta->wpa_sm);
 }
 
+static void hostapd_radar_flags_cb(struct hostapd_data *hapd)
+{
+	struct hostapd_iface *iface = hapd->iface;
+	u32 flags;
+
+	iface->radar_cac_cb = NULL;
+	iface->radar_flags_cb = NULL;
+	flags = hostapd_hw_get_radar_flags(hapd, iface->conf->channel);
+	if ((flags & HOSTAPD_CHAN_RADAR_CLEAR)) {
+		hostapd_reload_bss(hapd);
+	} else if ((flags & HOSTAPD_CHAN_RADAR_INTERFERENCE)) {
+		int chan = iface->conf->channel;
+		u32 newflags;
+		iface->conf->channel = 0;
+		if (hostapd_select_random_channel(iface))
+			iface->conf->channel = chan;
+		newflags = hostapd_hw_get_radar_flags(hapd,
+						      iface->conf->channel);
+		if ((newflags & HOSTAPD_CHAN_RADAR_INTERFERENCE))
+			iface->radar_flags_cb = hostapd_radar_flags_cb;
+		else
+			hostapd_radar_flags_cb(hapd);
+	} else {
+		hostapd_channel_availability_check(hapd);
+		iface->radar_cac_cb = hostapd_radar_flags_cb;
+	}
+}
+
 void hostapd_radar_flags_changed(struct hostapd_data *hapd, int freq, u32 flags)
 {
 	struct hostapd_iface *iface = hapd->iface;
@@ -1003,4 +1031,8 @@ void hostapd_radar_flags_changed(struct hostapd_data *hapd, int freq, u32 flags)
 		iface->radar_flags_cb(hapd);
 		return;
 	}
+	if (iface->radar_cac_cb || iface->freq != freq)
+		return;
+	else if ((flags & HOSTAPD_CHAN_RADAR_INTERFERENCE))
+		hostapd_radar_flags_cb(hapd);
 }
-- 
1.5.6.5

