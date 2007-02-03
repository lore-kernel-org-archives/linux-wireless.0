Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:39214 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXBCTfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Feb 2007 14:35:25 -0500
Date: Sat, 03 Feb 2007 13:34:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Janitorial change - remove two unused variables  extracted from sprom
Message-ID: <45c4e3bc.U2YROV+7jDTmdxqd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two bit-field values are extracted from the sprom data and never used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -513,8 +513,6 @@ struct bcm43xx_sprominfo {
 	u8 et1macaddr[6];
 	u8 et0phyaddr:5;
 	u8 et1phyaddr:5;
-	u8 et0mdcport:1;
-	u8 et1mdcport:1;
 	u8 boardrev;
 	u8 locale:4;
 	u8 antennas_aphy:2;
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -856,8 +856,6 @@ static int bcm43xx_sprom_extract(struct 
 	value = sprom[BCM43xx_SPROM_ETHPHY];
 	bcm->sprom.et0phyaddr = (value & 0x001F);
 	bcm->sprom.et1phyaddr = (value & 0x03E0) >> 5;
-	bcm->sprom.et0mdcport = (value & (1 << 14)) >> 14;
-	bcm->sprom.et1mdcport = (value & (1 << 15)) >> 15;
 
 	/* boardrev, antennas, locale */
 	value = sprom[BCM43xx_SPROM_BOARDREV];
