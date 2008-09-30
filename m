Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56024 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYI3VcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 17:32:10 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: report appropriate rate and band values for 802.11a
Date: Tue, 30 Sep 2008 23:36:00 +0200
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809302336.00992.chunkeey@web.de> (sfid-20080930_233215_197595_E4470677)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the a few lines that went missing in
"p54: 802.11a 5GHz phy support"
commit: cce69c09b98c3bcb95b55fad3f84ccceaf245316

Essentially: the rx-code wasn't updated and therefore reported the wrong band,
but more importantly the rate index was off as well, since 802.11a doesn't
allow the "four" 802.11b rates...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index de5e8f4..1994aa1 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -507,9 +507,10 @@ static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	rx_status.noise = priv->noise;
 	/* XX correct? */
 	rx_status.qual = (100 * hdr->rssi) / 127;
-	rx_status.rate_idx = hdr->rate & 0xf;
+	rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
+			hdr->rate : (hdr->rate - 4)) & 0xf;
 	rx_status.freq = freq;
-	rx_status.band = IEEE80211_BAND_2GHZ;
+	rx_status.band =  dev->conf.channel->band;
 	rx_status.antenna = hdr->antenna;
 
 	tsf32 = le32_to_cpu(hdr->tsf32);

