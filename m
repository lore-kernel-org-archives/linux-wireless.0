Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab0DODa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 90/97] ath9k_hw: Compute pointer checksum over the link descriptor
Date: Wed, 14 Apr 2010 23:30:44 -0400
Message-Id: <1271302251-9075-91-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   36 +++++++++++++++-----------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 3884d21..bea081a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -20,14 +20,33 @@ static void ar9003_hw_rx_enable(struct ath_hw *hw)
 	REG_WRITE(hw, AR_CR, 0);
 }
 
+static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
+{
+	int checksum;
+
+	checksum = ads->info + ads->link
+		+ ads->data0 + ads->ctl3
+		+ ads->data1 + ads->ctl5
+		+ ads->data2 + ads->ctl7
+		+ ads->data3 + ads->ctl9;
+
+	return ((checksum & 0xffff) + (checksum >> 16)) & AR_TxPtrChkSum;
+}
+
 static void ar9003_hw_set_desc_link(void *ds, u32 ds_link)
 {
-	((struct ar9003_txc *) ds)->link = ds_link;
+	struct ar9003_txc *ads = ds;
+
+	ads->link = ds_link;
+	ads->ctl10 &= ~AR_TxPtrChkSum;
+	ads->ctl10 |= ar9003_calc_ptr_chksum(ads);
 }
 
 static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
 {
-	*ds_link = &((struct ar9003_txc *) ds)->link;
+	struct ar9003_txc *ads = ds;
+
+	*ds_link = &ads->link;
 }
 
 static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
@@ -167,19 +186,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
-static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
-{
-	int checksum;
-
-	checksum = ads->info + ads->link
-		+ ads->data0 + ads->ctl3
-		+ ads->data1 + ads->ctl5
-		+ ads->data2 + ads->ctl7
-		+ ads->data3 + ads->ctl9;
-
-	return ((checksum & 0xffff) + (checksum >> 16)) & AR_TxPtrChkSum;
-}
-
 static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
 				  bool is_firstseg, bool is_lastseg,
 				  const void *ds0, dma_addr_t buf_addr,
-- 
1.6.3.3

