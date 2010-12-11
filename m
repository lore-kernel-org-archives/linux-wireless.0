Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42409 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0LKXve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 8/8] ath9k_hw: remove ah->txpower_indexoffset
Date: Sun, 12 Dec 2010 00:51:14 +0100
Message-Id: <1292111474-70939-8-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-7-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
 <1292111474-70939-3-git-send-email-nbd@openwrt.org>
 <1292111474-70939-4-git-send-email-nbd@openwrt.org>
 <1292111474-70939-5-git-send-email-nbd@openwrt.org>
 <1292111474-70939-6-git-send-email-nbd@openwrt.org>
 <1292111474-70939-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index f3f9c58..399ab3b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -283,7 +283,6 @@ static void ar9002_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
-	txPower += ah->txpower_indexoffset;
 	if (txPower > 63)
 		txPower = 63;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index bfba6a2..b6e4ee4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -322,7 +322,6 @@ static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 	if (txpower > ah->txpower_limit)
 		txpower = ah->txpower_limit;
 
-	txpower += ah->txpower_indexoffset;
 	if (txpower > 63)
 		txpower = 63;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0db0ef6..c20e047 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -762,7 +762,6 @@ struct ath_hw {
 	u32 *bank6Temp;
 
 	u8 txpower_limit;
-	int16_t txpower_indexoffset;
 	int coverage_class;
 	u32 slottime;
 	u32 globaltxtimeout;
-- 
1.7.3.2

