Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4017 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab2IPU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 16:29:57 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/5] rt2x00: rt2800lib - code cleanup.
Date: Sun, 16 Sep 2012 22:29:51 +0200
Message-Id: <1347827393-26948-4-git-send-email-gwingerde@gmail.com> (sfid-20120916_223058_063997_1C3DEA86)
In-Reply-To: <1347827393-26948-3-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-2-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move RT3290 BBP initialization sequence (part) to the right place in the code.

This is just a code style change, no functional changes.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 17b8a28..37f64ba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3535,6 +3535,11 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2800_is_305x_soc(rt2x00dev)) {
 		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
+	} else if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_bbp_write(rt2x00dev, 74, 0x0b);
+		rt2800_bbp_write(rt2x00dev, 79, 0x18);
+		rt2800_bbp_write(rt2x00dev, 80, 0x09);
+		rt2800_bbp_write(rt2x00dev, 81, 0x33);
 	} else if (rt2x00_rt(rt2x00dev, RT3352)) {
 		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
@@ -3543,13 +3548,6 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 81, 0x37);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290)) {
-		rt2800_bbp_write(rt2x00dev, 74, 0x0b);
-		rt2800_bbp_write(rt2x00dev, 79, 0x18);
-		rt2800_bbp_write(rt2x00dev, 80, 0x09);
-		rt2800_bbp_write(rt2x00dev, 81, 0x33);
-	}
-
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.11.1

