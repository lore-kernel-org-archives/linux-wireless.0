Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33304 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbHTHeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:34:12 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH v2] ath9k: fix AR_RX_FILTER for ar9462/ar9565 when rx stopped
Date: Thu, 20 Aug 2015 15:34:04 +0800
Message-ID: <1440056044-10045-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150820_093415_908144_650750E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

When rx stopped, AR_RX_FILTER should be cleared, but in
ath9k_hw_setrxfilter(), ATH9K_RX_FILTER_CONTROL_WRAPPER will always
be set for ar9462/ar9565.

Fix this by moving the code in ath9k_hw_setrxfilter() to
ath_calcrxfilter().

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 3 ---
 drivers/net/wireless/ath/ath9k/recv.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a31a680..0e2b28c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2760,9 +2760,6 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
-		bits |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
-
 	REG_WRITE(ah, AR_RX_FILTER, bits);
 
 	phybits = 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d3189da..0689f6b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -424,6 +424,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    AR_SREV_9561(sc->sc_ah))
 		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
 
+	if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
+		rfilt |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
+
 	if (ath9k_is_chanctx_enabled() &&
 	    test_bit(ATH_OP_SCANNING, &common->op_flags))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
-- 
1.9.1

