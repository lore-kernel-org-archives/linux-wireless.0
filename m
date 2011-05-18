Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53948 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab1ERL7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 07:59:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/2] ath9k_hw: remove ath9k_hw_get_desc_link
Date: Wed, 18 May 2011 13:59:24 +0200
Message-Id: <1305719964-44292-2-git-send-email-nbd@openwrt.org> (sfid-20110518_135939_751032_C383F374)
In-Reply-To: <1305719964-44292-1-git-send-email-nbd@openwrt.org>
References: <1305719964-44292-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    6 ------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 --------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 4 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 7a332f1..ee1193c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -28,11 +28,6 @@ static void ar9002_hw_set_desc_link(void *ds, u32 ds_link)
 	((struct ath_desc*) ds)->ds_link = ds_link;
 }
 
-static void ar9002_hw_get_desc_link(void *ds, u32 **ds_link)
-{
-	*ds_link = &((struct ath_desc *)ds)->ds_link;
-}
-
 static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 {
 	u32 isr = 0;
@@ -437,7 +432,6 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 
 	ops->rx_enable = ar9002_hw_rx_enable;
 	ops->set_desc_link = ar9002_hw_set_desc_link;
-	ops->get_desc_link = ar9002_hw_get_desc_link;
 	ops->get_isr = ar9002_hw_get_isr;
 	ops->fill_txdesc = ar9002_hw_fill_txdesc;
 	ops->proc_txdesc = ar9002_hw_proc_txdesc;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index be6adec..9176035 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -43,13 +43,6 @@ static void ar9003_hw_set_desc_link(void *ds, u32 ds_link)
 	ads->ctl10 |= ar9003_calc_ptr_chksum(ads);
 }
 
-static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
-{
-	struct ar9003_txc *ads = ds;
-
-	*ds_link = &ads->link;
-}
-
 static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 {
 	u32 isr = 0;
@@ -498,7 +491,6 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 
 	ops->rx_enable = ar9003_hw_rx_enable;
 	ops->set_desc_link = ar9003_hw_set_desc_link;
-	ops->get_desc_link = ar9003_hw_get_desc_link;
 	ops->get_isr = ar9003_hw_get_isr;
 	ops->fill_txdesc = ar9003_hw_fill_txdesc;
 	ops->proc_txdesc = ar9003_hw_proc_txdesc;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 8b8f044..c550d27 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -39,11 +39,6 @@ static inline void ath9k_hw_set_desc_link(struct ath_hw *ah, void *ds,
 	ath9k_hw_ops(ah)->set_desc_link(ds, link);
 }
 
-static inline void ath9k_hw_get_desc_link(struct ath_hw *ah, void *ds,
-					  u32 **link)
-{
-	ath9k_hw_ops(ah)->get_desc_link(ds, link);
-}
 static inline bool ath9k_hw_calibrate(struct ath_hw *ah,
 				      struct ath9k_channel *chan,
 				      u8 rxchainmask,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7af2773..4ba0b06 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -603,7 +603,6 @@ struct ath_hw_ops {
 				     int power_off);
 	void (*rx_enable)(struct ath_hw *ah);
 	void (*set_desc_link)(void *ds, u32 link);
-	void (*get_desc_link)(void *ds, u32 **link);
 	bool (*calibrate)(struct ath_hw *ah,
 			  struct ath9k_channel *chan,
 			  u8 rxchainmask,
-- 
1.7.3.2

