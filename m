Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:59928 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965362AbXBFGRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 01:17:19 -0500
Date: Tue, 06 Feb 2007 00:16:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Ignore ampdu status reports
Message-ID: <45c81d43.P6v/adIydh88LL+j%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

iIf bcm43xx were to process an afterburner (ampdu) status response, Linux would oops. The
ampdu and intermediate status bits are properly named.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1453,12 +1453,10 @@ static void handle_irq_transmit_status(s
 
 		bcm43xx_debugfs_log_txstat(bcm, &stat);
 
-		if (stat.flags & BCM43xx_TXSTAT_FLAG_IGNORE)
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_AMPDU)
+			continue;
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_INTER)
 			continue;
-		if (!(stat.flags & BCM43xx_TXSTAT_FLAG_ACK)) {
-			//TODO: packet was not acked (was lost)
-		}
-		//TODO: There are more (unknown) flags to test. see bcm43xx_main.h
 
 		if (bcm43xx_using_pio(bcm))
 			bcm43xx_pio_handle_xmitstatus(bcm, &stat);
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
@@ -137,14 +137,8 @@ struct bcm43xx_xmitstatus {
 	u16 unknown; //FIXME
 };
 
-#define BCM43xx_TXSTAT_FLAG_ACK		0x01
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x02
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x04
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x08
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x10
-#define BCM43xx_TXSTAT_FLAG_IGNORE	0x20
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x40
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x80
+#define BCM43xx_TXSTAT_FLAG_AMPDU	0x10
+#define BCM43xx_TXSTAT_FLAG_INTER	0x20
 
 u8 bcm43xx_plcp_get_ratecode_cck(const u8 bitrate);
 u8 bcm43xx_plcp_get_ratecode_ofdm(const u8 bitrate);
