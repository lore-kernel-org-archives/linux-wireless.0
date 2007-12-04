Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:45316 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbXLDDr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 22:47:29 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8180: fix rx rate reporting
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Mon, 03 Dec 2007 22:55:08 -0500
Message-ID: <20071204035508.23132.91760.stgit@tetra.sourmilk.net> (sfid-20071204_034731_766425_E27636EE)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate reported in rx_status needs to be the hw value, not actual rate.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index db70604..52550c1 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -83,7 +83,6 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			u32 flags2 = le32_to_cpu(entry->flags2);
 			struct ieee80211_rx_status rx_status = {0};
 			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
-			int rate;
 
 			if (unlikely(!new_skb))
 				goto done;
@@ -93,12 +92,11 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
 			skb_put(skb, flags & 0xFFF);
 
-			rate = (flags >> 20) & 0xF;
 			rx_status.antenna = (flags2 >> 15) & 1;
 			/* TODO: improve signal/rssi reporting */
 			rx_status.signal = flags2 & 0xFF;
 			rx_status.ssi = (flags2 >> 8) & 0x7F;
-			rx_status.rate = priv->rates[rate].rate;
+			rx_status.rate = (flags >> 20) & 0xF;
 			rx_status.freq = dev->conf.freq;
 			rx_status.channel = dev->conf.channel;
 			rx_status.phymode = dev->conf.phymode;


