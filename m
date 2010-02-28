Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:38031 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032092Ab0B1WJG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 17:09:06 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: jirislaby@gmail.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath5k: Fix 64 bits TSF reading.
Date: Sun, 28 Feb 2010 23:08:52 +0100
Message-Id: <1267394932-11038-1-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <4B8AE8F1.40006@free.fr>
References: <4B8AE8F1.40006@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to tests, both TSF lower and upper registers kept counting, so
a rollover of the lower part can happen after the upper part has been
read, as shown in the following log where the upper part is read first
and the lower part next.

tsf = {00000003-fffffffd}
tsf = {00000003-00000001}
tsf = {00000004-0000000b}

This patch corrects this by reading the upper part once again in such
case. It has been tested in an IBSS network where artifical IBSS merges
have been done in order to trigger hundreds of rollover for the TSF
lower part.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath5k/pcu.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index aefe84f..4b24c15 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -593,10 +593,27 @@ u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
  */
 u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
-	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+	u32 tsf_lower, tsf_upper;
+
+	/*
+	 * While reading TSF upper and then lower part, the clock is still
+	 * counting so the lower part can rollover just after reading the
+	 * upper part. In this case, we expect the lower part to be quite
+	 * small (let's say less than 100us) and we would just need to read
+	 * the upper part again to get the correct value.
+	 *
+	 * Tested on AR2425 (AR5001)
+	 */
+
+	tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+	tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
+
+	if (tsf_lower < 100)
+		tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+
 	ATH5K_TRACE(ah->ah_sc);
 
-	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
+	return (((u64)tsf_upper << 32) | tsf_lower);
 }
 
 /**
-- 
1.5.6.5

