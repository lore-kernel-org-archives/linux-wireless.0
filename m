Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51247 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbBEEts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:48 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENv-002ASp-RD
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] ath9k: Restart TSF2 timers on wakeup
Date: Thu,  5 Feb 2015 10:22:44 +0530
Message-Id: <1423111964-19626-8-git-send-email-sujith@msujith.org> (sfid-20150205_054954_464507_5A9BB4D0)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When coming out of WoW sleep, check and restart
timers based on TSF2.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index efeb9d7..bea41df9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -252,6 +252,13 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, false);
 
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah) || AR_SREV_9485(ah)) {
+		u32 dc = REG_READ(ah, AR_DIRECT_CONNECT);
+
+		if (!(dc & AR_DC_TSF2_ENABLE))
+			ath9k_hw_gen_timer_start_tsf2(ah);
+	}
+
 	ah->wow.wow_event_mask = 0;
 	ah->wow.wow_event_mask2 = 0;
 
-- 
2.2.2

