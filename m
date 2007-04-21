Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:52771 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXDUUcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 16:32:02 -0400
Date: Sat, 21 Apr 2007 15:31:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-wireless@vger.kernel.org
Message-ID: <462a74bf.q78F6+5laAQtwRWs%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ieee80211, the output of scan results lists channels, but not
frequencies, which are needed by NetworkManager. This patch uses
the new ieee80211_channel_to_freq routine to add the frequency to the output.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/ieee80211_wx.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_wx.c
+++ wireless-2.6/net/ieee80211/ieee80211_wx.c
@@ -89,15 +89,17 @@ static char *ieee80211_translate_scan(st
 		start = iwe_stream_add_event(start, stop, &iwe, IW_EV_UINT_LEN);
 	}
 
-	/* Add frequency/channel */
+	/* Add channel and frequency */
 	iwe.cmd = SIOCGIWFREQ;
-/*	iwe.u.freq.m = ieee80211_frequency(network->channel, network->mode);
-	iwe.u.freq.e = 3; */
 	iwe.u.freq.m = network->channel;
 	iwe.u.freq.e = 0;
 	iwe.u.freq.i = 0;
 	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_FREQ_LEN);
 
+	iwe.u.freq.m = ieee80211_channel_to_freq(ieee, network->channel);
+	iwe.u.freq.e = 6;
+	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_FREQ_LEN);
+
 	/* Add encryption capability */
 	iwe.cmd = SIOCGIWENCODE;
 	if (network->capability & WLAN_CAPABILITY_PRIVACY)
