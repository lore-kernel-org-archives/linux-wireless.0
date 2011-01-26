Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1AZQaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 11:30:22 -0500
Received: by iwn9 with SMTP id 9so1035708iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 08:30:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19776.19409.340115.964169@gargle.gargle.HOWL>
Date: Wed, 26 Jan 2011 21:59:05 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_hw: Fix opmode initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Commit "ath9k_hw: Relocate Opmode initialization"
moved the opmode initialization before the STA_ID1 register
was programmed with defaults. This changed the original
behaviour because the re-programming code doesn't take into
account the existing value in the register. Both ath9k and ath9k_htc
were not affected by this change because the opmode is
re-initialized after every reset, when RX is started.

Revert to the original behavior, except keep it outside the
REGWRITE block. This would help remove extraneous opmode calls
in the driver core.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4615fd9..c340851 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1349,8 +1349,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
-	ath9k_hw_set_operating_mode(ah, ah->opmode);
-
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
@@ -1368,6 +1366,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
+
 	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
 		return r;
-- 
1.7.3.5

