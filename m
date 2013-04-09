Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936239Ab3DIAxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 20:53:24 -0400
Date: Mon, 08 Apr 2013 19:53:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
Subject: [PATCH -next V2] rtlwifi: rtl8188ee: Fix loop that ends early
Message-ID: <51636681.ROF3hAQdAAJN447/%Larry.Finger@lwfinger.net> (sfid-20130409_025328_160236_A4CDA3C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine _rtl8188e_read_power_value_fromprom(), there are loops initializing
index_cck_base and index_bw40_base from the PROM. As the result of a typo, the
second loop is ended one element too soon.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1635,7 +1635,7 @@ static void _rtl8188e_read_power_value_f
 			if (pwr2g->index_cck_base[path][i] == 0xFF)
 				pwr2g->index_cck_base[path][i] = 0x2D;
 		}
-		for (i = 0; i < MAX_CHNL_GROUP_24G-1; i++) {
+		for (i = 0; i < MAX_CHNL_GROUP_24G; i++) {
 			pwr2g->index_bw40_base[path][i] = hwinfo[eadr++];
 			if (pwr2g->index_bw40_base[path][i] == 0xFF)
 				pwr2g->index_bw40_base[path][i] = 0x2D;
