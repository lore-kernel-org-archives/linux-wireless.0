Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52325 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbbBEEtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:42 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENp-002ASp-U5
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] ath9k: Set keep awake timer
Date: Thu,  5 Feb 2015 10:22:39 +0530
Message-Id: <1423111964-19626-3-git-send-email-sujith@msujith.org> (sfid-20150205_054952_692833_9C183BA8)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When MCI is enabled and WoW sleep is enabled,
make sure that the RTC keep awake timer is set
with the required value. This is also required
when the AR_WA is programmed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 5e707c8..721caf3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -44,6 +44,9 @@ static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 			REG_CLR_BIT(ah, AR_DIRECT_CONNECT, AR_DC_TSF2_ENABLE);
 	}
 
+	if (ath9k_hw_mci_is_enabled(ah))
+		REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_ON_INT);
 }
 
@@ -407,6 +410,9 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 
 	ath9k_hw_wow_set_arwr_reg(ah);
 
+	if (ath9k_hw_mci_is_enabled(ah))
+		REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+
 	/* HW WoW */
 	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, BIT(5));
 
-- 
2.2.2

