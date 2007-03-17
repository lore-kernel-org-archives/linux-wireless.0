Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:54642 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXCQQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 12:29:16 -0400
Date: Sat, 17 Mar 2007 11:28:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix code for confusion between PHY revision and  PHY version
Message-ID: <45fc1725.yUj4D2LtC57tEQYF%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several places where the PHY version and revision were interchanged.
These are changed in the specifications on 2/13/07 and now use "analog" instead
instead of "version" to help reduce confusion.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I had thought this patch was submitted earlier, but apparently I failed
to send it. This material is needed for wireless-2.6, "upstream"
and "upstream-fixes".

Thanks,

Larry


Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -458,7 +458,7 @@ static void bcm43xx_calc_nrssi_offset(st
 		bcm43xx_phy_write(bcm, 0x005A, 0x0480);
 		bcm43xx_phy_write(bcm, 0x0059, 0x0810);
 		bcm43xx_phy_write(bcm, 0x0058, 0x000D);
-		if (phy->rev == 0) {
+		if (phy->analog == 0) {
 			bcm43xx_phy_write(bcm, 0x0003, 0x0122);
 		} else {
 			bcm43xx_phy_write(bcm, 0x000A,
@@ -570,9 +570,9 @@ void bcm43xx_calc_nrssi_slope(struct bcm
 		nrssi0 = (s16)bcm43xx_phy_read(bcm, 0x0027);
 		bcm43xx_radio_write16(bcm, 0x007A,
 				      bcm43xx_radio_read16(bcm, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
+		if (phy->analog >= 2) {
 			bcm43xx_write16(bcm, 0x03E6, 0x0040);
-		} else if (phy->rev == 0) {
+		} else if (phy->analog == 0) {
 			bcm43xx_write16(bcm, 0x03E6, 0x0122);
 		} else {
 			bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
@@ -596,7 +596,7 @@ void bcm43xx_calc_nrssi_slope(struct bcm
 		bcm43xx_phy_write(bcm, 0x0015, backup[5]);
 		bcm43xx_phy_write(bcm, 0x002A, backup[6]);
 		bcm43xx_synth_pu_workaround(bcm, radio->channel);
-		if (phy->rev != 0)
+		if (phy->analog != 0)
 			bcm43xx_write16(bcm, 0x03F4, backup[13]);
 
 		bcm43xx_phy_write(bcm, 0x0020, backup[7]);
@@ -692,7 +692,7 @@ void bcm43xx_calc_nrssi_slope(struct bcm
 
 		bcm43xx_radio_write16(bcm, 0x007A,
 				      bcm43xx_radio_read16(bcm, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
+		if (phy->analog >= 2) {
 			bcm43xx_phy_write(bcm, 0x0003,
 					  (bcm43xx_phy_read(bcm, 0x0003)
 					   & 0xFF9F) | 0x0040);

---

