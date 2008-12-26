Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44100 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYLZSJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 13:09:48 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] p54: fix WARN_ON at line 2247 of net/mac80211/rx.c
Date: Fri, 26 Dec 2008 19:09:45 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812261909.46094.chunkeey@web.de> (sfid-20081226_190950_890561_092ABECE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch hopefully fixes a mac80211<->p54 interaction problem, which was
described by Larry Finger (ref: http://marc.info/?l=linux-wireless&m=123009889327707 )

I guess the warning was triggered by pending frames in the receive queue,
while we're doing a band change 5GHz.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Larry,

Are you still hammering your p54usb, or have you finished testing p54(usb)'s stability?
Because I'm waiting for your confirmation for this one. hohohoho.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-26 17:33:58.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-26 17:54:47.000000000 +0100
@@ -576,6 +576,7 @@ static int p54_rx_data(struct ieee80211_
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
+	u8 rate = hdr->rate & 0xf;
 
 	/*
 	 * If the device is in a unspecified state we have to
@@ -604,8 +605,11 @@ static int p54_rx_data(struct ieee80211_
 	rx_status.qual = (100 * hdr->rssi) / 127;
 	if (hdr->rate & 0x10)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
-	rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
-			hdr->rate : (hdr->rate - 4)) & 0xf;
+	if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
+		rx_status.rate_idx = (rate < 4) ? 0 : rate - 4;
+	else
+		rx_status.rate_idx = rate;
+
 	rx_status.freq = freq;
 	rx_status.band =  dev->conf.channel->band;
 	rx_status.antenna = hdr->antenna;

