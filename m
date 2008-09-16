Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYIPT47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 15:56:59 -0400
Date: Tue, 16 Sep 2008 14:56:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Issue warning when RFKILL_INPUT is not enabled
Message-ID: <48d00f81./8rb7yGSb9PmJx+R%Larry.Finger@lwfinger.net> (sfid-20080916_215703_065027_1768378D)
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
@@ -188,6 +188,11 @@ void b43_rfkill_init(struct b43_wldev *d
 			"The built-in radio LED will not work.\n");
 #endif /* CONFIG_RFKILL_INPUT */
 
+#if !defined(CONFIG_RFKILL_INPUT) && !defined(CONFIG_RFKILL_INPUT_MODULE)
+	b43warn(wl, "The rfkill-input subsystem is not available. "
+		"The built-in radio LED will not work.\n");
+#endif
+
 	err = input_register_polled_device(rfk->poll_dev);
 	if (err)
 		goto err_unreg_rfk;
