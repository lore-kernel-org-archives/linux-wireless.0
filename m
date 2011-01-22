Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1AWAD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 19:03:58 -0500
Received: by bwz15 with SMTP id 15so2636425bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 16:03:57 -0800 (PST)
Message-Id: <2137e711f16faed3f59698cbcb210a1e650dd34c.1295740096.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 22 Jan 2011 22:46:49 +0100
Subject: [PATCH 1/3] carl9170: update fw/hw headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch syncs up the header files with
the project's main firmware carl9170fw.git.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h   |    1 +
 drivers/net/wireless/ath/carl9170/fwdesc.h  |   28 +++++++++++++++++++++-----
 drivers/net/wireless/ath/carl9170/hw.h      |   25 ++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/version.h |    8 +++---
 drivers/net/wireless/ath/carl9170/wlan.h    |   20 ++++++++++++++++++-
 5 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 3680dfc7..30449d2 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -167,6 +167,7 @@ struct carl9170_rx_filter_cmd {
 #define CARL9170_RX_FILTER_CTL_BACKR	0x20
 #define CARL9170_RX_FILTER_MGMT		0x40
 #define CARL9170_RX_FILTER_DATA		0x80
+#define CARL9170_RX_FILTER_EVERYTHING	(~0)
 
 struct carl9170_bcn_ctrl_cmd {
 	__le32		vif_id;
diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 71f3821..9210668 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -69,6 +69,9 @@ enum carl9170fw_feature_list {
 	/* Firmware RX filter | CARL9170_CMD_RX_FILTER */
 	CARL9170FW_RX_FILTER,
 
+	/* Wake up on WLAN */
+	CARL9170FW_WOL,
+
 	/* KEEP LAST */
 	__CARL9170FW_FEATURE_NUM
 };
@@ -78,6 +81,7 @@ enum carl9170fw_feature_list {
 #define FIX_MAGIC	"FIX\0"
 #define DBG_MAGIC	"DBG\0"
 #define CHK_MAGIC	"CHK\0"
+#define TXSQ_MAGIC	"TXSQ"
 #define LAST_MAGIC	"LAST"
 
 #define CARL9170FW_SET_DAY(d) (((d) - 1) % 31)
@@ -88,8 +92,10 @@ enum carl9170fw_feature_list {
 #define CARL9170FW_GET_MONTH(m) ((((m) / 31) % 12) + 1)
 #define CARL9170FW_GET_YEAR(y) ((y) / 372 + 10)
 
+#define CARL9170FW_MAGIC_SIZE			4
+
 struct carl9170fw_desc_head {
-	u8	magic[4];
+	u8	magic[CARL9170FW_MAGIC_SIZE];
 	__le16 length;
 	u8 min_ver;
 	u8 cur_ver;
@@ -170,6 +176,16 @@ struct carl9170fw_chk_desc {
 #define CARL9170FW_CHK_DESC_SIZE			\
 	(sizeof(struct carl9170fw_chk_desc))
 
+#define CARL9170FW_TXSQ_DESC_MIN_VER			1
+#define CARL9170FW_TXSQ_DESC_CUR_VER			1
+struct carl9170fw_txsq_desc {
+	struct carl9170fw_desc_head head;
+
+	__le32 seq_table_addr;
+} __packed;
+#define CARL9170FW_TXSQ_DESC_SIZE			\
+	(sizeof(struct carl9170fw_txsq_desc))
+
 #define CARL9170FW_LAST_DESC_MIN_VER			1
 #define CARL9170FW_LAST_DESC_CUR_VER			2
 struct carl9170fw_last_desc {
@@ -189,8 +205,8 @@ struct carl9170fw_last_desc {
 	}
 
 static inline void carl9170fw_fill_desc(struct carl9170fw_desc_head *head,
-					 u8 magic[4], __le16 length,
-					 u8 min_ver, u8 cur_ver)
+					 u8 magic[CARL9170FW_MAGIC_SIZE],
+					 __le16 length, u8 min_ver, u8 cur_ver)
 {
 	head->magic[0] = magic[0];
 	head->magic[1] = magic[1];
@@ -204,7 +220,7 @@ static inline void carl9170fw_fill_desc(struct carl9170fw_desc_head *head,
 
 #define carl9170fw_for_each_hdr(desc, fw_desc)				\
 	for (desc = fw_desc;						\
-	     memcmp(desc->magic, LAST_MAGIC, 4) &&			\
+	     memcmp(desc->magic, LAST_MAGIC, CARL9170FW_MAGIC_SIZE) &&	\
 	     le16_to_cpu(desc->length) >= CARL9170FW_DESC_HEAD_SIZE &&	\
 	     le16_to_cpu(desc->length) < CARL9170FW_DESC_MAX_LENGTH;	\
 	     desc = (void *)((unsigned long)desc + le16_to_cpu(desc->length)))
@@ -218,8 +234,8 @@ static inline bool carl9170fw_supports(__le32 list, u8 feature)
 }
 
 static inline bool carl9170fw_desc_cmp(const struct carl9170fw_desc_head *head,
-				       const u8 descid[4], u16 min_len,
-				       u8 compatible_revision)
+				       const u8 descid[CARL9170FW_MAGIC_SIZE],
+				       u16 min_len, u8 compatible_revision)
 {
 	if (descid[0] == head->magic[0] && descid[1] == head->magic[1] &&
 	    descid[2] == head->magic[2] && descid[3] == head->magic[3] &&
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index e85df6e..4e30762 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -463,6 +463,8 @@
 
 #define	AR9170_PWR_REG_CHIP_REVISION		(AR9170_PWR_REG_BASE + 0x010)
 #define AR9170_PWR_REG_PLL_ADDAC		(AR9170_PWR_REG_BASE + 0x014)
+#define		AR9170_PWR_PLL_ADDAC_DIV_S		2
+#define		AR9170_PWR_PLL_ADDAC_DIV		0xffc
 #define	AR9170_PWR_REG_WATCH_DOG_MAGIC		(AR9170_PWR_REG_BASE + 0x020)
 
 /* Faraday USB Controller */
@@ -471,6 +473,9 @@
 #define	AR9170_USB_REG_MAIN_CTRL		(AR9170_USB_REG_BASE + 0x000)
 #define		AR9170_USB_MAIN_CTRL_REMOTE_WAKEUP	BIT(0)
 #define		AR9170_USB_MAIN_CTRL_ENABLE_GLOBAL_INT	BIT(2)
+#define		AR9170_USB_MAIN_CTRL_GO_TO_SUSPEND	BIT(3)
+#define		AR9170_USB_MAIN_CTRL_RESET		BIT(4)
+#define		AR9170_USB_MAIN_CTRL_CHIP_ENABLE	BIT(5)
 #define		AR9170_USB_MAIN_CTRL_HIGHSPEED		BIT(6)
 
 #define	AR9170_USB_REG_DEVICE_ADDRESS		(AR9170_USB_REG_BASE + 0x001)
@@ -499,6 +504,13 @@
 #define	AR9170_USB_REG_INTR_GROUP		(AR9170_USB_REG_BASE + 0x020)
 
 #define	AR9170_USB_REG_INTR_SOURCE_0		(AR9170_USB_REG_BASE + 0x021)
+#define		AR9170_USB_INTR_SRC0_SETUP		BIT(0)
+#define		AR9170_USB_INTR_SRC0_IN			BIT(1)
+#define		AR9170_USB_INTR_SRC0_OUT		BIT(2)
+#define		AR9170_USB_INTR_SRC0_FAIL		BIT(3) /* ??? */
+#define		AR9170_USB_INTR_SRC0_END		BIT(4) /* ??? */
+#define		AR9170_USB_INTR_SRC0_ABORT		BIT(7)
+
 #define	AR9170_USB_REG_INTR_SOURCE_1		(AR9170_USB_REG_BASE + 0x022)
 #define	AR9170_USB_REG_INTR_SOURCE_2		(AR9170_USB_REG_BASE + 0x023)
 #define	AR9170_USB_REG_INTR_SOURCE_3		(AR9170_USB_REG_BASE + 0x024)
@@ -506,6 +518,15 @@
 #define	AR9170_USB_REG_INTR_SOURCE_5		(AR9170_USB_REG_BASE + 0x026)
 #define	AR9170_USB_REG_INTR_SOURCE_6		(AR9170_USB_REG_BASE + 0x027)
 #define	AR9170_USB_REG_INTR_SOURCE_7		(AR9170_USB_REG_BASE + 0x028)
+#define		AR9170_USB_INTR_SRC7_USB_RESET		BIT(1)
+#define		AR9170_USB_INTR_SRC7_USB_SUSPEND	BIT(2)
+#define		AR9170_USB_INTR_SRC7_USB_RESUME		BIT(3)
+#define		AR9170_USB_INTR_SRC7_ISO_SEQ_ERR	BIT(4)
+#define		AR9170_USB_INTR_SRC7_ISO_SEQ_ABORT	BIT(5)
+#define		AR9170_USB_INTR_SRC7_TX0BYTE		BIT(6)
+#define		AR9170_USB_INTR_SRC7_RX0BYTE		BIT(7)
+
+#define	AR9170_USB_REG_IDLE_COUNT		(AR9170_USB_REG_BASE + 0x02f)
 
 #define	AR9170_USB_REG_EP_MAP			(AR9170_USB_REG_BASE + 0x030)
 #define	AR9170_USB_REG_EP1_MAP			(AR9170_USB_REG_BASE + 0x030)
@@ -581,6 +602,10 @@
 
 #define	AR9170_USB_REG_MAX_AGG_UPLOAD		(AR9170_USB_REG_BASE + 0x110)
 #define	AR9170_USB_REG_UPLOAD_TIME_CTL		(AR9170_USB_REG_BASE + 0x114)
+
+#define AR9170_USB_REG_WAKE_UP			(AR9170_USB_REG_BASE + 0x120)
+#define		AR9170_USB_WAKE_UP_WAKE			BIT(0)
+
 #define	AR9170_USB_REG_CBUS_CTRL		(AR9170_USB_REG_BASE + 0x1f0)
 #define		AR9170_USB_CBUS_CTRL_BUFFER_END		(BIT(1))
 
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index ee0f84f..15095c0 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
-#define CARL9170FW_VERSION_YEAR 10
-#define CARL9170FW_VERSION_MONTH 10
-#define CARL9170FW_VERSION_DAY 29
-#define CARL9170FW_VERSION_GIT "1.9.0"
+#define CARL9170FW_VERSION_YEAR 11
+#define CARL9170FW_VERSION_MONTH 1
+#define CARL9170FW_VERSION_DAY 22
+#define CARL9170FW_VERSION_GIT "1.9.2"
 #endif /* __CARL9170_SHARED_VERSION_H */
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index 24d63b5..9e1324b 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -251,7 +251,7 @@ struct carl9170_tx_superdesc {
 	u8 ampdu_commit_factor:1;
 	u8 ampdu_unused_bit:1;
 	u8 queue:2;
-	u8 reserved:1;
+	u8 assign_seq:1;
 	u8 vif_id:3;
 	u8 fill_in_tsf:1;
 	u8 cab:1;
@@ -299,6 +299,7 @@ struct _ar9170_tx_hwdesc {
 
 #define CARL9170_TX_SUPER_MISC_QUEUE			0x3
 #define CARL9170_TX_SUPER_MISC_QUEUE_S			0
+#define CARL9170_TX_SUPER_MISC_ASSIGN_SEQ		0x4
 #define	CARL9170_TX_SUPER_MISC_VIF_ID			0x38
 #define	CARL9170_TX_SUPER_MISC_VIF_ID_S			3
 #define	CARL9170_TX_SUPER_MISC_FILL_IN_TSF		0x40
@@ -413,6 +414,23 @@ enum ar9170_txq {
 	__AR9170_NUM_TXQ,
 };
 
+/*
+ * This is an workaround for several undocumented bugs.
+ * Don't mess with the QoS/AC <-> HW Queue map, if you don't
+ * know what you are doing.
+ *
+ * Known problems [hardware]:
+ *  * The MAC does not aggregate frames on anything other
+ *    than the first HW queue.
+ *  * when an AMPDU is placed [in the first hw queue] and
+ *    additional frames are already queued on a different
+ *    hw queue, the MAC will ALWAYS freeze.
+ *
+ * In a nutshell: The hardware can either do QoS or
+ * Aggregation but not both at the same time. As a
+ * result, this makes the device pretty much useless
+ * for any serious 802.11n setup.
+ */
 static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 2, 1, 0, 3 };
 
 #define	AR9170_TXQ_DEPTH			32
-- 
1.7.2.3

