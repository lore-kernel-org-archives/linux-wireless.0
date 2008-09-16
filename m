Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43103 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYIPNLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 09:11:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Issue warning when RFKILL_INPUT is not enabled
Date: Tue, 16 Sep 2008 15:11:10 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48cebaca.pA4AdA6Dj23Wwt4K%Larry.Finger@lwfinger.net>
In-Reply-To: <48cebaca.pA4AdA6Dj23Wwt4K%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809161511.11503.mb@bu3sch.de> (sfid-20080916_151149_272789_7C421258)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008 21:43:06 Larry Finger wrote:
> If the system is misconfigured with CONFIG_RFKILL set but CONFIG_RFKILL_INPUT
> not set, the built-in radio LEDs will not work. In the current code, no warning
> is issued.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

This is wrong. Please do something like the following:

Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -186,6 +186,9 @@ void b43_rfkill_init(struct b43_wldev *d
        if (err)
                b43warn(wl, "Failed to load the rfkill-input module. "
                        "The built-in radio LED will not work.\n");
 #endif /* CONFIG_RFKILL_INPUT */
+
+#if !defined(CONFIG_RFKILL_INPUT) && !defined(CONFIG_RFKILL_INPUT_MODULE)
+       b43warn(wl, "The rfkill-input subsystem is not available. "
+               "The built-in radio LED will not work.\n");
+#endif
 
        err = input_register_polled_device(rfk->poll_dev);


-- 
Greetings Michael.
