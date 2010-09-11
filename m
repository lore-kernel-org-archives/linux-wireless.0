Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47919 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0IKXsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 19:48:46 -0400
Date: Sun, 12 Sep 2010 01:48:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Matthieu CASTET <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] airo: remove "basic_rate" module option
Message-ID: <20100911234833.GD25351@bicker>
References: <20100910115714.GE5959@bicker> <20100910133401.GF2398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100910133401.GF2398@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "basic_rate" module option is not implemented correctly.  If the
rate was set to zero it was supposed to set it to "basic_rate | 0x80".
Unfortunately the check to see if what zero was wrong and it checked
"!ai->config.rates" (which is always false) instead of
"!ai->config.rates[i]".

This option was just used for development and it wasn't documented
anywhere.  Instead of fixing it, we can just remove it.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2:  Version 1 was just a cleanup to please the static checkers but
didn't fix anything.  Stanislaw suggests that we can remove the feature
entirely so that's what I've done in version 2.

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1d05445..c20cad7 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -217,7 +217,6 @@ static char *statsLabels[] = {
    (no spaces) list of rates (up to 8). */
 
 static int rates[8];
-static int basic_rate;
 static char *ssids[3];
 
 static int io[4];
@@ -250,7 +249,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340/350");
 module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
-module_param(basic_rate, int, 0);
 module_param_array(rates, int, NULL, 0);
 module_param_array(ssids, charp, NULL, 0);
 module_param(auto_wep, int, 0);
@@ -3884,15 +3882,6 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 				ai->config.rates[i] = rates[i];
 			}
 		}
-		if ( basic_rate > 0 ) {
-			for( i = 0; i < 8; i++ ) {
-				if ( ai->config.rates[i] == basic_rate ||
-				     !ai->config.rates ) {
-					ai->config.rates[i] = basic_rate | 0x80;
-					break;
-				}
-			}
-		}
 		set_bit (FLAG_COMMIT, &ai->flags);
 	}
 
