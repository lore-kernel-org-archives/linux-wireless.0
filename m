Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46057 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1H0Wcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 18:32:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/5] ath9k: use u8 for the tx key index
Date: Sun, 28 Aug 2011 00:32:21 +0200
Message-Id: <1314484345-7018-1-git-send-email-nbd@openwrt.org> (sfid-20110828_003247_644869_85029B02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This saves some space in struct ath_frame_info

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h        |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 45b262f..33deb0d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -273,7 +273,7 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 
 static void ar9002_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 				    u32 pktLen, enum ath9k_pkt_type type,
-				    u32 txPower, u32 keyIx,
+				    u32 txPower, u8 keyIx,
 				    enum ath9k_key_type keyType, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 8ace36e..d08ab93 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -312,7 +312,7 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 
 static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 		u32 pktlen, enum ath9k_pkt_type type, u32 txpower,
-		u32 keyIx, enum ath9k_key_type keyType, u32 flags)
+		u8 keyIx, enum ath9k_key_type keyType, u32 flags)
 {
 	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3a893e1..d961f11 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -207,8 +207,8 @@ struct ath_atx_ac {
 
 struct ath_frame_info {
 	int framelen;
-	u32 keyix;
 	enum ath9k_key_type keytype;
+	u8 keyix;
 	u8 retries;
 	u16 seqno;
 };
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3aa3fb1..c8af86c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -623,7 +623,7 @@ struct ath_hw_ops {
 			   struct ath_tx_status *ts);
 	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
 			      u32 pktLen, enum ath9k_pkt_type type,
-			      u32 txPower, u32 keyIx,
+			      u32 txPower, u8 keyIx,
 			      enum ath9k_key_type keyType,
 			      u32 flags);
 	void (*set11n_ratescenario)(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 153859c..b7d91ac 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -194,7 +194,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RX_DECRYPT_BUSY     0x40
 
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
-#define ATH9K_TXKEYIX_INVALID	((u32)-1)
+#define ATH9K_TXKEYIX_INVALID	((u8)-1)
 
 enum ath9k_phyerr {
 	ATH9K_PHYERR_UNDERRUN             = 0,  /* Transmit underrun */
-- 
1.7.3.2

