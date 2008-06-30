Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYF3Pi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 11:38:29 -0400
Date: Mon, 30 Jun 2008 10:39:49 -0500
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com, flamingice@sourmilk.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Add quality output to iwlist and iwconfig
Message-ID: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net> (sfid-20080630_173834_531803_0FC8E191)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The p54 driver family reports a quality of 0 in iwconfig and iwlist
output. This patch calculates a quality number as a percentage of the
rssi to the maximum signal of 127 reported as the maximum signal.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -357,6 +357,7 @@ static void p54_rx_data(struct ieee80211
 
 	rx_status.signal = hdr->rssi;
 	/* XX correct? */
+	rx_status.qual = (100 * hdr->rssi) / 127;
 	rx_status.rate_idx = hdr->rate & 0xf;
 	rx_status.freq = freq;
 	rx_status.band = IEEE80211_BAND_2GHZ;
