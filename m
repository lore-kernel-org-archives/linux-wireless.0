Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYIFVvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 17:51:22 -0400
Date: Sat, 06 Sep 2008 16:51:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> (sfid-20080906_235126_219334_7538E008)
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

This is a bug, not a regression. I guess under the new rules that it
is 2.6.28 material.

Thanks,

Larry
---

Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
@@ -624,7 +624,7 @@ void b43legacy_handle_hwtxstatus(struct
 	tmp = hw->count;
 	status.frame_count = (tmp >> 4);
 	status.rts_count = (tmp & 0x0F);
-	tmp = hw->flags;
+	tmp = hw->flags << 1;
 	status.supp_reason = ((tmp & 0x1C) >> 2);
 	status.pm_indicated = !!(tmp & 0x80);
 	status.intermediate = !!(tmp & 0x40);
