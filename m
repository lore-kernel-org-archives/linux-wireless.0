Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55477 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZHYOkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 10:40:18 -0400
Received: by ewy2 with SMTP id 2so490055ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 07:40:19 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix and simplify Qdiv roundup
Date: Tue, 25 Aug 2009 16:40:17 +0200
Message-Id: <1251211217-7816-1-git-send-email-netrolller.3d@gmail.com>
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
 drivers/net/wireless/b43/phy_lp.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 7e70c07..d0280d5 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1034,7 +1034,7 @@ static int lpphy_loopback(struct b43_wldev *dev)
 
 static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
 {
-	u32 quotient, remainder, rbit, roundup, tmp;
+	u32 quotient, remainder;
 
 	if (divisor == 0)
 		return 0;
@@ -1042,20 +1042,14 @@ static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
 	quotient = dividend / divisor;
 	remainder = dividend % divisor;
 
-	rbit = divisor & 0x1;
-	roundup = (divisor >> 1) + rbit;
-
 	while (precision != 0) {
-		tmp = remainder - roundup;
 		quotient <<= 1;
-		if (remainder >= roundup)
-			remainder = (tmp << 1) + rbit;
-		else
-			remainder <<= 1;
+		quotient |= (remainder << 1) / divisor;
+		remainder = (remainder << 1) % divisor;
 		precision--;
 	}
 
-	if (remainder >= roundup)
+	if (remainder << 1 >= divisor)
 		quotient++;
 
 	return quotient;
-- 
1.5.6

