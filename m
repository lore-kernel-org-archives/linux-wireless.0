Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47274 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZDKB6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 21:58:15 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: remove obsolet signal quality calculation
Date: Sat, 11 Apr 2009 03:58:14 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904110358.15052.chunkeey@web.de> (sfid-20090411_035817_802078_7F67F777)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The signal quality percentage is now calculated by mac80211 stack.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index d57e0ca..c9d564c 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -958,8 +958,6 @@ static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
 	rx_status.noise = priv->noise;
-	/* XX correct? */
-	rx_status.qual = (100 * hdr->rssi) / 127;
 	if (hdr->rate & 0x10)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 	if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
