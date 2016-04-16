Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:32786 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbcDPOzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 10:55:51 -0400
Received: by mail-qg0-f49.google.com with SMTP id v14so5573031qge.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2016 07:55:51 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath9k: remove repetitions of mask array size
Date: Sat, 16 Apr 2016 10:54:37 -0400
Message-Id: <1460818477-22785-1-git-send-email-me@bobcopeland.com> (sfid-20160416_165555_183529_1582DA24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The constant "123", which is the number of elements in
mask_m / mask_p, is repeated several times in this function.

Replace memsets with array initialization, and replace a loop
conditional with ARRAY_SIZE() so that we don't repeat ourselves.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 1b271b9..8eea8d2 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -260,8 +260,8 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	int cur_bin;
 	int upper, lower, cur_vit_mask;
 	int i;
-	int8_t mask_m[123];
-	int8_t mask_p[123];
+	int8_t mask_m[123] = {0};
+	int8_t mask_p[123] = {0};
 	int8_t mask_amt;
 	int tmp_mask;
 	static const int pilot_mask_reg[4] = {
@@ -274,9 +274,6 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	};
 	static const int inc[4] = { 0, 100, 0, 0 };
 
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
 	cur_bin = -6000;
 	upper = bin + 100;
 	lower = bin - 100;
@@ -302,7 +299,7 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	upper = bin + 120;
 	lower = bin - 120;
 
-	for (i = 0; i < 123; i++) {
+	for (i = 0; i < ARRAY_SIZE(mask_m); i++) {
 		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
 			/* workaround for gcc bug #37014 */
 			volatile int tmp_v = abs(cur_vit_mask - bin);
-- 
2.1.4

