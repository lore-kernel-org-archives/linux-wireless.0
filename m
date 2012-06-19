Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26319 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2FSPsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 11:48:20 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	<aeolus@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/10] ath9k: Add definitions and structures to support WoW
Date: Tue, 19 Jun 2012 21:17:22 +0530
Message-ID: <1340120850-9155-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120619_174823_037130_B66F12A4)
In-Reply-To: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
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
Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |   21 +++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a8c0500..264c25b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -505,6 +505,19 @@ static inline u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc,
 }
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
+struct ath9k_wow_pattern {
+	bool slot;
+	u8 pattern_bytes[MAX_PATTERN_SIZE];
+	u8 mask_bytes[MAX_PATTERN_SIZE];
+	u32 pattern_len;
+	struct list_head list;
+};
+
+struct ath9k_wow_info {
+	u32 num_of_patterns;
+	struct list_head wow_patterns;
+};
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -706,6 +719,13 @@ struct ath_softc {
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
 	struct dfs_pattern_detector *dfs_detector;
+
+#ifdef CONFIG_PM_SLEEP
+	bool wow_got_bmiss_intr;
+	bool wow_sleep_proc_intr; /* in the middle of WoW sleep ? */
+	u32 wow_intr_before_sleep;
+	struct ath9k_wow_info wow_info;
+#endif
 };
 
 void ath9k_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 03d5909..d0e14a3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -179,6 +179,24 @@
 #define PAPRD_TABLE_SZ			24
 #define PAPRD_IDEAL_AGC2_PWR_RANGE	0xe0
 
+/* Wake on Wireless */
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
+#define AH_WOW_MAX_EVENTS		4
+
 enum ath_hw_txq_subtype {
 	ATH_TXQ_AC_BE = 0,
 	ATH_TXQ_AC_BK = 1,
@@ -861,6 +879,9 @@ struct ath_hw {
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

