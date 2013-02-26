Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab3BZKGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 05:06:10 -0500
Date: Tue, 26 Feb 2013 13:04:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ray_cs: read past the end of the array
Message-ID: <20130226100451.GA12364@longonot.mountain> (sfid-20130226_110615_720329_399DBC51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"translate" should either be set or disabled.  We also use it an
offset into the framing[] array when we're generating the proc
file.  Framing looks like this:

static const char *framing[] = { "Encapsulation", "Translation" }

So when we're setting translate we need to restrict the values to
either 1 or 0 or it can an out of bounds read.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.  This function currently doesn't have
permission checks but maybe it should.

There are a couple other overflow warnings in this file that look
valid, but I don't know what was intended.

drivers/net/wireless/ray_cs.c:602 init_startup_params() error: memcpy() 'b4_default_startup_parms' too small (85 vs 93)
drivers/net/wireless/ray_cs.c:965 translate_frame() warn: buffer overflow '(ptx->var)->org' 3 <= 3

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index e7cf37f..6ee5055 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -144,7 +144,7 @@ static int psm;
 static char *essid;
 
 /* Default to encapsulation unless translation requested */
-static int translate = 1;
+static bool translate = 1;
 
 static int country = USA;
 
@@ -178,7 +178,7 @@ module_param(hop_dwell, int, 0);
 module_param(beacon_period, int, 0);
 module_param(psm, int, 0);
 module_param(essid, charp, 0);
-module_param(translate, int, 0);
+module_param(translate, bool, 0);
 module_param(country, int, 0);
 module_param(sniffer, int, 0);
 module_param(bc, int, 0);
@@ -1353,7 +1353,7 @@ static int ray_get_range(struct net_device *dev, struct iw_request_info *info,
 static int ray_set_framing(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	translate = *(extra);	/* Set framing mode */
+	translate = !!*(extra);	/* Set framing mode */
 
 	return 0;
 }
