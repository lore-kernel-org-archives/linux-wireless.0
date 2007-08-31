Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19289 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754161AbXHaE65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 6/6] adm8211: Fix monitor mode
Date: Fri, 31 Aug 2007 00:56:23 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310056.23408.flamingice@sourmilk.net>
In-Reply-To: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
References: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch makes adm8211 deal with a NULL mac addr in monitor mode and
fixes handling of FCS in monitor mode.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 872b032..be93ba0 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -316,6 +316,11 @@ static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
 	ADM8211_CSR_WRITE(MAR1, mc_filter[1]);
 	ADM8211_CSR_READ(NAR);
 
+	if (flags & IFF_PROMISC)
+		dev->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+	else
+		dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+
 	ADM8211_RESTORE();
 }
 
@@ -476,11 +481,6 @@ static void adm8211_interrupt_rci(struct ieee80211_hw 
*dev)
 			rx_status.freq = adm8211_channels[priv->channel - 1].freq;
 			rx_status.phymode = MODE_IEEE80211B;
 
-			/* remove FCS */
-			/* TODO: remove this and set flag in ieee80211_hw instead? */
-			if (dev->flags & IFF_PROMISC)
-				skb_trim(skb, skb->len - FCS_LEN);
-
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
 		}
 
@@ -1255,6 +1255,9 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 	/* Clear the missed-packet counter. */
 	ADM8211_CSR_READ(LPC);
 
+	if (!priv->mac_addr)
+		return;
+
 	/* set mac address */
 	ADM8211_CSR_WRITE(PAR0, *(u32 *)priv->mac_addr);
 	ADM8211_CSR_WRITE(PAR1, *(u16 *)&priv->mac_addr[4]);

