Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Madhan Jaganathan <madhan.jaganathan@atheros.com>
Subject: [PATCH 5/5] ath9k_hw: add an extra delay when reseting AR_RTC_RESET
Date: Mon, 21 Jun 2010 18:38:51 -0400
Message-Id: <1277159931-7797-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
References: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this we could start trying to work with the device without
it being fully functional yet and loose some packets upon resume.

Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Madhan Jaganathan <madhan.jaganathan@atheros.com>
signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e9764dc..1ed1440 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1070,6 +1070,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		REG_WRITE(ah, AR_RC, AR_RC_AHB);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
+	udelay(2);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 	DISABLE_REGWRITE_BUFFER(ah);
-- 
1.6.3.3

