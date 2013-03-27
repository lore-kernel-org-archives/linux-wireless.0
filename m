Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65384 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3C0HhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 03:37:17 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	stable@vger.kernel.org
Subject: [FIX 3.4+][PATCH] b43: N-PHY: use more bits for offset in RSSI calibration
Date: Wed, 27 Mar 2013 08:37:08 +0100
Message-Id: <1364369828-3831-1-git-send-email-zajec5@gmail.com> (sfid-20130327_083722_359288_6B322373)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When calculating "offset" for final RSSI calibration we're using numbers
bigger than s8 can hold. We have for example:
offset[j] = 232 - poll_results[j];
formula. If poll_results[j] is small enough (it usually is) we treat
number's bit as a sign bit. For example 232 - 1 becomes:
0xE8 - 0x1 = 0xE7, which is not 231 but -25.

This code was introduced in e0c9a0219a8f542e3946fe972a68aacf8c3f906c
and caused stability regression on some cards, for ex. BCM4322.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3c35382..4c96a7c 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1564,7 +1564,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
 
 	u8 vcm_final = 0;
-	s8 offset[4];
+	s32 offset[4];
 	s32 results[8][4] = { };
 	s32 results_min[4] = { };
 	s32 poll_results[4] = { };
@@ -1732,7 +1732,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
 
-	s8 offset[4];
+	s32 offset[4];
 	u8 core;
 	u8 rail;
 
-- 
1.7.10.4

