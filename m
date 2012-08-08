Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40317 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab2HHRKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:10:40 -0400
Received: by wibhr14 with SMTP id hr14so937673wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:10:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43legacy: fix logic in GPIO init
Date: Wed,  8 Aug 2012 19:10:16 +0200
Message-Id: <1344445816-11871-3-git-send-email-zajec5@gmail.com> (sfid-20120808_191044_361946_23BB45F6)
In-Reply-To: <1344445816-11871-1-git-send-email-zajec5@gmail.com>
References: <1344445816-11871-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
It's compile-tested only, as I don't have hardware to test it. It's
quite obvious and was also applied in b43.
---
 drivers/net/wireless/b43legacy/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 8156135..3ea1a85 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1920,7 +1920,7 @@ static int b43legacy_gpio_init(struct b43legacy_wldev *dev)
 		return 0;
 	ssb_write32(gpiodev, B43legacy_GPIO_CONTROL,
 		    (ssb_read32(gpiodev, B43legacy_GPIO_CONTROL)
-		     & mask) | set);
+		     & ~mask) | set);
 
 	return 0;
 }
-- 
1.7.7

