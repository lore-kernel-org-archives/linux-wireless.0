Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55435 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 07/14] ath9k_hw: clean up ath9k_hw_setuprxdesc
Date: Wed, 14 Mar 2012 16:40:27 +0100
Message-Id: <1331739634-22318-7-git-send-email-nbd@openwrt.org> (sfid-20120314_164051_136822_4012F361)
In-Reply-To: <1331739634-22318-6-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ATH9K_HW_CAP_AUTOSLEEP check is bogus, the rx status area needs to be
cleared on all non-EDMA PCI/AHB based chipsets anyway.
Limit the memset to the rx status area to improve performance.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 7b6417b..aa2abaf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -347,15 +347,12 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	ads->ds_ctl1 = size & AR_BufLen;
 	if (flags & ATH9K_RXDESC_INTREQ)
 		ads->ds_ctl1 |= AR_RxIntrReq;
 
-	ads->ds_rxstatus8 &= ~AR_RxDone;
-	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
-		memset(&(ads->u), 0, sizeof(ads->u));
+	memset(&ads->u.rx, 0, sizeof(ads->u.rx));
 }
 EXPORT_SYMBOL(ath9k_hw_setuprxdesc);
 
-- 
1.7.3.2

