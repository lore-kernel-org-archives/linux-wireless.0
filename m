Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39441 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0KTCIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:08:53 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k_hw: remove ath9k_hw_stoppcurecv
Date: Sat, 20 Nov 2010 03:08:48 +0100
Message-Id: <1290218928-87475-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290218928-87475-2-git-send-email-nbd@openwrt.org>
References: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
 <1290218928-87475-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is no longer used anywhere

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c |    8 --------
 drivers/net/wireless/ath/ath9k/mac.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 65b1ee2..b04b37b 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -766,14 +766,6 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning)
 }
 EXPORT_SYMBOL(ath9k_hw_startpcureceive);
 
-void ath9k_hw_stoppcurecv(struct ath_hw *ah)
-{
-	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
-
-	ath9k_hw_disable_mib_counters(ah);
-}
-EXPORT_SYMBOL(ath9k_hw_stoppcurecv);
-
 void ath9k_hw_abortpcurecv(struct ath_hw *ah)
 {
 	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_ABORT | AR_DIAG_RX_DIS);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 22907e2..7512f97 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -691,7 +691,6 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
 void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning);
-void ath9k_hw_stoppcurecv(struct ath_hw *ah);
 void ath9k_hw_abortpcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
-- 
1.7.3.2

