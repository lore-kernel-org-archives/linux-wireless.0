Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:38827 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZBRUlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:41:09 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/2] at76c50x-usb: convert at76_debug to an unsigned int
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Feb 2009 22:41:04 +0200
Message-ID: <20090218204104.19847.42411.stgit@tikku> (sfid-20090218_214113_546297_500979E6)
In-Reply-To: <20090218203830.19847.88862.stgit@tikku>
References: <20090218203830.19847.88862.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Andryuk <jandryuk@gmail.com>

at76_debug should be an unsigned int as it used as a bit field.  In
fact, modprobe fails when trying to set at76_debug's high bit.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index df3efc5..aa06b90 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -109,7 +109,7 @@
 		}							 \
 	} while (0)
 
-static int at76_debug = DBG_DEFAULTS;
+static uint at76_debug = DBG_DEFAULTS;
 
 /* Protect against concurrent firmware loading and parsing */
 static struct mutex fw_mutex;
@@ -2459,7 +2459,7 @@ static void __exit at76_mod_exit(void)
 	led_trigger_unregister_simple(ledtrig_tx);
 }
 
-module_param_named(debug, at76_debug, int, 0600);
+module_param_named(debug, at76_debug, uint, 0600);
 MODULE_PARM_DESC(debug, "Debugging level");
 
 module_init(at76_mod_init);

