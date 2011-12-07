Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54029 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1LGC5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 21:57:31 -0500
Received: by vcbfk14 with SMTP id fk14so74293vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 18:57:31 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v5 4/4] ath9k: enable ANI for ar9100 chips
Date: Tue,  6 Dec 2011 21:57:17 -0500
Message-Id: <1323226637-13663-1-git-send-email-mar.kolya@gmail.com> (sfid-20111207_035746_431368_A5B5AEEE)
In-Reply-To: <20111206205934.GF30288@tuxdriver.com>
References: <20111206205934.GF30288@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Enable ANI for ar9100 since it seems to be working fine (and as a
matter of fact ANI was always performed for ar9100 since code which
was supposed to disable it didn't achieve this goal).
  This patch sets config.enable_ani to default (true) value for
ar9100.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9871072..7f8fc65 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -610,8 +610,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
-	/* disable ANI for 9100 and 9340 */
-	if (AR_SREV_9100(ah) || AR_SREV_9340(ah))
+	/* disable ANI for 9340 */
+	if (AR_SREV_9340(ah))
 		ah->config.enable_ani = false;
 
 	ath9k_hw_init_mode_regs(ah);
-- 
1.7.4.1

