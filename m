Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42323 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1KUAtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 19:49:32 -0500
Received: by mail-yx0-f174.google.com with SMTP id q3so4154739yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 16:49:32 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 4/4] ath9k: enable ani for 9100
Date: Sun, 20 Nov 2011 19:49:00 -0500
Message-Id: <1321836540-5325-5-git-send-email-mar.kolya@gmail.com> (sfid-20111121_014934_541651_AEC4574E)
In-Reply-To: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d6a2568..79c4a0f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -610,8 +610,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
-        //disable ANI for 9100 and 9340
-        if (AR_SREV_9100(ah) || AR_SREV_9340(ah))
+        //disable ANI for 9340
+        if (AR_SREV_9340(ah))
                 ah->config.enable_ani = false;
 
 	ath9k_hw_init_mode_regs(ah);
-- 
1.7.4.1

