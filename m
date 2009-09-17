Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21637 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760203AbZIQD4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:56:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:56:43 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45948.450756.30029@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:26:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] ath9k: Don't read NF when chip has gone through full sleep mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

NF value may be incorrect when we read it just after the chip
has gone through a full sleep mode. Reading incorrect NF values
affects RX throughput.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4731ad2..2c904c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2357,7 +2357,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (curchan)
+	if (curchan && !ah->chip_fullsleep)
 		ath9k_hw_getnf(ah, curchan);
 
 	if (bChannelChange &&
-- 
1.6.4.3

