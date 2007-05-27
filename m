Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:53122 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXE0DWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 23:22:05 -0400
Date: Sat, 26 May 2007 22:21:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix deviation from specifications in  set_baseband_attenuation
Message-ID: <4658f939.o0RS7oOgyDNm1a6Y%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A disagreement between the specifications and the bcm43xx code has just
been discovered and is hereby fixed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should be applied to wireless-2.6. Although it is a bug fix,
it doesn't seem to have much effect on performance. As a result, do not
bother to send it to upstream-fixes.

Larry

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -1638,7 +1638,7 @@ void bcm43xx_phy_set_baseband_attenuatio
 		return;
 	}
 
-	if (phy->analog > 1) {
+	if (phy->analog == 1) {
 		value = bcm43xx_phy_read(bcm, 0x0060) & ~0x003C;
 		value |= (baseband_attenuation << 2) & 0x003C;
 	} else {
