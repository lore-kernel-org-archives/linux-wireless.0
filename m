Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:28303 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2BHJUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:20:32 -0500
Date: Wed, 8 Feb 2012 12:20:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wl12xx: remove some dead code in wl1271_plt_init()
Message-ID: <20120208092004.GB6554@elgon.mountain> (sfid-20120208_102040_137572_3EA2339F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ret" has already been checked at this point, and we don't need to check
it again.  This was left around from a previous patch 49d750ca14
"wl12xx: 1281/1283 support - New radio structs and functions".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f8748ce..96d90e7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -672,8 +672,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 		if (ret < 0)
 			return ret;
 	}
-	if (ret < 0)
-		return ret;
 
 	/* Chip-specific initializations */
 	ret = wl1271_chip_specific_init(wl);
