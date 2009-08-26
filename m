Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56513 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZHZSv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 14:51:27 -0400
Received: by fxm17 with SMTP id 17so358129fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 11:51:28 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Fix and simplify Qdiv roundup
Date: Wed, 26 Aug 2009 20:51:24 +0200
Message-Id: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Qdiv roundup routine is essentially a fixed-point
division algorithm, using only integer math.
However, the version in the specs had a major error
that has been recently fixed (a missing quotient++).

Replace Qdiv roundup with a rewritten, simplified version.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
v2: Remove divide/modulo operations from the inner loop.

 drivers/net/wireless/b43/phy_lp.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 7e70c07..5306f2c 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1032,9 +1032,10 @@ static int lpphy_loopback(struct b43_wldev *dev)
 	return index;
 }
 
+/* Fixed-point division algorithm using only integer math. */
 static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
 {
-	u32 quotient, remainder, rbit, roundup, tmp;
+	u32 quotient, remainder;
 
 	if (divisor == 0)
 		return 0;
@@ -1042,20 +1043,16 @@ static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
 	quotient = dividend / divisor;
 	remainder = dividend % divisor;
 
-	rbit = divisor & 0x1;
-	roundup = (divisor >> 1) + rbit;
-
-	while (precision != 0) {
-		tmp = remainder - roundup;
+	while (precision > 0) {
 		quotient <<= 1;
-		if (remainder >= roundup)
-			remainder = (tmp << 1) + rbit;
-		else
-			remainder <<= 1;
+		if (remainder << 1 >= divisor) {
+			quotient++;
+			remainder = (remainder << 1) - divisor;
+		}
 		precision--;
 	}
 
-	if (remainder >= roundup)
+	if (remainder << 1 >= divisor)
 		quotient++;
 
 	return quotient;
-- 
1.5.6

