Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2GJJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:25:00 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v4 02/10] ath9k: Add definitions and structures to support WoW
Date: Tue, 10 Jul 2012 14:54:34 +0530
Message-ID: <1341912274-12013-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_112505_264981_F7B002F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

*add structures, macros and variables for WoW, so that the driver
can make use of it.
*maintain a list for user enabled patterns and masks
*track pattern slots for the hardware limitation on the
maximum number of patterns that can be stored.
*track interrupts enabled before WoW suspend, so
that can be reconfigured after resume
*have macros to parse user defined wow configurations to
hardware code

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   12 +++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |   34 ++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 79840d6..f9c88dc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -510,6 +510,12 @@ static inline void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
 }
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
+struct ath9k_wow_pattern {
+	u8 pattern_bytes[MAX_PATTERN_SIZE];
+	u8 mask_bytes[MAX_PATTERN_SIZE];
+	u32 pattern_len;
+};
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -711,6 +717,12 @@ struct ath_softc {
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
 	struct dfs_pattern_detector *dfs_detector;
+
+#ifdef CONFIG_PM_SLEEP
+	atomic_t wow_got_bmiss_intr;
+	atomic_t wow_sleep_proc_intr; /* in the middle of WoW sleep ? */
+	u32 wow_intr_before_sleep;
+#endif
 };
 
 void ath9k_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 26da173..912f340 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -180,6 +180,37 @@
 #define PAPRD_TABLE_SZ			24
 #define PAPRD_IDEAL_AGC2_PWR_RANGE	0xe0
 
+/*
+ * Wake on Wireless
+ */
+
+/* Keep Alive Frame */
+#define KAL_FRAME_LEN		28
+#define KAL_FRAME_TYPE		0x2	/* data frame */
+#define KAL_FRAME_SUB_TYPE	0x4	/* null data frame */
+#define KAL_DURATION_ID		0x3d
+#define KAL_NUM_DATA_WORDS	6
+#define KAL_NUM_DESC_WORDS	12
+#define KAL_ANTENNA_MODE	1
+#define KAL_TO_DS		1
+#define KAL_DELAY		4	/*delay of 4ms between 2 KAL frames */
+#define KAL_TIMEOUT		900
+
+#define MAX_PATTERN_SIZE		256
+#define MAX_PATTERN_MASK_SIZE		32
+#define MAX_NUM_PATTERN			8
+#define MAX_NUM_USER_PATTERN		6 /*  deducting the disassociate and
+					      deauthenticate packets */
+
+/*
+ * WoW trigger mapping to hardware code
+ */
+
+#define AH_WOW_USER_PATTERN_EN		BIT(0)
+#define AH_WOW_MAGIC_PATTERN_EN		BIT(1)
+#define AH_WOW_LINK_CHANGE		BIT(2)
+#define AH_WOW_BEACON_MISS		BIT(3)
+
 enum ath_hw_txq_subtype {
 	ATH_TXQ_AC_BE = 0,
 	ATH_TXQ_AC_BK = 1,
@@ -863,6 +894,9 @@ struct ath_hw {
 	/* Enterprise mode cap */
 	u32 ent_mode;
 
+#ifdef CONFIG_PM_SLEEP
+	u32 wow_event_mask;
+#endif
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
-- 
1.7.0.4

