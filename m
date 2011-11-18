Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1KRIWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:52 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MqBt015895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 57/77] iwlegacy: merge iwl-legacy-rs.h into common.h
Date: Fri, 18 Nov 2011 09:22:19 +0100
Message-Id: <1321604559-10707-57-git-send-email-sgruszka@redhat.com> (sfid-20111118_092302_003578_A57B16E6)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h        |  461 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h |  454 ------------------------
 2 files changed, 442 insertions(+), 473 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index e83c6ab..2e66929 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -39,7 +39,6 @@
 #include "iwl-debug.h"
 #include "iwl-led.h"
 #include "iwl-power.h"
-#include "iwl-legacy-rs.h"
 
 struct il_host_cmd;
 struct il_cmd;
@@ -480,24 +479,6 @@ struct il_station_priv_common {
 	u8 sta_id;
 };
 
-/*
- * il_station_priv: Driver's ilate station information
- *
- * When mac80211 creates a station it reserves some space (hw->sta_data_size)
- * in the structure for use by driver. This structure is places in that
- * space.
- *
- * The common struct MUST be first because it is shared between
- * 3945 and 4965!
- */
-struct il_station_priv {
-	struct il_station_priv_common common;
-	struct il_lq_sta lq_sta;
-	atomic_t pending_frames;
-	bool client;
-	bool asleep;
-};
-
 /**
  * struct il_vif_priv - driver's ilate per-interface information
  *
@@ -2573,4 +2554,446 @@ struct il_tfd {
 #define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
 #define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
 
+struct il_rate_info {
+	u8 plcp;	/* uCode API:  RATE_6M_PLCP, etc. */
+	u8 plcp_siso;	/* uCode API:  RATE_SISO_6M_PLCP, etc. */
+	u8 plcp_mimo2;	/* uCode API:  RATE_MIMO2_6M_PLCP, etc. */
+	u8 ieee;	/* MAC header:  RATE_6M_IEEE, etc. */
+	u8 prev_ieee;    /* previous rate in IEEE speeds */
+	u8 next_ieee;    /* next rate in IEEE speeds */
+	u8 prev_rs;      /* previous rate used in rs algo */
+	u8 next_rs;      /* next rate used in rs algo */
+	u8 prev_rs_tgg;  /* previous rate used in TGG rs algo */
+	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
+};
+
+struct il3945_rate_info {
+	u8 plcp;		/* uCode API:  RATE_6M_PLCP, etc. */
+	u8 ieee;		/* MAC header:  RATE_6M_IEEE, etc. */
+	u8 prev_ieee;		/* previous rate in IEEE speeds */
+	u8 next_ieee;		/* next rate in IEEE speeds */
+	u8 prev_rs;		/* previous rate used in rs algo */
+	u8 next_rs;		/* next rate used in rs algo */
+	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
+	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
+	u8 table_rs_idx;	/* idx in rate scale table cmd */
+	u8 prev_table_rs;	/* prev in rate table cmd */
+};
+
+
+/*
+ * These serve as idxes into
+ * struct il_rate_info il_rates[RATE_COUNT];
+ */
+enum {
+	RATE_1M_IDX = 0,
+	RATE_2M_IDX,
+	RATE_5M_IDX,
+	RATE_11M_IDX,
+	RATE_6M_IDX,
+	RATE_9M_IDX,
+	RATE_12M_IDX,
+	RATE_18M_IDX,
+	RATE_24M_IDX,
+	RATE_36M_IDX,
+	RATE_48M_IDX,
+	RATE_54M_IDX,
+	RATE_60M_IDX,
+	RATE_COUNT,
+	RATE_COUNT_LEGACY = RATE_COUNT - 1,	/* Excluding 60M */
+	RATE_COUNT_3945 = RATE_COUNT - 1,
+	RATE_INVM_IDX = RATE_COUNT,
+	RATE_INVALID = RATE_COUNT,
+};
+
+enum {
+	RATE_6M_IDX_TBL = 0,
+	RATE_9M_IDX_TBL,
+	RATE_12M_IDX_TBL,
+	RATE_18M_IDX_TBL,
+	RATE_24M_IDX_TBL,
+	RATE_36M_IDX_TBL,
+	RATE_48M_IDX_TBL,
+	RATE_54M_IDX_TBL,
+	RATE_1M_IDX_TBL,
+	RATE_2M_IDX_TBL,
+	RATE_5M_IDX_TBL,
+	RATE_11M_IDX_TBL,
+	RATE_INVM_IDX_TBL = RATE_INVM_IDX - 1,
+};
+
+enum {
+	IL_FIRST_OFDM_RATE = RATE_6M_IDX,
+	IL39_LAST_OFDM_RATE = RATE_54M_IDX,
+	IL_LAST_OFDM_RATE = RATE_60M_IDX,
+	IL_FIRST_CCK_RATE = RATE_1M_IDX,
+	IL_LAST_CCK_RATE = RATE_11M_IDX,
+};
+
+/* #define vs. enum to keep from defaulting to 'large integer' */
+#define	RATE_6M_MASK   (1 << RATE_6M_IDX)
+#define	RATE_9M_MASK   (1 << RATE_9M_IDX)
+#define	RATE_12M_MASK  (1 << RATE_12M_IDX)
+#define	RATE_18M_MASK  (1 << RATE_18M_IDX)
+#define	RATE_24M_MASK  (1 << RATE_24M_IDX)
+#define	RATE_36M_MASK  (1 << RATE_36M_IDX)
+#define	RATE_48M_MASK  (1 << RATE_48M_IDX)
+#define	RATE_54M_MASK  (1 << RATE_54M_IDX)
+#define RATE_60M_MASK  (1 << RATE_60M_IDX)
+#define	RATE_1M_MASK   (1 << RATE_1M_IDX)
+#define	RATE_2M_MASK   (1 << RATE_2M_IDX)
+#define	RATE_5M_MASK   (1 << RATE_5M_IDX)
+#define	RATE_11M_MASK  (1 << RATE_11M_IDX)
+
+/* uCode API values for legacy bit rates, both OFDM and CCK */
+enum {
+	RATE_6M_PLCP  = 13,
+	RATE_9M_PLCP  = 15,
+	RATE_12M_PLCP = 5,
+	RATE_18M_PLCP = 7,
+	RATE_24M_PLCP = 9,
+	RATE_36M_PLCP = 11,
+	RATE_48M_PLCP = 1,
+	RATE_54M_PLCP = 3,
+	RATE_60M_PLCP = 3,/*FIXME:RS:should be removed*/
+	RATE_1M_PLCP  = 10,
+	RATE_2M_PLCP  = 20,
+	RATE_5M_PLCP  = 55,
+	RATE_11M_PLCP = 110,
+	/*FIXME:RS:add RATE_LEGACY_INVM_PLCP = 0,*/
+};
+
+/* uCode API values for OFDM high-throughput (HT) bit rates */
+enum {
+	RATE_SISO_6M_PLCP = 0,
+	RATE_SISO_12M_PLCP = 1,
+	RATE_SISO_18M_PLCP = 2,
+	RATE_SISO_24M_PLCP = 3,
+	RATE_SISO_36M_PLCP = 4,
+	RATE_SISO_48M_PLCP = 5,
+	RATE_SISO_54M_PLCP = 6,
+	RATE_SISO_60M_PLCP = 7,
+	RATE_MIMO2_6M_PLCP  = 0x8,
+	RATE_MIMO2_12M_PLCP = 0x9,
+	RATE_MIMO2_18M_PLCP = 0xa,
+	RATE_MIMO2_24M_PLCP = 0xb,
+	RATE_MIMO2_36M_PLCP = 0xc,
+	RATE_MIMO2_48M_PLCP = 0xd,
+	RATE_MIMO2_54M_PLCP = 0xe,
+	RATE_MIMO2_60M_PLCP = 0xf,
+	RATE_SISO_INVM_PLCP,
+	RATE_MIMO2_INVM_PLCP = RATE_SISO_INVM_PLCP,
+};
+
+/* MAC header values for bit rates */
+enum {
+	RATE_6M_IEEE  = 12,
+	RATE_9M_IEEE  = 18,
+	RATE_12M_IEEE = 24,
+	RATE_18M_IEEE = 36,
+	RATE_24M_IEEE = 48,
+	RATE_36M_IEEE = 72,
+	RATE_48M_IEEE = 96,
+	RATE_54M_IEEE = 108,
+	RATE_60M_IEEE = 120,
+	RATE_1M_IEEE  = 2,
+	RATE_2M_IEEE  = 4,
+	RATE_5M_IEEE  = 11,
+	RATE_11M_IEEE = 22,
+};
+
+#define IL_CCK_BASIC_RATES_MASK    \
+	(RATE_1M_MASK          | \
+	RATE_2M_MASK)
+
+#define IL_CCK_RATES_MASK          \
+	(IL_CCK_BASIC_RATES_MASK  | \
+	RATE_5M_MASK          | \
+	RATE_11M_MASK)
+
+#define IL_OFDM_BASIC_RATES_MASK   \
+	(RATE_6M_MASK         | \
+	RATE_12M_MASK         | \
+	RATE_24M_MASK)
+
+#define IL_OFDM_RATES_MASK         \
+	(IL_OFDM_BASIC_RATES_MASK | \
+	RATE_9M_MASK          | \
+	RATE_18M_MASK         | \
+	RATE_36M_MASK         | \
+	RATE_48M_MASK         | \
+	RATE_54M_MASK)
+
+#define IL_BASIC_RATES_MASK         \
+	(IL_OFDM_BASIC_RATES_MASK | \
+	 IL_CCK_BASIC_RATES_MASK)
+
+#define RATES_MASK ((1 << RATE_COUNT) - 1)
+#define RATES_MASK_3945 ((1 << RATE_COUNT_3945) - 1)
+
+#define IL_INVALID_VALUE    -1
+
+#define IL_MIN_RSSI_VAL                 -100
+#define IL_MAX_RSSI_VAL                    0
+
+/* These values specify how many Tx frame attempts before
+ * searching for a new modulation mode */
+#define IL_LEGACY_FAILURE_LIMIT	160
+#define IL_LEGACY_SUCCESS_LIMIT	480
+#define IL_LEGACY_TBL_COUNT		160
+
+#define IL_NONE_LEGACY_FAILURE_LIMIT	400
+#define IL_NONE_LEGACY_SUCCESS_LIMIT	4500
+#define IL_NONE_LEGACY_TBL_COUNT	1500
+
+/* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
+#define IL_RS_GOOD_RATIO		12800	/* 100% */
+#define RATE_SCALE_SWITCH		10880	/*  85% */
+#define RATE_HIGH_TH		10880	/*  85% */
+#define RATE_INCREASE_TH		6400	/*  50% */
+#define RATE_DECREASE_TH		1920	/*  15% */
+
+/* possible actions when in legacy mode */
+#define IL_LEGACY_SWITCH_ANTENNA1      0
+#define IL_LEGACY_SWITCH_ANTENNA2      1
+#define IL_LEGACY_SWITCH_SISO          2
+#define IL_LEGACY_SWITCH_MIMO2_AB      3
+#define IL_LEGACY_SWITCH_MIMO2_AC      4
+#define IL_LEGACY_SWITCH_MIMO2_BC      5
+
+/* possible actions when in siso mode */
+#define IL_SISO_SWITCH_ANTENNA1        0
+#define IL_SISO_SWITCH_ANTENNA2        1
+#define IL_SISO_SWITCH_MIMO2_AB        2
+#define IL_SISO_SWITCH_MIMO2_AC        3
+#define IL_SISO_SWITCH_MIMO2_BC        4
+#define IL_SISO_SWITCH_GI              5
+
+/* possible actions when in mimo mode */
+#define IL_MIMO2_SWITCH_ANTENNA1       0
+#define IL_MIMO2_SWITCH_ANTENNA2       1
+#define IL_MIMO2_SWITCH_SISO_A         2
+#define IL_MIMO2_SWITCH_SISO_B         3
+#define IL_MIMO2_SWITCH_SISO_C         4
+#define IL_MIMO2_SWITCH_GI             5
+
+#define IL_MAX_SEARCH IL_MIMO2_SWITCH_GI
+
+#define IL_ACTION_LIMIT		3	/* # possible actions */
+
+#define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
+
+/* load per tid defines for A-MPDU activation */
+#define IL_AGG_TPT_THREHOLD	0
+#define IL_AGG_LOAD_THRESHOLD	10
+#define IL_AGG_ALL_TID		0xff
+#define TID_QUEUE_CELL_SPACING	50	/*mS */
+#define TID_QUEUE_MAX_SIZE	20
+#define TID_ROUND_VALUE		5	/* mS */
+#define TID_MAX_LOAD_COUNT	8
+
+#define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
+#define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
+
+extern const struct il_rate_info il_rates[RATE_COUNT];
+
+enum il_table_type {
+	LQ_NONE,
+	LQ_G,		/* legacy types */
+	LQ_A,
+	LQ_SISO,	/* high-throughput types */
+	LQ_MIMO2,
+	LQ_MAX,
+};
+
+#define is_legacy(tbl) ((tbl) == LQ_G || (tbl) == LQ_A)
+#define is_siso(tbl) ((tbl) == LQ_SISO)
+#define is_mimo2(tbl) ((tbl) == LQ_MIMO2)
+#define is_mimo(tbl) (is_mimo2(tbl))
+#define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
+#define is_a_band(tbl) ((tbl) == LQ_A)
+#define is_g_and(tbl) ((tbl) == LQ_G)
+
+#define	ANT_NONE	0x0
+#define	ANT_A		BIT(0)
+#define	ANT_B		BIT(1)
+#define	ANT_AB		(ANT_A | ANT_B)
+#define ANT_C		BIT(2)
+#define	ANT_AC		(ANT_A | ANT_C)
+#define ANT_BC		(ANT_B | ANT_C)
+#define ANT_ABC		(ANT_AB | ANT_C)
+
+#define IL_MAX_MCS_DISPLAY_SIZE	12
+
+struct il_rate_mcs_info {
+	char	mbps[IL_MAX_MCS_DISPLAY_SIZE];
+	char	mcs[IL_MAX_MCS_DISPLAY_SIZE];
+};
+
+/**
+ * struct il_rate_scale_data -- tx success history for one rate
+ */
+struct il_rate_scale_data {
+	u64 data;		/* bitmap of successful frames */
+	s32 success_counter;	/* number of frames successful */
+	s32 success_ratio;	/* per-cent * 128  */
+	s32 counter;		/* number of frames attempted */
+	s32 average_tpt;	/* success ratio * expected throughput */
+	unsigned long stamp;
+};
+
+/**
+ * struct il_scale_tbl_info -- tx params and success history for all rates
+ *
+ * There are two of these in struct il_lq_sta,
+ * one for "active", and one for "search".
+ */
+struct il_scale_tbl_info {
+	enum il_table_type lq_type;
+	u8 ant_type;
+	u8 is_SGI;	/* 1 = short guard interval */
+	u8 is_ht40;	/* 1 = 40 MHz channel width */
+	u8 is_dup;	/* 1 = duplicated data streams */
+	u8 action;	/* change modulation; IL_[LEGACY/SISO/MIMO]_SWITCH_* */
+	u8 max_search;	/* maximun number of tables we can search */
+	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
+	u32 current_rate;  /* rate_n_flags, uCode API format */
+	struct il_rate_scale_data win[RATE_COUNT]; /* rate histories */
+};
+
+struct il_traffic_load {
+	unsigned long time_stamp;	/* age of the oldest stats */
+	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
+						 * slice */
+	u32 total;			/* total num of packets during the
+					 * last TID_MAX_TIME_DIFF */
+	u8 queue_count;			/* number of queues that has
+					 * been used since the last cleanup */
+	u8 head;			/* start of the circular buffer */
+};
+
+/**
+ * struct il_lq_sta -- driver's rate scaling ilate structure
+ *
+ * Pointer to this gets passed back and forth between driver and mac80211.
+ */
+struct il_lq_sta {
+	u8 active_tbl;		/* idx of active table, range 0-1 */
+	u8 enable_counter;	/* indicates HT mode */
+	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
+	u8 search_better_tbl;	/* 1: currently trying alternate mode */
+	s32 last_tpt;
+
+	/* The following determine when to search for a new mode */
+	u32 table_count_limit;
+	u32 max_failure_limit;	/* # failed frames before new search */
+	u32 max_success_limit;	/* # successful frames before new search */
+	u32 table_count;
+	u32 total_failed;	/* total failed frames, any/all rates */
+	u32 total_success;	/* total successful frames, any/all rates */
+	u64 flush_timer;	/* time staying in mode before new search */
+
+	u8 action_counter;	/* # mode-switch actions tried */
+	u8 is_green;
+	u8 is_dup;
+	enum ieee80211_band band;
+
+	/* The following are bitmaps of rates; RATE_6M_MASK, etc. */
+	u32 supp_rates;
+	u16 active_legacy_rate;
+	u16 active_siso_rate;
+	u16 active_mimo2_rate;
+	s8 max_rate_idx;     /* Max rate set by user */
+	u8 missed_rate_counter;
+
+	struct il_link_quality_cmd lq;
+	struct il_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
+	struct il_traffic_load load[TID_MAX_LOAD_COUNT];
+	u8 tx_agg_tid_en;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *rs_sta_dbgfs_scale_table_file;
+	struct dentry *rs_sta_dbgfs_stats_table_file;
+	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
+	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
+	u32 dbg_fixed_rate;
+#endif
+	struct il_priv *drv;
+
+	/* used to be in sta_info */
+	int last_txrate_idx;
+	/* last tx rate_n_flags */
+	u32 last_rate_n_flags;
+	/* packets destined for this STA are aggregated */
+	u8 is_agg;
+};
+
+/*
+ * il_station_priv: Driver's ilate station information
+ *
+ * When mac80211 creates a station it reserves some space (hw->sta_data_size)
+ * in the structure for use by driver. This structure is places in that
+ * space.
+ *
+ * The common struct MUST be first because it is shared between
+ * 3945 and 4965!
+ */
+struct il_station_priv {
+	struct il_station_priv_common common;
+	struct il_lq_sta lq_sta;
+	atomic_t pending_frames;
+	bool client;
+	bool asleep;
+};
+
+static inline u8 il4965_num_of_ant(u8 m)
+{
+	return !!(m & ANT_A) + !!(m & ANT_B) + !!(m & ANT_C);
+}
+
+static inline u8 il4965_first_antenna(u8 mask)
+{
+	if (mask & ANT_A)
+		return ANT_A;
+	if (mask & ANT_B)
+		return ANT_B;
+	return ANT_C;
+}
+
+
+/**
+ * il3945_rate_scale_init - Initialize the rate scale table based on assoc info
+ *
+ * The specific throughput table used is based on the type of network
+ * the associated with, including A, B, G, and G w/ TGG protection
+ */
+extern void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
+
+/* Initialize station's rate scaling information after adding station */
+extern void il4965_rs_rate_init(struct il_priv *il,
+			     struct ieee80211_sta *sta, u8 sta_id);
+extern void il3945_rs_rate_init(struct il_priv *il,
+				 struct ieee80211_sta *sta, u8 sta_id);
+
+/**
+ * il_rate_control_register - Register the rate control algorithm callbacks
+ *
+ * Since the rate control algorithm is hardware specific, there is no need
+ * or reason to place it as a stand alone module.  The driver can call
+ * il_rate_control_register in order to register the rate control callbacks
+ * with the mac80211 subsystem.  This should be performed prior to calling
+ * ieee80211_register_hw
+ *
+ */
+extern int il4965_rate_control_register(void);
+extern int il3945_rate_control_register(void);
+
+/**
+ * il_rate_control_unregister - Unregister the rate control callbacks
+ *
+ * This should be called after calling ieee80211_unregister_hw, but before
+ * the driver is unloaded.
+ */
+extern void il4965_rate_control_unregister(void);
+extern void il3945_rate_control_unregister(void);
+
 #endif /* __il_core_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
deleted file mode 100644
index 58e04cb..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ /dev/null
@@ -1,454 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __il_rs_h__
-#define __il_rs_h__
-
-struct il_rate_info {
-	u8 plcp;	/* uCode API:  RATE_6M_PLCP, etc. */
-	u8 plcp_siso;	/* uCode API:  RATE_SISO_6M_PLCP, etc. */
-	u8 plcp_mimo2;	/* uCode API:  RATE_MIMO2_6M_PLCP, etc. */
-	u8 ieee;	/* MAC header:  RATE_6M_IEEE, etc. */
-	u8 prev_ieee;    /* previous rate in IEEE speeds */
-	u8 next_ieee;    /* next rate in IEEE speeds */
-	u8 prev_rs;      /* previous rate used in rs algo */
-	u8 next_rs;      /* next rate used in rs algo */
-	u8 prev_rs_tgg;  /* previous rate used in TGG rs algo */
-	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
-};
-
-struct il3945_rate_info {
-	u8 plcp;		/* uCode API:  RATE_6M_PLCP, etc. */
-	u8 ieee;		/* MAC header:  RATE_6M_IEEE, etc. */
-	u8 prev_ieee;		/* previous rate in IEEE speeds */
-	u8 next_ieee;		/* next rate in IEEE speeds */
-	u8 prev_rs;		/* previous rate used in rs algo */
-	u8 next_rs;		/* next rate used in rs algo */
-	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
-	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
-	u8 table_rs_idx;	/* idx in rate scale table cmd */
-	u8 prev_table_rs;	/* prev in rate table cmd */
-};
-
-
-/*
- * These serve as idxes into
- * struct il_rate_info il_rates[RATE_COUNT];
- */
-enum {
-	RATE_1M_IDX = 0,
-	RATE_2M_IDX,
-	RATE_5M_IDX,
-	RATE_11M_IDX,
-	RATE_6M_IDX,
-	RATE_9M_IDX,
-	RATE_12M_IDX,
-	RATE_18M_IDX,
-	RATE_24M_IDX,
-	RATE_36M_IDX,
-	RATE_48M_IDX,
-	RATE_54M_IDX,
-	RATE_60M_IDX,
-	RATE_COUNT,
-	RATE_COUNT_LEGACY = RATE_COUNT - 1,	/* Excluding 60M */
-	RATE_COUNT_3945 = RATE_COUNT - 1,
-	RATE_INVM_IDX = RATE_COUNT,
-	RATE_INVALID = RATE_COUNT,
-};
-
-enum {
-	RATE_6M_IDX_TBL = 0,
-	RATE_9M_IDX_TBL,
-	RATE_12M_IDX_TBL,
-	RATE_18M_IDX_TBL,
-	RATE_24M_IDX_TBL,
-	RATE_36M_IDX_TBL,
-	RATE_48M_IDX_TBL,
-	RATE_54M_IDX_TBL,
-	RATE_1M_IDX_TBL,
-	RATE_2M_IDX_TBL,
-	RATE_5M_IDX_TBL,
-	RATE_11M_IDX_TBL,
-	RATE_INVM_IDX_TBL = RATE_INVM_IDX - 1,
-};
-
-enum {
-	IL_FIRST_OFDM_RATE = RATE_6M_IDX,
-	IL39_LAST_OFDM_RATE = RATE_54M_IDX,
-	IL_LAST_OFDM_RATE = RATE_60M_IDX,
-	IL_FIRST_CCK_RATE = RATE_1M_IDX,
-	IL_LAST_CCK_RATE = RATE_11M_IDX,
-};
-
-/* #define vs. enum to keep from defaulting to 'large integer' */
-#define	RATE_6M_MASK   (1 << RATE_6M_IDX)
-#define	RATE_9M_MASK   (1 << RATE_9M_IDX)
-#define	RATE_12M_MASK  (1 << RATE_12M_IDX)
-#define	RATE_18M_MASK  (1 << RATE_18M_IDX)
-#define	RATE_24M_MASK  (1 << RATE_24M_IDX)
-#define	RATE_36M_MASK  (1 << RATE_36M_IDX)
-#define	RATE_48M_MASK  (1 << RATE_48M_IDX)
-#define	RATE_54M_MASK  (1 << RATE_54M_IDX)
-#define RATE_60M_MASK  (1 << RATE_60M_IDX)
-#define	RATE_1M_MASK   (1 << RATE_1M_IDX)
-#define	RATE_2M_MASK   (1 << RATE_2M_IDX)
-#define	RATE_5M_MASK   (1 << RATE_5M_IDX)
-#define	RATE_11M_MASK  (1 << RATE_11M_IDX)
-
-/* uCode API values for legacy bit rates, both OFDM and CCK */
-enum {
-	RATE_6M_PLCP  = 13,
-	RATE_9M_PLCP  = 15,
-	RATE_12M_PLCP = 5,
-	RATE_18M_PLCP = 7,
-	RATE_24M_PLCP = 9,
-	RATE_36M_PLCP = 11,
-	RATE_48M_PLCP = 1,
-	RATE_54M_PLCP = 3,
-	RATE_60M_PLCP = 3,/*FIXME:RS:should be removed*/
-	RATE_1M_PLCP  = 10,
-	RATE_2M_PLCP  = 20,
-	RATE_5M_PLCP  = 55,
-	RATE_11M_PLCP = 110,
-	/*FIXME:RS:add RATE_LEGACY_INVM_PLCP = 0,*/
-};
-
-/* uCode API values for OFDM high-throughput (HT) bit rates */
-enum {
-	RATE_SISO_6M_PLCP = 0,
-	RATE_SISO_12M_PLCP = 1,
-	RATE_SISO_18M_PLCP = 2,
-	RATE_SISO_24M_PLCP = 3,
-	RATE_SISO_36M_PLCP = 4,
-	RATE_SISO_48M_PLCP = 5,
-	RATE_SISO_54M_PLCP = 6,
-	RATE_SISO_60M_PLCP = 7,
-	RATE_MIMO2_6M_PLCP  = 0x8,
-	RATE_MIMO2_12M_PLCP = 0x9,
-	RATE_MIMO2_18M_PLCP = 0xa,
-	RATE_MIMO2_24M_PLCP = 0xb,
-	RATE_MIMO2_36M_PLCP = 0xc,
-	RATE_MIMO2_48M_PLCP = 0xd,
-	RATE_MIMO2_54M_PLCP = 0xe,
-	RATE_MIMO2_60M_PLCP = 0xf,
-	RATE_SISO_INVM_PLCP,
-	RATE_MIMO2_INVM_PLCP = RATE_SISO_INVM_PLCP,
-};
-
-/* MAC header values for bit rates */
-enum {
-	RATE_6M_IEEE  = 12,
-	RATE_9M_IEEE  = 18,
-	RATE_12M_IEEE = 24,
-	RATE_18M_IEEE = 36,
-	RATE_24M_IEEE = 48,
-	RATE_36M_IEEE = 72,
-	RATE_48M_IEEE = 96,
-	RATE_54M_IEEE = 108,
-	RATE_60M_IEEE = 120,
-	RATE_1M_IEEE  = 2,
-	RATE_2M_IEEE  = 4,
-	RATE_5M_IEEE  = 11,
-	RATE_11M_IEEE = 22,
-};
-
-#define IL_CCK_BASIC_RATES_MASK    \
-	(RATE_1M_MASK          | \
-	RATE_2M_MASK)
-
-#define IL_CCK_RATES_MASK          \
-	(IL_CCK_BASIC_RATES_MASK  | \
-	RATE_5M_MASK          | \
-	RATE_11M_MASK)
-
-#define IL_OFDM_BASIC_RATES_MASK   \
-	(RATE_6M_MASK         | \
-	RATE_12M_MASK         | \
-	RATE_24M_MASK)
-
-#define IL_OFDM_RATES_MASK         \
-	(IL_OFDM_BASIC_RATES_MASK | \
-	RATE_9M_MASK          | \
-	RATE_18M_MASK         | \
-	RATE_36M_MASK         | \
-	RATE_48M_MASK         | \
-	RATE_54M_MASK)
-
-#define IL_BASIC_RATES_MASK         \
-	(IL_OFDM_BASIC_RATES_MASK | \
-	 IL_CCK_BASIC_RATES_MASK)
-
-#define RATES_MASK ((1 << RATE_COUNT) - 1)
-#define RATES_MASK_3945 ((1 << RATE_COUNT_3945) - 1)
-
-#define IL_INVALID_VALUE    -1
-
-#define IL_MIN_RSSI_VAL                 -100
-#define IL_MAX_RSSI_VAL                    0
-
-/* These values specify how many Tx frame attempts before
- * searching for a new modulation mode */
-#define IL_LEGACY_FAILURE_LIMIT	160
-#define IL_LEGACY_SUCCESS_LIMIT	480
-#define IL_LEGACY_TBL_COUNT		160
-
-#define IL_NONE_LEGACY_FAILURE_LIMIT	400
-#define IL_NONE_LEGACY_SUCCESS_LIMIT	4500
-#define IL_NONE_LEGACY_TBL_COUNT	1500
-
-/* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
-#define IL_RS_GOOD_RATIO		12800	/* 100% */
-#define RATE_SCALE_SWITCH		10880	/*  85% */
-#define RATE_HIGH_TH		10880	/*  85% */
-#define RATE_INCREASE_TH		6400	/*  50% */
-#define RATE_DECREASE_TH		1920	/*  15% */
-
-/* possible actions when in legacy mode */
-#define IL_LEGACY_SWITCH_ANTENNA1      0
-#define IL_LEGACY_SWITCH_ANTENNA2      1
-#define IL_LEGACY_SWITCH_SISO          2
-#define IL_LEGACY_SWITCH_MIMO2_AB      3
-#define IL_LEGACY_SWITCH_MIMO2_AC      4
-#define IL_LEGACY_SWITCH_MIMO2_BC      5
-
-/* possible actions when in siso mode */
-#define IL_SISO_SWITCH_ANTENNA1        0
-#define IL_SISO_SWITCH_ANTENNA2        1
-#define IL_SISO_SWITCH_MIMO2_AB        2
-#define IL_SISO_SWITCH_MIMO2_AC        3
-#define IL_SISO_SWITCH_MIMO2_BC        4
-#define IL_SISO_SWITCH_GI              5
-
-/* possible actions when in mimo mode */
-#define IL_MIMO2_SWITCH_ANTENNA1       0
-#define IL_MIMO2_SWITCH_ANTENNA2       1
-#define IL_MIMO2_SWITCH_SISO_A         2
-#define IL_MIMO2_SWITCH_SISO_B         3
-#define IL_MIMO2_SWITCH_SISO_C         4
-#define IL_MIMO2_SWITCH_GI             5
-
-#define IL_MAX_SEARCH IL_MIMO2_SWITCH_GI
-
-#define IL_ACTION_LIMIT		3	/* # possible actions */
-
-#define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
-
-/* load per tid defines for A-MPDU activation */
-#define IL_AGG_TPT_THREHOLD	0
-#define IL_AGG_LOAD_THRESHOLD	10
-#define IL_AGG_ALL_TID		0xff
-#define TID_QUEUE_CELL_SPACING	50	/*mS */
-#define TID_QUEUE_MAX_SIZE	20
-#define TID_ROUND_VALUE		5	/* mS */
-#define TID_MAX_LOAD_COUNT	8
-
-#define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
-#define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
-
-extern const struct il_rate_info il_rates[RATE_COUNT];
-
-enum il_table_type {
-	LQ_NONE,
-	LQ_G,		/* legacy types */
-	LQ_A,
-	LQ_SISO,	/* high-throughput types */
-	LQ_MIMO2,
-	LQ_MAX,
-};
-
-#define is_legacy(tbl) ((tbl) == LQ_G || (tbl) == LQ_A)
-#define is_siso(tbl) ((tbl) == LQ_SISO)
-#define is_mimo2(tbl) ((tbl) == LQ_MIMO2)
-#define is_mimo(tbl) (is_mimo2(tbl))
-#define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
-#define is_a_band(tbl) ((tbl) == LQ_A)
-#define is_g_and(tbl) ((tbl) == LQ_G)
-
-#define	ANT_NONE	0x0
-#define	ANT_A		BIT(0)
-#define	ANT_B		BIT(1)
-#define	ANT_AB		(ANT_A | ANT_B)
-#define ANT_C		BIT(2)
-#define	ANT_AC		(ANT_A | ANT_C)
-#define ANT_BC		(ANT_B | ANT_C)
-#define ANT_ABC		(ANT_AB | ANT_C)
-
-#define IL_MAX_MCS_DISPLAY_SIZE	12
-
-struct il_rate_mcs_info {
-	char	mbps[IL_MAX_MCS_DISPLAY_SIZE];
-	char	mcs[IL_MAX_MCS_DISPLAY_SIZE];
-};
-
-/**
- * struct il_rate_scale_data -- tx success history for one rate
- */
-struct il_rate_scale_data {
-	u64 data;		/* bitmap of successful frames */
-	s32 success_counter;	/* number of frames successful */
-	s32 success_ratio;	/* per-cent * 128  */
-	s32 counter;		/* number of frames attempted */
-	s32 average_tpt;	/* success ratio * expected throughput */
-	unsigned long stamp;
-};
-
-/**
- * struct il_scale_tbl_info -- tx params and success history for all rates
- *
- * There are two of these in struct il_lq_sta,
- * one for "active", and one for "search".
- */
-struct il_scale_tbl_info {
-	enum il_table_type lq_type;
-	u8 ant_type;
-	u8 is_SGI;	/* 1 = short guard interval */
-	u8 is_ht40;	/* 1 = 40 MHz channel width */
-	u8 is_dup;	/* 1 = duplicated data streams */
-	u8 action;	/* change modulation; IL_[LEGACY/SISO/MIMO]_SWITCH_* */
-	u8 max_search;	/* maximun number of tables we can search */
-	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
-	u32 current_rate;  /* rate_n_flags, uCode API format */
-	struct il_rate_scale_data win[RATE_COUNT]; /* rate histories */
-};
-
-struct il_traffic_load {
-	unsigned long time_stamp;	/* age of the oldest stats */
-	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
-						 * slice */
-	u32 total;			/* total num of packets during the
-					 * last TID_MAX_TIME_DIFF */
-	u8 queue_count;			/* number of queues that has
-					 * been used since the last cleanup */
-	u8 head;			/* start of the circular buffer */
-};
-
-/**
- * struct il_lq_sta -- driver's rate scaling ilate structure
- *
- * Pointer to this gets passed back and forth between driver and mac80211.
- */
-struct il_lq_sta {
-	u8 active_tbl;		/* idx of active table, range 0-1 */
-	u8 enable_counter;	/* indicates HT mode */
-	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
-	u8 search_better_tbl;	/* 1: currently trying alternate mode */
-	s32 last_tpt;
-
-	/* The following determine when to search for a new mode */
-	u32 table_count_limit;
-	u32 max_failure_limit;	/* # failed frames before new search */
-	u32 max_success_limit;	/* # successful frames before new search */
-	u32 table_count;
-	u32 total_failed;	/* total failed frames, any/all rates */
-	u32 total_success;	/* total successful frames, any/all rates */
-	u64 flush_timer;	/* time staying in mode before new search */
-
-	u8 action_counter;	/* # mode-switch actions tried */
-	u8 is_green;
-	u8 is_dup;
-	enum ieee80211_band band;
-
-	/* The following are bitmaps of rates; RATE_6M_MASK, etc. */
-	u32 supp_rates;
-	u16 active_legacy_rate;
-	u16 active_siso_rate;
-	u16 active_mimo2_rate;
-	s8 max_rate_idx;     /* Max rate set by user */
-	u8 missed_rate_counter;
-
-	struct il_link_quality_cmd lq;
-	struct il_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
-	struct il_traffic_load load[TID_MAX_LOAD_COUNT];
-	u8 tx_agg_tid_en;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_scale_table_file;
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
-	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
-	u32 dbg_fixed_rate;
-#endif
-	struct il_priv *drv;
-
-	/* used to be in sta_info */
-	int last_txrate_idx;
-	/* last tx rate_n_flags */
-	u32 last_rate_n_flags;
-	/* packets destined for this STA are aggregated */
-	u8 is_agg;
-};
-
-static inline u8 il4965_num_of_ant(u8 m)
-{
-	return !!(m & ANT_A) + !!(m & ANT_B) + !!(m & ANT_C);
-}
-
-static inline u8 il4965_first_antenna(u8 mask)
-{
-	if (mask & ANT_A)
-		return ANT_A;
-	if (mask & ANT_B)
-		return ANT_B;
-	return ANT_C;
-}
-
-
-/**
- * il3945_rate_scale_init - Initialize the rate scale table based on assoc info
- *
- * The specific throughput table used is based on the type of network
- * the associated with, including A, B, G, and G w/ TGG protection
- */
-extern void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
-
-/* Initialize station's rate scaling information after adding station */
-extern void il4965_rs_rate_init(struct il_priv *il,
-			     struct ieee80211_sta *sta, u8 sta_id);
-extern void il3945_rs_rate_init(struct il_priv *il,
-				 struct ieee80211_sta *sta, u8 sta_id);
-
-/**
- * il_rate_control_register - Register the rate control algorithm callbacks
- *
- * Since the rate control algorithm is hardware specific, there is no need
- * or reason to place it as a stand alone module.  The driver can call
- * il_rate_control_register in order to register the rate control callbacks
- * with the mac80211 subsystem.  This should be performed prior to calling
- * ieee80211_register_hw
- *
- */
-extern int il4965_rate_control_register(void);
-extern int il3945_rate_control_register(void);
-
-/**
- * il_rate_control_unregister - Unregister the rate control callbacks
- *
- * This should be called after calling ieee80211_unregister_hw, but before
- * the driver is unloaded.
- */
-extern void il4965_rate_control_unregister(void);
-extern void il3945_rate_control_unregister(void);
-
-#endif /* __il_rs__ */
-- 
1.7.1

