Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYIOTnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:43:09 -0400
Date: Mon, 15 Sep 2008 14:43:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Issue warning when RFKILL_INPUT is not enabled
Message-ID: <48cebaca.pA4AdA6Dj23Wwt4K%Larry.Finger@lwfinger.net> (sfid-20080915_214313_819441_D92C852B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the system is misconfigured with CONFIG_RFKILL set but CONFIG_RFKILL_INPUT
not set, the built-in radio LEDs will not work. In the current code, no warning
is issued.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is material for the next merge.

Larry


Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -186,6 +186,9 @@ void b43_rfkill_init(struct b43_wldev *d
 	if (err)
 		b43warn(wl, "Failed to load the rfkill-input module. "
 			"The built-in radio LED will not work.\n");
+#else
+	b43warn(wl, "The rfkill-input subsystem is not available. "
+		"The built-in radio LED will not work.\n");
 #endif /* CONFIG_RFKILL_INPUT */
 
 	err = input_register_polled_device(rfk->poll_dev);
