Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:63142 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXDUEIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 00:08:10 -0400
Date: Fri, 20 Apr 2007 23:07:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] ieee80211: Output frequency rather than channel in scan  results
Message-ID: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ieee80211, the output of scan results lists channels rather than
frequencies; however, NetworkManager needs frequency. This patch
changes the output from channel to frequency.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/ieee80211_wx.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_wx.c
+++ wireless-2.6/net/ieee80211/ieee80211_wx.c
@@ -89,12 +89,15 @@ static char *ieee80211_translate_scan(st
 		start = iwe_stream_add_event(start, stop, &iwe, IW_EV_UINT_LEN);
 	}
 
-	/* Add frequency/channel */
+	/* Add frequency */
 	iwe.cmd = SIOCGIWFREQ;
-/*	iwe.u.freq.m = ieee80211_frequency(network->channel, network->mode);
-	iwe.u.freq.e = 3; */
-	iwe.u.freq.m = network->channel;
-	iwe.u.freq.e = 0;
+	if (network->channel < 15)
+		iwe.u.freq.m = 2407 + 5 * network->channel;
+	else
+		iwe.u.freq.m = 5000 + 5 * network->channel;
+	if (network->channel == 14)
+		iwe.u.freq.m = 2484;    /* special case for Japan */
+	iwe.u.freq.e = 6;
 	iwe.u.freq.i = 0;
 	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_FREQ_LEN);
 
