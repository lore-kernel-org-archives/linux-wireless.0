Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:45318 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbeAZOVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:21:04 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH] ath9k: Fix get channel default noise floor
Date: Fri, 26 Jan 2018 15:20:54 +0100
Message-Id: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180126_152109_142764_7F9B33B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 8da58553cc63 ("ath9k: Use calibrated noise floor value
when available") introduced regression in ath9k_hw_getchan_noise
where per chain nominal noise floor has been taken instead default
for channel.
Revert to original default channel noise floor.

Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 3d9447e..695c779 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -72,7 +72,7 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
 			   s16 nf)
 {
-	s8 noise = ath9k_hw_get_default_nf(ah, chan, 0);
+	s8 noise = ATH_DEFAULT_NOISE_FLOOR;
 
 	if (nf) {
 		s8 delta = nf - ATH9K_NF_CAL_NOISE_THRESH -
-- 
2.7.4
