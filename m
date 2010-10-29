Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35949 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762167Ab0J2Xfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:41 -0400
Received: by bwz11 with SMTP id 11so3037820bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <9f86a3d821426da8b6e3d9b7b8ab7bd9f8e76d71.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 29 Oct 2010 23:11:23 +0200
Subject: [PATCH 2/6] carl9170: use generic sign_extend32
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the handcrafted
sign extension cruft with a generic
bitop function.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/phy.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 89deca3..82bc81c 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1554,15 +1554,6 @@ static int carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
 	return carl9170_regwrite_result();
 }
 
-/* TODO: replace this with sign_extend32(noise, 8) */
-static int carl9170_calc_noise_dbm(u32 raw_noise)
-{
-	if (raw_noise & 0x100)
-		return ~0x1ff | raw_noise;
-	else
-		return raw_noise;
-}
-
 int carl9170_get_noisefloor(struct ar9170 *ar)
 {
 	static const u32 phy_regs[] = {
@@ -1578,11 +1569,11 @@ int carl9170_get_noisefloor(struct ar9170 *ar)
 		return err;
 
 	for (i = 0; i < 2; i++) {
-		ar->noise[i] = carl9170_calc_noise_dbm(
-			(phy_res[i] >> 19) & 0x1ff);
+		ar->noise[i] = sign_extend32(GET_VAL(
+			AR9170_PHY_CCA_MIN_PWR, phy_res[i]), 8);
 
-		ar->noise[i + 2] = carl9170_calc_noise_dbm(
-			(phy_res[i + 2] >> 23) & 0x1ff);
+		ar->noise[i + 2] = sign_extend32(GET_VAL(
+			AR9170_PHY_EXT_CCA_MIN_PWR, phy_res[i + 2]), 8);
 	}
 
 	return 0;
-- 
1.7.2.3

