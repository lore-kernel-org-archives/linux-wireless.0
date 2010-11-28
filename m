Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42391 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0K1MAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 07:00:18 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so3665501wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 04:00:17 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: fix RSSI calibration
Date: Sun, 28 Nov 2010 12:59:45 +0100
Message-Id: <1290945585-20864-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
References: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 31bed83..bf09962 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2064,7 +2064,10 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	u16 class, override;
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
+
 	s8 offset[4];
+	u8 core;
+	u8 rail;
 
 	u16 clip_state[2];
 	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
@@ -2165,12 +2168,11 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 		if (results_min[i] == 248)
 			offset[i] = code - 32;
 
-		if (i % 2 == 0)
-			b43_nphy_scale_offset_rssi(dev, 0, offset[i], 1, 0,
-							type);
-		else
-			b43_nphy_scale_offset_rssi(dev, 0, offset[i], 2, 1,
-							type);
+		core = (i / 2) ? 2 : 1;
+		rail = (i % 2) ? 1 : 0;
+
+		b43_nphy_scale_offset_rssi(dev, 0, offset[i], core, rail,
+						type);
 	}
 
 	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[0]);
-- 
1.6.3.3

