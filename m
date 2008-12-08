Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23967 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYLHOOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:14:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 06:14:23 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 5/5] ath9k: avoid rx frames with corrupted descriptor.
Date: Mon, 8 Dec 2008 19:43:50 +0530
Message-ID: <1228745630-6928-5-git-send-email-senthilkumar@atheros.com> (sfid-20081208_151426_837820_702C9D28)
In-Reply-To: <1228745630-6928-4-git-send-email-senthilkumar@atheros.com>
References: <1228745630-6928-1-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-2-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-3-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-4-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting RX_ABORT/RX_DIS after MAC reset and clearing RX_ABORT/RX_DIS
after enbling RXE/RXDP to avoid rx frames with corrupted descriptor
status.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c  |    8 ++++++++
 drivers/net/wireless/ath9k/mac.c |    3 +--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 92cda20..209aada 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1213,6 +1213,14 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 static void ath9k_hw_override_ini(struct ath_hal *ah,
 				  struct ath9k_channel *chan)
 {
+	/* 
+	 * Set the RX_ABORT and RX_DIS and clear if off only after
+	 * RXE is set for MAC. This prevents frames with corrupted
+	 * descriptor status.
+	 */
+	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+
+
 	if (!AR_SREV_5416_V20_OR_LATER(ah) ||
 	    AR_SREV_9280_10_OR_LATER(ah))
 		return;
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index 5254ea4..af32d09 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -916,12 +916,11 @@ void ath9k_hw_rxena(struct ath_hal *ah)
 
 void ath9k_hw_startpcureceive(struct ath_hal *ah)
 {
-	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
-
 	ath9k_enable_mib_counters(ah);
 
 	ath9k_ani_reset(ah);
 
+	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 }
 
 void ath9k_hw_stoppcurecv(struct ath_hal *ah)
-- 
1.6.0.4

