Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41892 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KOGDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:03:44 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 08/18] ath9k_hw: check for asynchronous MCI interrupt pending
Date: Tue, 15 Nov 2011 11:33:36 +0530
Message-ID: <1321337016-12663-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070347_538020_D855EB28)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

MCI interrupt is an asynchronous one, so take care of it by having a
check in ath9k_hw_intrpend, which actually decides whether the interrupt
is really for the driver from ath_isr

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 9d69320..0e4fbb3 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -760,7 +760,10 @@ bool ath9k_hw_intrpend(struct ath_hw *ah)
 		return true;
 
 	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
-	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
+
+	if (((host_isr & AR_INTR_MAC_IRQ) ||
+	     (host_isr & AR_INTR_ASYNC_MASK_MCI)) &&
+	    (host_isr != AR_INTR_SPURIOUS))
 		return true;
 
 	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-- 
1.7.0.4

