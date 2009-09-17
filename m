Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21661 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659AbZIQD6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:58:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:58:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.46065.776829.67691@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:28:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/12] ath9k: Fix regression in PA calibration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: Fix bugs in programming registers during PA CAL"
removed a REG_READ of 0x7834. This resulted in incorrect
computation of the subsequent value to be written in RF2G6.

This patch fixes the regression by re-adding the REG_READ.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 22a3a69..0ad6d0b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -936,6 +936,7 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 		regVal |= (1 << (19 + i));
 		REG_WRITE(ah, 0x7834, regVal);
 		udelay(1);
+		regVal = REG_READ(ah, 0x7834);
 		regVal &= (~(0x1 << (19 + i)));
 		reg_field = MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9);
 		regVal |= (reg_field << (19 + i));
-- 
1.6.4.3

