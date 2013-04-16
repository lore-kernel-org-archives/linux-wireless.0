Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56797 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3DPKwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 06:52:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/2] ath: update hardware mac address with bssid mask
Date: Tue, 16 Apr 2013 12:51:56 +0200
Message-Id: <1366109517-64645-1-git-send-email-nbd@openwrt.org> (sfid-20130416_125223_471386_61355AAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for updating common->macaddr along with virtual interface
MAC address changes.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 7 +++----
 drivers/net/wireless/ath/ath9k/reg.h | 3 ---
 drivers/net/wireless/ath/hw.c        | 6 ++++++
 drivers/net/wireless/ath/reg.h       | 4 ++++
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8a980a4..10eb6ba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1698,12 +1698,11 @@ static void ath9k_hw_reset_opmode(struct ath_hw *ah,
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
-	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
-		  | macStaId1
+	REG_RMW(ah, AR_STA_ID1, macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
 		  | (ah->config.ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
-		  | ah->sta_id1_defaults);
+		  | ah->sta_id1_defaults,
+		  ~AR_STA_ID1_SADH_MASK);
 	ath_hw_setbssidmask(common);
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
 	ath9k_hw_write_associd(ah);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5929850..5c4ab50 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1493,9 +1493,6 @@ enum {
 #define AR9271_RADIO_RF_RST			0x20
 #define AR9271_GATE_MAC_CTL			0x4000
 
-#define AR_STA_ID0                 0x8000
-#define AR_STA_ID1                 0x8004
-#define AR_STA_ID1_SADH_MASK       0x0000FFFF
 #define AR_STA_ID1_STA_AP          0x00010000
 #define AR_STA_ID1_ADHOC           0x00020000
 #define AR_STA_ID1_PWR_SAV         0x00040000
diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index 39e8a59..eae9abf 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -118,6 +118,12 @@
 void ath_hw_setbssidmask(struct ath_common *common)
 {
 	void *ah = common->ah;
+	u32 id1;
+
+	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
+	id1 = REG_READ(ah, AR_STA_ID1) & ~AR_STA_ID1_SADH_MASK;
+	id1 |= get_unaligned_le16(common->macaddr + 4);
+	REG_WRITE(ah, AR_STA_ID1, id1);
 
 	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(common->bssidmask));
 	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(common->bssidmask + 4));
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
index 298e53f..3ad4c77 100644
--- a/drivers/net/wireless/ath/reg.h
+++ b/drivers/net/wireless/ath/reg.h
@@ -23,6 +23,10 @@
 #define AR_MIBC_CMC		0x00000004
 #define AR_MIBC_MCS		0x00000008
 
+#define AR_STA_ID0		0x8000
+#define AR_STA_ID1		0x8004
+#define AR_STA_ID1_SADH_MASK	0x0000ffff
+
 /*
  * BSSID mask registers. See ath_hw_set_bssid_mask()
  * for detailed documentation about these registers.
-- 
1.8.0.2

