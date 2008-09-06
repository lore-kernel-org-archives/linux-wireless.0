Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYIFSeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:34:04 -0400
Date: Sat, 06 Sep 2008 13:34:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> (sfid-20080906_203409_143100_22F09980)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A coding error present since b43legacy was incorporated into the
kernel has prevented the driver from using the rate-setting mechanism
of mac80211. The driver has been forced to remain at a 1 Mb/s rate.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>		[2.6.26], [2.6.25]
---

John,

Although this is not strictly a regression, it is a bug. I hope
it can be sent to 2.6.27.

Thanks,

Larry
---

Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
@@ -629,7 +629,7 @@ void b43legacy_handle_hwtxstatus(struct
 	status.pm_indicated = !!(tmp & 0x80);
 	status.intermediate = !!(tmp & 0x40);
 	status.for_ampdu = !!(tmp & 0x20);
-	status.acked = !!(tmp & 0x02);
+	status.acked = tmp & 0x01;
 
 	b43legacy_handle_txstatus(dev, &status);
 }
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -744,7 +744,7 @@ static void handle_irq_transmit_status(s
 
 	while (1) {
 		v0 = b43legacy_read32(dev, B43legacy_MMIO_XMITSTAT_0);
-		if (!(v0 & 0x00000001))
+		if (!v0)
 			break;
 		v1 = b43legacy_read32(dev, B43legacy_MMIO_XMITSTAT_1);
 
@@ -758,7 +758,7 @@ static void handle_irq_transmit_status(s
 		stat.pm_indicated = !!(tmp & 0x0080);
 		stat.intermediate = !!(tmp & 0x0040);
 		stat.for_ampdu = !!(tmp & 0x0020);
-		stat.acked = !!(tmp & 0x0002);
+		stat.acked = tmp & 0x0001;
 
 		b43legacy_handle_txstatus(dev, &stat);
 	}
