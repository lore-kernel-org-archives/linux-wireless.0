Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43279 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab1F3T0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:26:37 -0400
Received: by fxd18 with SMTP id 18so2559984fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:26:36 -0700 (PDT)
Message-Id: <48506f4c6ef4578f748a77e2c7bca7374cf1a187.1309459253.git.chunkeey@googlemail.com> (sfid-20110630_212647_301138_E332DAFC)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Jun 2011 20:27:47 +0200
Subject: [PATCH 1/3] carl9170: import 1.9.4 firmware headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch imports all shared header changes
from carl9170fw.git.

 * update copyright boilerplate

 * add some more strategic __aligned(4).

 * WoWLAN

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    2 ++
 drivers/net/wireless/ath/carl9170/fwcmd.h    |   19 ++++++++++++++++++-
 drivers/net/wireless/ath/carl9170/fwdesc.h   |   18 ++++++++++++++++--
 drivers/net/wireless/ath/carl9170/hw.h       |   15 +++++++++++++--
 drivers/net/wireless/ath/carl9170/version.h  |    6 +++---
 drivers/net/wireless/ath/carl9170/wlan.h     |   25 +++++++++++--------------
 6 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 4da01a9..d96d03f 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -67,6 +67,8 @@
 
 #define PAYLOAD_MAX	(CARL9170_MAX_CMD_LEN / 4 - 1)
 
+static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
+
 enum carl9170_rf_init_mode {
 	CARL9170_RFI_NONE,
 	CARL9170_RFI_WARM,
diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 30449d2..8fea629 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -4,7 +4,7 @@
  * Firmware command interface definitions
  *
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2009, 2010, Christian Lamparter <chunkeey@googlemail.com>
+ * Copyright 2009-2011 Christian Lamparter <chunkeey@googlemail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -54,6 +54,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_BCN_CTRL		= 0x05,
 	CARL9170_CMD_READ_TSF		= 0x06,
 	CARL9170_CMD_RX_FILTER		= 0x07,
+	CARL9170_CMD_WOL		= 0x08,
 
 	/* CAM */
 	CARL9170_CMD_EKEY		= 0x10,
@@ -180,6 +181,21 @@ struct carl9170_bcn_ctrl_cmd {
 #define CARL9170_BCN_CTRL_DRAIN	0
 #define CARL9170_BCN_CTRL_CAB_TRIGGER	1
 
+struct carl9170_wol_cmd {
+	__le32		flags;
+	u8		mac[6];
+	u8		bssid[6];
+	__le32		null_interval;
+	__le32		free_for_use2;
+	__le32		mask;
+	u8		pattern[32];
+} __packed;
+
+#define CARL9170_WOL_CMD_SIZE		60
+
+#define CARL9170_WOL_DISCONNECT		1
+#define CARL9170_WOL_MAGIC_PKT		2
+
 struct carl9170_cmd_head {
 	union {
 		struct {
@@ -203,6 +219,7 @@ struct carl9170_cmd {
 		struct carl9170_write_reg	wreg;
 		struct carl9170_rf_init		rf_init;
 		struct carl9170_psm		psm;
+		struct carl9170_wol_cmd		wol;
 		struct carl9170_bcn_ctrl_cmd	bcn_ctrl;
 		struct carl9170_rx_filter_cmd	rx_filter;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 9210668..7ba62bb 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -3,7 +3,7 @@
  *
  * Firmware descriptor format
  *
- * Copyright 2009, 2010, Christian Lamparter <chunkeey@googlemail.com>
+ * Copyright 2009-2011 Christian Lamparter <chunkeey@googlemail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -72,6 +72,9 @@ enum carl9170fw_feature_list {
 	/* Wake up on WLAN */
 	CARL9170FW_WOL,
 
+	/* Firmware supports PSM in the 5GHZ Band */
+	CARL9170FW_FIXED_5GHZ_PSM,
+
 	/* KEEP LAST */
 	__CARL9170FW_FEATURE_NUM
 };
@@ -82,6 +85,7 @@ enum carl9170fw_feature_list {
 #define DBG_MAGIC	"DBG\0"
 #define CHK_MAGIC	"CHK\0"
 #define TXSQ_MAGIC	"TXSQ"
+#define WOL_MAGIC	"WOL\0"
 #define LAST_MAGIC	"LAST"
 
 #define CARL9170FW_SET_DAY(d) (((d) - 1) % 31)
@@ -104,7 +108,7 @@ struct carl9170fw_desc_head {
 	(sizeof(struct carl9170fw_desc_head))
 
 #define CARL9170FW_OTUS_DESC_MIN_VER		6
-#define CARL9170FW_OTUS_DESC_CUR_VER		6
+#define CARL9170FW_OTUS_DESC_CUR_VER		7
 struct carl9170fw_otus_desc {
 	struct carl9170fw_desc_head head;
 	__le32 feature_set;
@@ -186,6 +190,16 @@ struct carl9170fw_txsq_desc {
 #define CARL9170FW_TXSQ_DESC_SIZE			\
 	(sizeof(struct carl9170fw_txsq_desc))
 
+#define CARL9170FW_WOL_DESC_MIN_VER			1
+#define CARL9170FW_WOL_DESC_CUR_VER			1
+struct carl9170fw_wol_desc {
+	struct carl9170fw_desc_head head;
+
+	__le32 supported_triggers;	/* CARL9170_WOL_ */
+} __packed;
+#define CARL9170FW_WOL_DESC_SIZE			\
+	(sizeof(struct carl9170fw_wol_desc))
+
 #define CARL9170FW_LAST_DESC_MIN_VER			1
 #define CARL9170FW_LAST_DESC_CUR_VER			2
 struct carl9170fw_last_desc {
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 4e30762..261f893 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -4,7 +4,7 @@
  * Register map, hardware-specific definitions
  *
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2009, 2010, Christian Lamparter <chunkeey@googlemail.com>
+ * Copyright 2009-2011 Christian Lamparter <chunkeey@googlemail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -357,7 +357,18 @@
 
 #define AR9170_MAC_REG_DMA_WLAN_STATUS		(AR9170_MAC_REG_BASE + 0xd38)
 #define	AR9170_MAC_REG_DMA_STATUS		(AR9170_MAC_REG_BASE + 0xd3c)
-
+#define AR9170_MAC_REG_DMA_TXQ_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd40)
+#define	AR9170_MAC_REG_DMA_TXQ0_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd40)
+#define	AR9170_MAC_REG_DMA_TXQ1_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd44)
+#define	AR9170_MAC_REG_DMA_TXQ2_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd48)
+#define	AR9170_MAC_REG_DMA_TXQ3_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd4c)
+#define	AR9170_MAC_REG_DMA_TXQ4_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd50)
+#define	AR9170_MAC_REG_DMA_TXQ0Q1_LEN		(AR9170_MAC_REG_BASE + 0xd54)
+#define	AR9170_MAC_REG_DMA_TXQ2Q3_LEN		(AR9170_MAC_REG_BASE + 0xd58)
+#define	AR9170_MAC_REG_DMA_TXQ4_LEN		(AR9170_MAC_REG_BASE + 0xd5c)
+
+#define AR9170_MAC_REG_DMA_TXQX_LAST_ADDR	(AR9170_MAC_REG_BASE + 0xd74)
+#define AR9170_MAC_REG_DMA_TXQX_FAIL_ADDR	(AR9170_MAC_REG_BASE + 0xd78)
 #define	AR9170_MAC_REG_TXRX_MPI			(AR9170_MAC_REG_BASE + 0xd7c)
 #define		AR9170_MAC_TXRX_MPI_TX_MPI_MASK		0x0000000f
 #define		AR9170_MAC_TXRX_MPI_TX_TO_MASK		0x0000fff0
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index 15095c0..6470377 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
 #define CARL9170FW_VERSION_YEAR 11
-#define CARL9170FW_VERSION_MONTH 1
-#define CARL9170FW_VERSION_DAY 22
-#define CARL9170FW_VERSION_GIT "1.9.2"
+#define CARL9170FW_VERSION_MONTH 6
+#define CARL9170FW_VERSION_DAY 30
+#define CARL9170FW_VERSION_GIT "1.9.4"
 #endif /* __CARL9170_SHARED_VERSION_H */
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index 9e1324b..ea17995 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -4,7 +4,7 @@
  * RX/TX meta descriptor format
  *
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2009, 2010, Christian Lamparter <chunkeey@googlemail.com>
+ * Copyright 2009-2011 Christian Lamparter <chunkeey@googlemail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -278,7 +278,7 @@ struct ar9170_tx_frame {
 struct carl9170_tx_superframe {
 	struct carl9170_tx_superdesc s;
 	struct ar9170_tx_frame f;
-} __packed;
+} __packed __aligned(4);
 
 #endif /* __CARL9170FW__ */
 
@@ -328,7 +328,7 @@ struct _carl9170_tx_superframe {
 	struct _carl9170_tx_superdesc s;
 	struct _ar9170_tx_hwdesc f;
 	u8 frame_data[0];
-} __packed;
+} __packed __aligned(4);
 
 #define	CARL9170_TX_SUPERDESC_LEN		24
 #define	AR9170_TX_HWDESC_LEN			8
@@ -404,16 +404,6 @@ static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_macstatus *t)
 	       (t->DAidx & 0xc0) >> 6;
 }
 
-enum ar9170_txq {
-	AR9170_TXQ_BE,
-
-	AR9170_TXQ_VI,
-	AR9170_TXQ_VO,
-	AR9170_TXQ_BK,
-
-	__AR9170_NUM_TXQ,
-};
-
 /*
  * This is an workaround for several undocumented bugs.
  * Don't mess with the QoS/AC <-> HW Queue map, if you don't
@@ -431,7 +421,14 @@ enum ar9170_txq {
  * result, this makes the device pretty much useless
  * for any serious 802.11n setup.
  */
-static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 2, 1, 0, 3 };
+enum ar9170_txq {
+	AR9170_TXQ_BK = 0,	/* TXQ0 */
+	AR9170_TXQ_BE,		/* TXQ1	*/
+	AR9170_TXQ_VI,		/* TXQ2	*/
+	AR9170_TXQ_VO,		/* TXQ3 */
+
+	__AR9170_NUM_TXQ,
+};
 
 #define	AR9170_TXQ_DEPTH			32
 
-- 
1.7.5.4

