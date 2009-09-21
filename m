Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:59981 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZIUW7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 18:59:22 -0400
Received: by yxe37 with SMTP id 37so3642187yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2009 15:59:25 -0700 (PDT)
Message-ID: <4AB8054F.7080600@lwfinger.net>
Date: Mon, 21 Sep 2009 17:59:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH] b43: Implement RFKILL status for LP PHY
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LP (and probably N) PHY has the same radio disabled bit as
the higher-revision A and G PHYs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Submission of this change for 2.6.32 would be nice, but not necessary.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -28,7 +28,7 @@
 /* Returns TRUE, if the radio is enabled in hardware. */
 bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3) {
+	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
 		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;


