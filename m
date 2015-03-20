Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:35280 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbCTN4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:55 -0400
Received: by labjg1 with SMTP id jg1so87651202lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/9] ath10k: use hw rate definitions for fixed rate
Date: Fri, 20 Mar 2015 13:54:11 +0000
Message-Id: <1426859655-11797-6-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145711_013109_D33AEEBE)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using raw values is discouraged. Having
defines/enums is preferred.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f4e76e7..72fbdc2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4972,20 +4972,18 @@ exit:
 
 /* Helper table for legacy fixed_rate/bitrate_mask */
 static const u8 cck_ofdm_rate[] = {
-	/* CCK */
-	3, /* 1Mbps */
-	2, /* 2Mbps */
-	1, /* 5.5Mbps */
-	0, /* 11Mbps */
-	/* OFDM */
-	3, /* 6Mbps */
-	7, /* 9Mbps */
-	2, /* 12Mbps */
-	6, /* 18Mbps */
-	1, /* 24Mbps */
-	5, /* 36Mbps */
-	0, /* 48Mbps */
-	4, /* 54Mbps */
+	ATH10K_HW_RATE_CCK_LP_1M,
+	ATH10K_HW_RATE_CCK_LP_2M,
+	ATH10K_HW_RATE_CCK_LP_5_5M,
+	ATH10K_HW_RATE_CCK_LP_11M,
+	ATH10K_HW_RATE_OFDM_6M,
+	ATH10K_HW_RATE_OFDM_9M,
+	ATH10K_HW_RATE_OFDM_12M,
+	ATH10K_HW_RATE_OFDM_18M,
+	ATH10K_HW_RATE_OFDM_24M,
+	ATH10K_HW_RATE_OFDM_36M,
+	ATH10K_HW_RATE_OFDM_48M,
+	ATH10K_HW_RATE_OFDM_54M,
 };
 
 /* Check if only one bit set */
-- 
2.1.4

