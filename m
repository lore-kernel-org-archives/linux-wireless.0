Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0JVPnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:37 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1166345eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:43:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: fix 2055 radio init
Date: Fri, 22 Oct 2010 17:43:46 +0200
Message-Id: <1287762229-16516-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
References: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/radio_2055.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2055.c b/drivers/net/wireless/b43/radio_2055.c
index 1b53165..0d67715 100644
--- a/drivers/net/wireless/b43/radio_2055.c
+++ b/drivers/net/wireless/b43/radio_2055.c
@@ -244,7 +244,7 @@ static const struct b2055_inittab_entry b2055_inittab [] = {
   [0xCB]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xCC]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [B2055_C1_LNA_GAINBST]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
-  [0xCE]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
+  [0xCE]			= { .ghz5 = 0x0006, .ghz2 = 0x0006, NOUPLOAD, },
   [0xCF]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xD0]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xD1]			= { .ghz5 = 0x0018, .ghz2 = 0x0018, NOUPLOAD, },
@@ -256,7 +256,7 @@ static const struct b2055_inittab_entry b2055_inittab [] = {
   [0xD7]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xD8]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [B2055_C2_LNA_GAINBST]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
-  [0xDA]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
+  [0xDA]			= { .ghz5 = 0x0006, .ghz2 = 0x0006, NOUPLOAD, },
   [0xDB]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xDC]			= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [0xDD]			= { .ghz5 = 0x0018, .ghz2 = 0x0018, NOUPLOAD, },
@@ -1299,7 +1299,7 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 			  bool ghz5, bool ignore_uploadflag)
 {
 	const struct b2055_inittab_entry *e;
-	unsigned int i;
+	unsigned int i, writes = 0;
 	u16 value;
 
 	for (i = 0; i < ARRAY_SIZE(b2055_inittab); i++) {
@@ -1312,6 +1312,8 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 			else
 				value = e->ghz2;
 			b43_radio_write16(dev, i, value);
+			if (++writes % 4 == 0)
+				b43_read32(dev, B43_MMIO_MACCTL); /* flush */
 		}
 	}
 }
-- 
1.7.1

