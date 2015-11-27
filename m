Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34470 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbK0Ihl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:41 -0500
Received: by lffu14 with SMTP id u14so121546153lff.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:39 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 13/13] ath9k: remove ath9k_mod_tsf64_tu
Date: Fri, 27 Nov 2015 09:37:18 +0100
Message-Id: <1448613438-5173-13-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093745_465865_6E369DE5)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ath9k_mod_tsf64_tu() function while we could
use div_u64_rem() function.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/common-beacon.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
index 6ad4447..01d6d32 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.c
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -18,30 +18,16 @@
 
 #define FUDGE 2
 
-/* Calculate the modulo of a 64 bit TSF snapshot with a TU divisor */
-static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
-{
-	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
-
-	tsf_mod = tsf & (BIT(10) - 1);
-	tsf_hi = tsf >> 32;
-	tsf_lo = ((u32) tsf) >> 10;
-
-	mod_hi = tsf_hi % div_tu;
-	mod_lo = ((mod_hi << 22) + tsf_lo) % div_tu;
-
-	return (mod_lo << 10) | tsf_mod;
-}
-
 static u32 ath9k_get_next_tbtt(struct ath_hw *ah, u64 tsf,
 			       unsigned int interval)
 {
-	unsigned int offset;
+	unsigned int offset, divisor;
 
 	tsf += TU_TO_USEC(FUDGE + ah->config.sw_beacon_response_time);
-	offset = ath9k_mod_tsf64_tu(tsf, interval);
+	divisor = TU_TO_USEC(interval);
+	div_u64_rem(tsf, divisor, &offset);
 
-	return (u32) tsf + TU_TO_USEC(interval) - offset;
+	return (u32) tsf + divisor - offset;
 }
 
 /*
-- 
1.9.1

