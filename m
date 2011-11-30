Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4297 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1K3FM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:12:56 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 08/17] ath9k_hw: check for asynchronous MCI interrupt pending
Date: Wed, 30 Nov 2011 10:41:20 +0530
Message-ID: <1322629889-19961-9-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_061259_209220_E5511A82)
In-Reply-To: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

MCI interrupt is an asynchronous one, so take care of it by having a
check in ath9k_hw_intrpend, which actually decides whether the interrupt
is really for the driver from ath_isr

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
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

