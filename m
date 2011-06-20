Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab1FTAeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 20:34:01 -0400
Received: by eyx24 with SMTP id 24so371333eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 17:34:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: calibrate radio after switching channel
Date: Mon, 20 Jun 2011 03:12:19 +0200
Message-Id: <1308532339-3643-1-git-send-email-zajec5@gmail.com> (sfid-20110620_023506_604547_5E104279)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After uploading radio values calibration goes in. In MMIO dump it is:
 radio_read(0x002b) -> 0x0008
radio_write(0x002b) <- 0x0008
 radio_read(0x002e) -> 0x0004
radio_write(0x002e) <- 0x0000
 radio_read(0x002e) -> 0x0000
radio_write(0x002e) <- 0x0004
 radio_read(0x002b) -> 0x0008
radio_write(0x002b) <- 0x0009
To find masks and sets, MMIO hacks were used to fool closed driver.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
First I fooled ndiswrapper to get all reads 0xFFFF:
 radio_read(0x002b) -> 0xffff
radio_write(0x002b) <- 0xfffe
 radio_read(0x002e) -> 0xffff
radio_write(0x002e) <- 0xfffb
 radio_read(0x002e) -> 0xffff
radio_write(0x002e) <- 0xffff
 radio_read(0x002b) -> 0xffff
radio_write(0x002b) <- 0xffff
This has shown two first ops are pure masking ones.

Next I fooled ndis to get 0x0000:
 radio_read(0x002b) -> 0x0000
radio_write(0x002b) <- 0x0000
 radio_read(0x002e) -> 0x0000
radio_write(0x002e) <- 0x0000
 radio_read(0x002e) -> 0x0000
radio_write(0x002e) <- 0x0004
 radio_read(0x002b) -> 0x0000
radio_write(0x002b) <- 0x0001
Which has discovered bits setting by 2 later ops.
---
 drivers/net/wireless/b43/phy_ht.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 0b13f6f..72f01ce 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -69,7 +69,13 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 
 	udelay(50);
 
-	/* TODO */
+	/* Calibration */
+	b43_radio_mask(dev, 0x2b, ~0x1);
+	b43_radio_mask(dev, 0x2e, ~0x4);
+	b43_radio_set(dev, 0x2e, 0x4);
+	b43_radio_set(dev, 0x2b, 0x1);
+
+	udelay(300);
 }
 
 static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
-- 
1.7.3.4

