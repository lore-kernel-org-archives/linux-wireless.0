Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40284 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbCNFy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 11/11] ath9k: Start AIC calibration during MCI reset
Date: Sat, 14 Mar 2015 11:27:57 +0530
Message-Id: <1426312677-2064-12-git-send-email-sujith@msujith.org> (sfid-20150314_070417_103377_C13CED9B)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a MCI reset is done, make sure that AIC
is started.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index cdd83d4..af5ee41 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1017,6 +1017,9 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	if (en_int)
 		ar9003_mci_enable_interrupt(ah);
 
+	if (ath9k_hw_is_aic_enabled(ah))
+		ar9003_aic_start_normal(ah);
+
 	return 0;
 }
 
-- 
2.3.1

