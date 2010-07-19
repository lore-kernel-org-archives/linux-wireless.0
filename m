Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57698 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966763Ab0GSVAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 17:00:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Pauli Nieminen <suokkos@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
Date: Mon, 19 Jul 2010 16:47:23 -0400
Message-Id: <1279572443-14361-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The existing code seemed to be somewhat based on the datasheet, but
varied substantially from the vendor-provided driver.  This mirrors the
handling of the rtl8185 case from that driver, but still neglects the
specifics for the rtl8180 hardware.  Those details are a bit muddled...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 4270502..90046dc 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -103,6 +103,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	unsigned int count = 32;
+	u8 signal;
 
 	while (count--) {
 		struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
@@ -130,10 +131,14 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			skb_put(skb, flags & 0xFFF);
 
 			rx_status.antenna = (flags2 >> 15) & 1;
-			/* TODO: improve signal/rssi reporting */
-			rx_status.signal = (flags2 >> 8) & 0x7F;
-			/* XXX: is this correct? */
 			rx_status.rate_idx = (flags >> 20) & 0xF;
+			/* TODO: improve signal/rssi reporting for !rtl8185 */
+			signal = (flags2 >> 17) & 0x7F;
+			if (rx_status.rate_idx > 3)
+				signal = clamp_t(u8, signal, 25, 90);
+			else
+				signal = clamp_t(u8, signal, 30, 95);
+			rx_status.signal = signal;
 			rx_status.freq = dev->conf.channel->center_freq;
 			rx_status.band = dev->conf.channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
-- 
1.7.1.1

