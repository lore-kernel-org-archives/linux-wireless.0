Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:38002 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZBPCRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 21:17:32 -0500
Received: by gxk22 with SMTP id 22so2648915gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 18:17:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c4d76b3b0902151803m2d4517e0v434cdd12a7c3e074@mail.gmail.com>
References: <c4d76b3b0902151803m2d4517e0v434cdd12a7c3e074@mail.gmail.com>
Date: Sun, 15 Feb 2009 21:17:30 -0500
Message-ID: <c4d76b3b0902151817h35862687ta778434af4817f1c@mail.gmail.com> (sfid-20090216_031736_306597_622D6EE9)
Subject: Re: [PATCH] at76c50x-usb: convert at76_debug to an unsigned int
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at76_debug should be an unsigned int as it used as a bit field.  In
fact, modprobe fails when trying to set at76_debug's high bit.

Also included is a compile fix to the ieee80211_scan_completed() call.

Resend with tabs instead of spaces; not just copied out of the
terminal this time.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index e8868ae..a89ee2d 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -109,7 +109,7 @@
         }                             \
     } while (0)

-static int at76_debug = DBG_DEFAULTS;
+static uint at76_debug = DBG_DEFAULTS;

 /* Protect against concurrent firmware loading and parsing */
 static struct mutex fw_mutex;
@@ -1861,7 +1861,7 @@ static void at76_dwork_hw_scan(struct work_struct *work)
         goto exit;
     }

-    ieee80211_scan_completed(priv->hw);
+    ieee80211_scan_completed(priv->hw, false);

     if (is_valid_ether_addr(priv->bssid))
         at76_join(priv);
@@ -2447,7 +2447,7 @@ static void __exit at76_mod_exit(void)
     led_trigger_unregister_simple(ledtrig_tx);
 }

-module_param_named(debug, at76_debug, int, 0600);
+module_param_named(debug, at76_debug, uint, 0600);
 MODULE_PARM_DESC(debug, "Debugging level");

 module_init(at76_mod_init);
