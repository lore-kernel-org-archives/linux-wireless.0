Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1H1QIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 12:08:00 -0400
Received: by fxh19 with SMTP id 19so3772058fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 09:07:59 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: use u16 for storing board rev
Date: Sun, 28 Aug 2011 18:47:22 +0200
Message-Id: <1314550043-6220-1-git-send-email-zajec5@gmail.com> (sfid-20110828_180804_372077_E28A7FBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specs say about size 2 (u16) and my 14e4:4727 has board rev 0x1211.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/ssb/ssb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 8623217..f10ed7b 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -25,7 +25,7 @@ struct ssb_sprom {
 	u8 et1phyaddr;		/* MII address for enet1 */
 	u8 et0mdcport;		/* MDIO for enet0 */
 	u8 et1mdcport;		/* MDIO for enet1 */
-	u8 board_rev;		/* Board revision number from SPROM. */
+	u16 board_rev;		/* Board revision number from SPROM. */
 	u8 country_code;	/* Country Code */
 	u16 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
 	u16 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
-- 
1.7.3.4

