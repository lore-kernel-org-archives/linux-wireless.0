Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11699 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab1CXKUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 06:20:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 03:19:37 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: remove set11n_virtualmorefrag
Date: Thu, 24 Mar 2011 15:49:54 +0530
Message-ID: <1300961994-5038-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This does not seems to be used anywhere so remove it.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   12 ------------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   12 ------------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h         |    2 --
 4 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 399ab3b..8dd8f63 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -415,17 +415,6 @@ static void ar9002_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
 	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
 }
 
-static void ar9002_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
-					    u32 vmf)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	if (vmf)
-		ads->ds_ctl0 |= AR_VirtMoreFrag;
-	else
-		ads->ds_ctl0 &= ~AR_VirtMoreFrag;
-}
-
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
@@ -459,5 +448,4 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->set11n_aggr_last = ar9002_hw_set11n_aggr_last;
 	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
 	ops->set11n_burstduration = ar9002_hw_set11n_burstduration;
-	ops->set11n_virtualmorefrag = ar9002_hw_set11n_virtualmorefrag;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 038a0cb..724ac24 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -485,17 +485,6 @@ static void ar9003_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
 
 }
 
-static void ar9003_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
-					     u32 vmf)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	if (vmf)
-		ads->ctl11 |=  AR_VirtMoreFrag;
-	else
-		ads->ctl11 &= ~AR_VirtMoreFrag;
-}
-
 void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains)
 {
 	struct ar9003_txc *ads = ds;
@@ -521,7 +510,6 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->set11n_aggr_last = ar9003_hw_set11n_aggr_last;
 	ops->clr11n_aggr = ar9003_hw_clr11n_aggr;
 	ops->set11n_burstduration = ar9003_hw_set11n_burstduration;
-	ops->set11n_virtualmorefrag = ar9003_hw_set11n_virtualmorefrag;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index c8f254f..22ee888 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -122,12 +122,6 @@ static inline void ath9k_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
 	ath9k_hw_ops(ah)->set11n_burstduration(ah, ds, burstDuration);
 }
 
-static inline void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
-						   u32 vmf)
-{
-	ath9k_hw_ops(ah)->set11n_virtualmorefrag(ah, ds, vmf);
-}
-
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3d9fc6e..b131ade 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -644,8 +644,6 @@ struct ath_hw_ops {
 	void (*clr11n_aggr)(struct ath_hw *ah, void *ds);
 	void (*set11n_burstduration)(struct ath_hw *ah, void *ds,
 				     u32 burstDuration);
-	void (*set11n_virtualmorefrag)(struct ath_hw *ah, void *ds,
-				       u32 vmf);
 };
 
 struct ath_nf_limits {
-- 
1.7.0.4

