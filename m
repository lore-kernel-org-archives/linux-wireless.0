Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35631 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLXMYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 07:24:21 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: P54usb getting WARN_ON at line 2247 of net/mac80211/rx.c
Date: Wed, 24 Dec 2008 13:24:17 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4951D1BB.1030204@lwfinger.net>
In-Reply-To: <4951D1BB.1030204@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812241324.17667.chunkeey@web.de> (sfid-20081224_132458_905304_46BA1952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 December 2008 07:07:55 Larry Finger wrote:
> My system has recently started getting the WARN_ON from routine __ieee80211_rx()
> because of a faulty rate_idx value in the following code snippet:
> 
>         } else {
>                 if (WARN_ON(status->rate_idx < 0 ||
>                             status->rate_idx >= sband->n_bitrates))
>                         return;
>                 rate = &sband->bitrates[status->rate_idx];
>         }
> 
> I thought I remembered a patch for this that was circulated, but I couldn't find
> it. This warning was logged while using p54usb. It may happen for other drivers
> as well, but I have been using only p54usb for the past few days.

Well, this happens if p54 enters 5GHz mode (straight from a noisy 2.4Ghz band).

There's always a change that p54_rx_data and p54_scan(which sets the frequency) are running on the same time.

Therefore dev->conf.channel could be already set to a 5GHz channel. 
(And as you know there're no 802.11b rates allowed, so we don't expect to receive any frames with 802.11b rates).

But if there's still some outstanding frames left, we will eventually end up here:
rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
				   hdr->rate : (hdr->rate - 4)) & 0xf;

And with a 802.11b rate (hdr->rate - 4) will underrun => WARN.

To fix this properly we have to add some sort of completion struct
to skb->cb (which isn't possible because on 
disable the radio and wait until it save to change the band.

OR add more quirks:
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-23 15:57:41.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-24 12:55:07.000000000 +0100
@@ -623,6 +623,7 @@ static int p54_rx_data(struct ieee80211_
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
+	u8 rate = hdr->rate & 0xf;
 
 	/*
 	 * If the device is in a unspecified state we have to
@@ -651,8 +652,11 @@ static int p54_rx_data(struct ieee80211_
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
---
AND/OR, look into:
	dev->channel_change_time = 1000;        /* TODO: find actual value */

regards,
	Chr
