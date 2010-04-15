Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:53858 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0DOWSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 18:18:50 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id D3EAD77DA05
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 00:08:21 +0200 (CEST)
From: Benoit Papillault <benoit.papillault@free.fr>
To: lrodriguez@atheros.com
Cc: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, derek@indranet.co.nz,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath5k/ath9k: Fix 64 bits TSF reads
Date: Fri, 16 Apr 2010 00:07:26 +0200
Message-Id: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to tests, both TSF lower and upper registers kept counting, so
the higher part could have been updated after the lower part has been
read, as shown in the following log where the upper part is read first
and the lower part next.

tsf = {00000003-fffffffd}
tsf = {00000003-00000001}
tsf = {00000004-0000000b}

This patch corrects this by checking that the upper part has not been
changed while the lower part was read. It has been tested in an IBSS
network where artifical IBSS merges have been done in order to trigger
hundreds of rollover for the TSF lower part.

It follows the logic mentionned by Derek, with only 2 register reads
needed at each additional steps instead of 3 (the minimum number of
register reads is still 3).

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath5k/pcu.c |   31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.c  |   19 +++++++++++++++----
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 710870e..35ac13e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -496,6 +496,8 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 * Beacon control *
 \****************/
 
+#define ATH5K_MAX_TSF_READ 10
+
 /**
  * ath5k_hw_get_tsf64 - Get the full 64bit TSF
  *
@@ -505,10 +507,35 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
  */
 u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
-	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+	u32 tsf_lower, tsf_upper1, tsf_upper2;
+	int i;
+
+	/*
+	 * While reading TSF upper and then lower part, the clock is still
+	 * counting (or jumping in case of IBSS merge) so we might get
+	 * inconsistent values. To avoid this, we read the upper part again
+	 * and check it has not been changed. We make the hypothesis that a
+	 * maximum of 3 changes can happens in a row (we use 10 as a safe
+	 * value).
+	 * 
+	 * Impact on performance is pretty small, since in most cases, only
+	 * 3 register reads are needed.
+	 */
+
+	tsf_upper1 = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+	for (i = 0; i < ATH5K_MAX_TSF_READ; i++) {
+		tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
+		tsf_upper2 = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+		if (tsf_upper2 == tsf_upper1)
+			break;
+		tsf_upper1 = tsf_upper2;
+	}
+
+	WARN_ON( i == ATH5K_MAX_TSF_READ );
+
 	ATH5K_TRACE(ah->ah_sc);
 
-	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
+	return (((u64)tsf_upper1 << 32) | tsf_lower);
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0945452..370e5ed 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3606,14 +3606,25 @@ void ath9k_hw_write_associd(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_write_associd);
 
+#define ATH9K_MAX_TSF_READ 10
+
 u64 ath9k_hw_gettsf64(struct ath_hw *ah)
 {
-	u64 tsf;
+	u32 tsf_lower, tsf_upper1, tsf_upper2;
+	int i;
+
+	tsf_upper1 = REG_READ(ah, AR_TSF_U32);
+	for (i = 0; i < ATH9K_MAX_TSF_READ; i++) {
+		tsf_lower = REG_READ(ah, AR_TSF_L32);
+		tsf_upper2 = REG_READ(ah, AR_TSF_U32);
+		if (tsf_upper2 == tsf_upper1)
+			break;
+		tsf_upper1 = tsf_upper2;
+	}
 
-	tsf = REG_READ(ah, AR_TSF_U32);
-	tsf = (tsf << 32) | REG_READ(ah, AR_TSF_L32);
+	WARN_ON( i == ATH9K_MAX_TSF_READ );
 
-	return tsf;
+	return (((u64)tsf_upper1 << 32) | tsf_lower);
 }
 EXPORT_SYMBOL(ath9k_hw_gettsf64);
 
-- 
1.5.6.5

