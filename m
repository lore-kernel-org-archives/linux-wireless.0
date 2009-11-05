Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZKEGJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 01:09:11 -0500
Date: Thu, 05 Nov 2009 00:09:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Remove deprecated 'qual' from returned RX
 status
Message-ID: <4af26c0b.CmdXP3hT4tXbOLWg%Larry.Finger@lwfinger.net>
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

Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -29,8 +29,6 @@
 
 #define B43legacy_IRQWAIT_MAX_RETRIES	20
 
-#define B43legacy_RX_MAX_SSI		60 /* best guess at max ssi */
-
 /* MMIO offsets */
 #define B43legacy_MMIO_DMA0_REASON	0x20
 #define B43legacy_MMIO_DMA0_IRQ_MASK	0x24
Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
@@ -549,7 +549,6 @@ void b43legacy_rx(struct b43legacy_wldev
 				      (phystat0 & B43legacy_RX_PHYST0_GAINCTL),
 				      (phystat3 & B43legacy_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	status.qual = (jssi * 100) / B43legacy_RX_MAX_SSI;
 	/* change to support A PHY */
 	if (phystat0 & B43legacy_RX_PHYST0_OFDM)
 		status.rate_idx = b43legacy_plcp_get_bitrate_idx_ofdm(plcp, false);
