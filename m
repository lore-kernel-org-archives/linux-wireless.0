Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65011 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0DWE6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:36 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10467.933143.983722@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:28:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/11] ath9k_htc: Use multiple register writes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a code segment in configpciepowersave()
to make use of multiple register writes.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index adb33b3..a8a8cdc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -408,6 +408,8 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
 		} else {
+			ENABLE_REGWRITE_BUFFER(ah);
+
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 
@@ -428,6 +430,9 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 
 			/* Load the new settings */
 			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+
+			REGWRITE_BUFFER_FLUSH(ah);
+			DISABLE_REGWRITE_BUFFER(ah);
 		}
 
 		udelay(1000);
-- 
1.7.0.5

