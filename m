Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2FHRil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:38:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 6/9] ath9k_hw: program OBS register only when MCI is disabled
Date: Fri, 8 Jun 2012 23:09:05 +0530
Message-ID: <1339177148-21672-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120608_193843_815376_E0CB06C1)
In-Reply-To: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c3bb4a3..6a4ac60 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1915,7 +1915,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_set_dma(ah);
 
-	REG_WRITE(ah, AR_OBS, 8);
+	if (!ath9k_hw_mci_is_enabled(ah))
+		REG_WRITE(ah, AR_OBS, 8);
 
 	if (ah->config.rx_intr_mitigation) {
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
-- 
1.7.10.3

