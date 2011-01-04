Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADHrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:47:05 -0500
Received: by iwn9 with SMTP id 9so14032331iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:47:04 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.53341.310223.671145@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:16:37 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 1/5] ath9k_hw: Fix chip test
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

USB devices do not require the chip test routine.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fde9786..4a44f71 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -436,9 +436,10 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 
 static int ath9k_hw_post_init(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int ecode;
 
-	if (!AR_SREV_9271(ah)) {
+	if (common->bus_ops->ath_bus_type != ATH_USB) {
 		if (!ath9k_hw_chip_test(ah))
 			return -ENODEV;
 	}
-- 
1.7.3.4

