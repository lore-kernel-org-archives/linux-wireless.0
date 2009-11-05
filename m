Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61650 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZKEGI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 01:08:56 -0500
Date: Thu, 05 Nov 2009 00:08:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Remove deprecated 'qual' from returned RX status
Message-ID: <4af26bfb.PLrYIvzFPAS8jKKl%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the deprecation of the qual member of ieee80211_rx_status, that
calculation and an associated constant can be removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.33 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing/drivers/net/wireless/b43/b43.h
@@ -26,8 +26,6 @@
 # define B43_DEBUG	0
 #endif
 
-#define B43_RX_MAX_SSI			60
-
 /* MMIO offsets */
 #define B43_MMIO_DMA0_REASON		0x20
 #define B43_MMIO_DMA0_IRQ_MASK		0x24
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c
+++ wireless-testing/drivers/net/wireless/b43/xmit.c
@@ -621,7 +621,6 @@ void b43_rx(struct b43_wldev *dev, struc
 						  (phystat0 & B43_RX_PHYST0_OFDM),
 						  (phystat0 & B43_RX_PHYST0_GAINCTL),
 						  (phystat3 & B43_RX_PHYST3_TRSTATE));
-		status.qual = (rxhdr->jssi * 100) / B43_RX_MAX_SSI;
 	}
 
 	if (phystat0 & B43_RX_PHYST0_OFDM)
