Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44227 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbbBPFR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:26 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3h-000EUz-3F
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:25 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] ath9k: Prepare MCI interface correctly
Date: Mon, 16 Feb 2015 10:49:59 +0530
Message-Id: <1424064001-7009-8-git-send-email-sujith@msujith.org> (sfid-20150216_061729_801225_5FE733E6)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The LNA_TRANS message needs to be sent only for
chips which have shared PA/LNA.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index de65ce1..505dfe3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -284,12 +284,12 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 		  AR_MCI_INTERRUPT_RX_MSG_CONT_RST);
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, AR_MCI_INTERRUPT_BT_PRI);
 
-	if (mci->is_2g) {
+	if (mci->is_2g && MCI_ANT_ARCH_PA_LNA_SHARED(mci)) {
 		ar9003_mci_send_lna_transfer(ah, true);
 		udelay(5);
 	}
 
-	if ((mci->is_2g && !mci->update_2g5g)) {
+	if (mci->is_2g && !mci->update_2g5g && MCI_ANT_ARCH_PA_LNA_SHARED(mci)) {
 		if (ar9003_mci_wait_for_interrupt(ah,
 					AR_MCI_INTERRUPT_RX_MSG_RAW,
 					AR_MCI_INTERRUPT_RX_MSG_LNA_INFO,
-- 
2.3.0

