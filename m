Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:62667 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbXGJUvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 16:51:51 -0400
Date: Tue, 10 Jul 2007 15:51:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] softmac: Channel is listed twice in scan output
Message-ID: <4693f142.QzS2GPHUbRZ7qOrh%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>

SoftMAC outputs the channel twice in the scan output. It should
display frequency and channel, but only once for each.

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 ieee80211_wx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


Index: linux-2.6/net/ieee80211/ieee80211_wx.c
===================================================================
--- linux-2.6.orig/net/ieee80211/ieee80211_wx.c
+++ linux-2.6/net/ieee80211/ieee80211_wx.c
@@ -90,14 +90,11 @@ static char *ieee80211_translate_scan(st
 	}
 
 	/* Add channel and frequency */
+	/* Note : userspace automatically computes channel using iwrange */
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = network->channel;
-	iwe.u.freq.e = 0;
-	iwe.u.freq.i = 0;
-	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_FREQ_LEN);
-
 	iwe.u.freq.m = ieee80211_channel_to_freq(ieee, network->channel);
 	iwe.u.freq.e = 6;
+	iwe.u.freq.i = 0;
 	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_FREQ_LEN);
 
 	/* Add encryption capability */
