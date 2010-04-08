Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310Ab0DHT1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 094/102] ath9k_hw: Compute pointer checksum over the link descriptor
Date: Thu,  8 Apr 2010 15:27:30 -0400
Message-Id: <1270754858-26266-95-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   32 +++++++++++++++-----------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index b44e2f8..3562503 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -20,9 +20,26 @@ static void ar9003_hw_rx_enable(struct ath_hw *hw)
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
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+
+	ads->link = ds_link;
+	ads->ctl10 &= ~AR_TxPtrChkSum;
+	ads->ctl10 |= ar9003_calc_ptr_chksum(ads);
 }
 
 static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
@@ -167,19 +184,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
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

