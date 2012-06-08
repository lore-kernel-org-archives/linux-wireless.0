Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24110 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2FHRis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:38:48 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 7/9] ath9k_hw: process MCI interrupts only when btcoex is enabled
Date: Fri, 8 Jun 2012 23:09:06 +0530
Message-ID: <1339177148-21672-7-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120608_193851_312359_5C2FE8D7)
In-Reply-To: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

let us process MCI interrupts only when BTCOEX is enabled to avoid
processing bogus interrupts.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index d9e0824..1c0621d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -302,7 +302,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 			ar9003_hw_bb_watchdog_read(ah);
 	}
 
-	if (async_cause & AR_INTR_ASYNC_MASK_MCI)
+	if ((async_cause & AR_INTR_ASYNC_MASK_MCI) &&
+	    ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_get_isr(ah, masked);
 
 	if (sync_cause) {
-- 
1.7.10.3

