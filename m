Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51859 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1GPQNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 12:13:46 -0400
Received: by fxd18 with SMTP id 18so4276290fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 09:13:45 -0700 (PDT)
Message-Id: <adb1d389949d70637c47a387df5c556e24a9837e.1310831458.git.chunkeey@googlemail.com> (sfid-20110716_181350_438322_742C74CD)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 16 Jul 2011 17:21:01 +0200
Subject: [PATCH 1/3] carl9170 firmware: update firmware headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * reserves feature bit for CCA counters

 * extends hardware register file definitions

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwdesc.h |    3 ++
 drivers/net/wireless/ath/carl9170/hw.h     |   41 ++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 7ba62bb..6d9c089 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -75,6 +75,9 @@ enum carl9170fw_feature_list {
 	/* Firmware supports PSM in the 5GHZ Band */
 	CARL9170FW_FIXED_5GHZ_PSM,
 
+	/* HW (ANI, CCA, MIB) tally counters */
+	CARL9170FW_HW_COUNTERS,
+
 	/* KEEP LAST */
 	__CARL9170FW_FEATURE_NUM
 };
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 261f893..fa834c1 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -174,6 +174,7 @@
 #define		AR9170_MAC_SNIFFER_ENABLE_PROMISC	BIT(0)
 #define		AR9170_MAC_SNIFFER_DEFAULTS		0x02000000
 #define	AR9170_MAC_REG_ENCRYPTION		(AR9170_MAC_REG_BASE + 0x678)
+#define		AR9170_MAC_ENCRYPTION_MGMT_RX_SOFTWARE	BIT(2)
 #define		AR9170_MAC_ENCRYPTION_RX_SOFTWARE	BIT(3)
 #define		AR9170_MAC_ENCRYPTION_DEFAULTS		0x70
 
@@ -222,6 +223,12 @@
 #define AR9170_MAC_REG_TX_BLOCKACKS		(AR9170_MAC_REG_BASE + 0x6c0)
 #define AR9170_MAC_REG_NAV_COUNT		(AR9170_MAC_REG_BASE + 0x6c4)
 #define AR9170_MAC_REG_BACKOFF_STATUS		(AR9170_MAC_REG_BASE + 0x6c8)
+#define		AR9170_MAC_BACKOFF_CCA			BIT(24)
+#define		AR9170_MAC_BACKOFF_TX_PEX		BIT(25)
+#define		AR9170_MAC_BACKOFF_RX_PE		BIT(26)
+#define		AR9170_MAC_BACKOFF_MD_READY		BIT(27)
+#define		AR9170_MAC_BACKOFF_TX_PE		BIT(28)
+
 #define	AR9170_MAC_REG_TX_RETRY			(AR9170_MAC_REG_BASE + 0x6cc)
 
 #define AR9170_MAC_REG_TX_COMPLETE		(AR9170_MAC_REG_BASE + 0x6d4)
@@ -388,10 +395,40 @@
 
 #define AR9170_MAC_REG_BCN_CURR_ADDR		(AR9170_MAC_REG_BASE + 0xd98)
 #define	AR9170_MAC_REG_BCN_COUNT		(AR9170_MAC_REG_BASE + 0xd9c)
-
-
 #define	AR9170_MAC_REG_BCN_HT1			(AR9170_MAC_REG_BASE + 0xda0)
+#define		AR9170_MAC_BCN_HT1_HT_EN		BIT(0)
+#define		AR9170_MAC_BCN_HT1_GF_PMB		BIT(1)
+#define		AR9170_MAC_BCN_HT1_SP_EXP		BIT(2)
+#define		AR9170_MAC_BCN_HT1_TX_BF		BIT(3)
+#define		AR9170_MAC_BCN_HT1_PWR_CTRL_S		4
+#define		AR9170_MAC_BCN_HT1_PWR_CTRL		0x70
+#define		AR9170_MAC_BCN_HT1_TX_ANT1		BIT(7)
+#define		AR9170_MAC_BCN_HT1_TX_ANT0		BIT(8)
+#define		AR9170_MAC_BCN_HT1_NUM_LFT_S		9
+#define		AR9170_MAC_BCN_HT1_NUM_LFT		0x600
+#define		AR9170_MAC_BCN_HT1_BWC_20M_EXT		BIT(16)
+#define		AR9170_MAC_BCN_HT1_BWC_40M_SHARED	BIT(17)
+#define		AR9170_MAC_BCN_HT1_BWC_40M_DUP		(BIT(16) | BIT(17))
+#define		AR9170_MAC_BCN_HT1_BF_MCS_S		18
+#define		AR9170_MAC_BCN_HT1_BF_MCS		0x1c0000
+#define		AR9170_MAC_BCN_HT1_TPC_S		21
+#define		AR9170_MAC_BCN_HT1_TPC			0x7e00000
+#define		AR9170_MAC_BCN_HT1_CHAIN_MASK_S		27
+#define		AR9170_MAC_BCN_HT1_CHAIN_MASK		0x38000000
+
 #define	AR9170_MAC_REG_BCN_HT2			(AR9170_MAC_REG_BASE + 0xda4)
+#define		AR9170_MAC_BCN_HT2_MCS_S		0
+#define		AR9170_MAC_BCN_HT2_MCS			0x7f
+#define		AR9170_MAC_BCN_HT2_BW40			BIT(8)
+#define		AR9170_MAC_BCN_HT2_SMOOTHING		BIT(9)
+#define		AR9170_MAC_BCN_HT2_SS			BIT(10)
+#define		AR9170_MAC_BCN_HT2_NSS			BIT(11)
+#define		AR9170_MAC_BCN_HT2_STBC_S		12
+#define		AR9170_MAC_BCN_HT2_STBC			0x3000
+#define		AR9170_MAC_BCN_HT2_ADV_COD		BIT(14)
+#define		AR9170_MAC_BCN_HT2_SGI			BIT(15)
+#define		AR9170_MAC_BCN_HT2_LEN_S		16
+#define		AR9170_MAC_BCN_HT2_LEN			0xffff0000
 
 #define	AR9170_MAC_REG_DMA_TXQX_ADDR_CURR	(AR9170_MAC_REG_BASE + 0xdc0)
 
-- 
1.7.5.4

