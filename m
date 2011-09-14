Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58736 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab1INTYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 05/12] ath9k_hw: do not recalculate the descriptor checksum in ar9003_hw_fill_txdesc
Date: Wed, 14 Sep 2011 21:24:20 +0200
Message-Id: <1316028267-34187-5-git-send-email-nbd@openwrt.org> (sfid-20110914_212450_982385_F648D8AC)
In-Reply-To: <1316028267-34187-4-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduces the number of accesses to uncached descriptor memory.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index d08ab93..c3179d9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -207,8 +207,7 @@ static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
 	ads->ctl3 &= AR_BufLen;
 
 	/* Fill in pointer checksum and descriptor id */
-	ads->ctl10 = ar9003_calc_ptr_chksum(ads);
-	ads->ctl10 |= (descid << AR_TxDescId_S);
+	ads->ctl10 = (descid << AR_TxDescId_S);
 
 	if (is_firstseg) {
 		ads->ctl12 |= (is_lastseg ? 0 : AR_TxMore);
-- 
1.7.3.2

