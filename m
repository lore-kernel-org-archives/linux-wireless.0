Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762172Ab0J2Xfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:42 -0400
Received: by bwz11 with SMTP id 11so3037826bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:41 -0700 (PDT)
Message-Id: <a3d9ffcc810d57add90e43d937b474dc4e0723e0.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 29 Oct 2010 22:44:59 +0200
Subject: [PATCH 1/6] carl9170: import hw/fw header updates
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch imports all shared header changes
from carl9170fw.git.

 * add some strategic __aligned(4).
   This allows the compiler generate optimized code for
   architectures which can't access (unaligned/packed)
   data efficiently.
   ("ath9k_hw: optimize all descriptor access functions")

 * add a forgotten __CARL9170FW__ ifdef around
   a private firmware-internal struct.

 * GET_VAL macro helper
   Very useful for extracting data out of the
   bit-packed PHY registers.

 * cosmetic changes
   e.g.: _CCA_MINCCA_ to just _CCA_MIN_.

 * version bump 1.8.8.3 -> 1.9.0.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h   |   13 +++++++++----
 drivers/net/wireless/ath/carl9170/hw.h      |    7 ++++++-
 drivers/net/wireless/ath/carl9170/phy.h     |   24 ++++++++++++------------
 drivers/net/wireless/ath/carl9170/version.h |    6 +++---
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index d552166..3680dfc7 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -97,13 +97,13 @@ struct carl9170_set_key_cmd {
 	__le16		type;
 	u8		macAddr[6];
 	u32		key[4];
-} __packed;
+} __packed __aligned(4);
 #define CARL9170_SET_KEY_CMD_SIZE		28
 
 struct carl9170_disable_key_cmd {
 	__le16		user;
 	__le16		padding;
-} __packed;
+} __packed __aligned(4);
 #define CARL9170_DISABLE_KEY_CMD_SIZE		4
 
 struct carl9170_u32_list {
@@ -206,7 +206,7 @@ struct carl9170_cmd {
 		struct carl9170_rx_filter_cmd	rx_filter;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
 	} __packed;
-} __packed;
+} __packed __aligned(4);
 
 #define	CARL9170_TX_STATUS_QUEUE	3
 #define	CARL9170_TX_STATUS_QUEUE_S	0
@@ -216,6 +216,7 @@ struct carl9170_cmd {
 #define	CARL9170_TX_STATUS_TRIES	(7 << CARL9170_TX_STATUS_TRIES_S)
 #define	CARL9170_TX_STATUS_SUCCESS	0x80
 
+#ifdef __CARL9170FW__
 /*
  * NOTE:
  * Both structs [carl9170_tx_status and _carl9170_tx_status]
@@ -232,6 +233,8 @@ struct carl9170_tx_status {
 	u8 tries:3;
 	u8 success:1;
 } __packed;
+#endif /* __CARL9170FW__ */
+
 struct _carl9170_tx_status {
 	/*
 	 * This version should be immune to all alignment bugs.
@@ -272,13 +275,15 @@ struct carl9170_rsp {
 		struct carl9170_rf_init_result	rf_init_res;
 		struct carl9170_u32_list	rreg_res;
 		struct carl9170_u32_list	echo;
+#ifdef __CARL9170FW__
 		struct carl9170_tx_status	tx_status[0];
+#endif /* __CARL9170FW__ */
 		struct _carl9170_tx_status	_tx_status[0];
 		struct carl9170_gpio		gpio;
 		struct carl9170_tsf_rsp		tsf;
 		struct carl9170_psm		psm;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
 	} __packed;
-} __packed;
+} __packed __aligned(4);
 
 #endif /* __CARL9170_SHARED_FWCMD_H */
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 2f471b3..e85df6e 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -712,7 +712,8 @@ struct ar9170_stream {
 	__le16 tag;
 
 	u8 payload[0];
-};
+} __packed __aligned(4);
+#define AR9170_STREAM_LEN				4
 
 #define AR9170_MAX_ACKTABLE_ENTRIES			8
 #define AR9170_MAX_VIRTUAL_MAC				7
@@ -736,4 +737,8 @@ struct ar9170_stream {
 
 #define MOD_VAL(reg, value, newvalue)					\
 	(((value) & ~reg) | (((newvalue) << reg##_S) & reg))
+
+#define GET_VAL(reg, value)						\
+	(((value) & reg) >> reg##_S)
+
 #endif	/* __CARL9170_SHARED_HW_H */
diff --git a/drivers/net/wireless/ath/carl9170/phy.h b/drivers/net/wireless/ath/carl9170/phy.h
index 02c34eb..024fb42 100644
--- a/drivers/net/wireless/ath/carl9170/phy.h
+++ b/drivers/net/wireless/ath/carl9170/phy.h
@@ -139,8 +139,8 @@
 #define		AR9170_PHY_AGC_CONTROL_NO_UPDATE_NF	0x00020000
 
 #define	AR9170_PHY_REG_CCA			(AR9170_PHY_REG_BASE + 0x0064)
-#define		AR9170_PHY_CCA_MINCCA_PWR		0x0ff80000
-#define		AR9170_PHY_CCA_MINCCA_PWR_S		19
+#define		AR9170_PHY_CCA_MIN_PWR			0x0ff80000
+#define		AR9170_PHY_CCA_MIN_PWR_S		19
 #define		AR9170_PHY_CCA_THRESH62			0x0007f000
 #define		AR9170_PHY_CCA_THRESH62_S		12
 
@@ -338,8 +338,8 @@
 #define		AR9170_PHY_EXT_CCA_CYCPWR_THR1_S	9
 #define		AR9170_PHY_EXT_CCA_THRESH62		0x007f0000
 #define		AR9170_PHY_EXT_CCA_THRESH62_S		16
-#define		AR9170_PHY_EXT_MINCCA_PWR		0xff800000
-#define		AR9170_PHY_EXT_MINCCA_PWR_S		23
+#define		AR9170_PHY_EXT_CCA_MIN_PWR		0xff800000
+#define		AR9170_PHY_EXT_CCA_MIN_PWR_S		23
 
 #define	AR9170_PHY_REG_SFCORR_EXT		(AR9170_PHY_REG_BASE + 0x01c0)
 #define		AR9170_PHY_SFCORR_EXT_M1_THRESH		0x0000007f
@@ -546,19 +546,19 @@
 #define		AR9170_PHY_FORCE_XPA_CFG_S		0
 
 #define	AR9170_PHY_REG_CH1_CCA			(AR9170_PHY_REG_BASE + 0x1064)
-#define		AR9170_PHY_CH1_MINCCA_PWR		0x0ff80000
-#define		AR9170_PHY_CH1_MINCCA_PWR_S		19
+#define		AR9170_PHY_CH1_CCA_MIN_PWR		0x0ff80000
+#define		AR9170_PHY_CH1_CCA_MIN_PWR_S		19
 
 #define	AR9170_PHY_REG_CH2_CCA			(AR9170_PHY_REG_BASE + 0x2064)
-#define		AR9170_PHY_CH2_MINCCA_PWR		0x0ff80000
-#define		AR9170_PHY_CH2_MINCCA_PWR_S		19
+#define		AR9170_PHY_CH2_CCA_MIN_PWR		0x0ff80000
+#define		AR9170_PHY_CH2_CCA_MIN_PWR_S		19
 
 #define	AR9170_PHY_REG_CH1_EXT_CCA		(AR9170_PHY_REG_BASE + 0x11bc)
-#define		AR9170_PHY_CH1_EXT_MINCCA_PWR		0xff800000
-#define		AR9170_PHY_CH1_EXT_MINCCA_PWR_S		23
+#define		AR9170_PHY_CH1_EXT_CCA_MIN_PWR		0xff800000
+#define		AR9170_PHY_CH1_EXT_CCA_MIN_PWR_S	23
 
 #define	AR9170_PHY_REG_CH2_EXT_CCA		(AR9170_PHY_REG_BASE + 0x21bc)
-#define		AR9170_PHY_CH2_EXT_MINCCA_PWR		0xff800000
-#define		AR9170_PHY_CH2_EXT_MINCCA_PWR_S		23
+#define		AR9170_PHY_CH2_EXT_CCA_MIN_PWR		0xff800000
+#define		AR9170_PHY_CH2_EXT_CCA_MIN_PWR_S	23
 
 #endif	/* __CARL9170_SHARED_PHY_H */
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index ff53f07..ee0f84f 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
 #define CARL9170FW_VERSION_YEAR 10
-#define CARL9170FW_VERSION_MONTH 9
-#define CARL9170FW_VERSION_DAY 28
-#define CARL9170FW_VERSION_GIT "1.8.8.3"
+#define CARL9170FW_VERSION_MONTH 10
+#define CARL9170FW_VERSION_DAY 29
+#define CARL9170FW_VERSION_GIT "1.9.0"
 #endif /* __CARL9170_SHARED_VERSION_H */
-- 
1.7.2.3

