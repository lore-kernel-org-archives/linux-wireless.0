Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0CMFq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:46:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 03/12] ath9k_hw: skip chip tests for AR9271
Date: Sat, 13 Mar 2010 00:46:47 -0500
Message-Id: <1268459216-22372-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

The chip test is not required for AR9271 on the host driver
code as the firmware will do the test internally on its own.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b1ba6f..b1a4a83 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -499,8 +499,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
 
-	if (!ath9k_hw_chip_test(ah))
-		return -ENODEV;
+	if (!AR_SREV_9271(ah)) {
+		if (!ath9k_hw_chip_test(ah))
+			return -ENODEV;
+	}
 
 	ecode = ath9k_hw_rf_claim(ah);
 	if (ecode != 0)
-- 
1.6.3.3

