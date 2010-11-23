Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51935 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0KWTWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:22:54 -0500
Received: by ewy5 with SMTP id 5so2667633ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:22:53 -0800 (PST)
Date: Tue, 23 Nov 2010 21:21:50 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 17/30] ath5k: Use turbo flag on DCU
Message-ID: <20101123192150.GQ4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Set AR5K_DCU_GBL_IFS_MISC_TURBO_MODE flag on DCU when operating
 on 40MHz

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index e13142a..69bff04 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -647,5 +647,10 @@ int ath5k_hw_init_queues(struct ath5k_hw *ah)
 		 * on ath5k_hw_set_ifs_intervals */
 		ath5k_hw_set_tx_retry_limits(ah, 0);
 
+	/* Set the turbo flag when operating on 40MHz */
+	if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_DCU_GBL_IFS_MISC,
+				AR5K_DCU_GBL_IFS_MISC_TURBO_MODE);
+
 	return 0;
 }
