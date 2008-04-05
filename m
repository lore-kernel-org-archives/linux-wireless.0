Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34191 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYDENUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 09:20:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: use b43_is_mode() call
Date: Sat, 5 Apr 2008 15:19:36 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804051519.36755.mb@bu3sch.de> (sfid-20080405_142040_974233_E1FEAE50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must use the b43_is_mode() call to check the current interface
operation mode.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.26.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-05 15:10:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-05 15:12:48.000000000 +0200
@@ -3768,13 +3768,13 @@ static void b43_set_synth_pu_delay(struc
 
 	/* The time value is in microseconds. */
 	if (dev->phy.type == B43_PHYTYPE_A)
 		pu_delay = 3700;
 	else
 		pu_delay = 1050;
-	if ((dev->wl->if_type == IEEE80211_IF_TYPE_IBSS) || idle)
+	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS) || idle)
 		pu_delay = 500;
 	if ((dev->phy.radio_ver == 0x2050) && (dev->phy.radio_rev == 8))
 		pu_delay = max(pu_delay, (u16)2400);
 
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SPUWKUP, pu_delay);
 }
@@ -3782,13 +3782,13 @@ static void b43_set_synth_pu_delay(struc
 /* Set the TSF CFP pre-TargetBeaconTransmissionTime. */
 static void b43_set_pretbtt(struct b43_wldev *dev)
 {
 	u16 pretbtt;
 
 	/* The time value is in microseconds. */
-	if (dev->wl->if_type == IEEE80211_IF_TYPE_IBSS) {
+	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS)) {
 		pretbtt = 2;
 	} else {
 		if (dev->phy.type == B43_PHYTYPE_A)
 			pretbtt = 120;
 		else
 			pretbtt = 250;
