Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYLSCpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:12 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/43] iwl3945: Use iwl-agn-rs.h rates definitions.
Date: Fri, 19 Dec 2008 10:37:12 +0800
Message-Id: <1229654263-21454-13-git-send-email-yi.zhu@intel.com> (sfid-20081219_034535_728759_F2DC31EE)
In-Reply-To: <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

A lot of rate relates definition are shared between iwl-3945-rs.h and
iwl-agn-rs.h. Let's just use the agn version, and add the 3945 specific
constants there.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   45 +++---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |  206 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |   53 +++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 6 files changed, 80 insertions(+), 234 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index a42c0b5..295bd26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -64,7 +64,7 @@ struct iwl3945_rs_sta {
 	u8 start_rate;
 	u8 ibss_sta_added;
 	struct timer_list rate_scale_flush;
-	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT];
+	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT_3945];
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_stats_table_file;
 #endif
@@ -73,19 +73,19 @@ struct iwl3945_rs_sta {
 	int last_txrate_idx;
 };
 
-static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 76, 104, 130, 168, 191, 202
 };
 
-static s32 iwl3945_expected_tpt_g_prot[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_g_prot[IWL_RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 0, 80, 93, 113, 123, 125
 };
 
-static s32 iwl3945_expected_tpt_a[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_a[IWL_RATE_COUNT_3945] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186
 };
 
-static s32 iwl3945_expected_tpt_b[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_b[IWL_RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
@@ -121,7 +121,7 @@ static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
 #define IWL_RATE_MAX_WINDOW          62
 #define IWL_RATE_FLUSH       	 (3*HZ)
 #define IWL_RATE_WIN_FLUSH       (HZ/2)
-#define IWL_RATE_HIGH_TH          11520
+#define IWL39_RATE_HIGH_TH          11520
 #define IWL_SUCCESS_UP_TH	   8960
 #define IWL_SUCCESS_DOWN_TH	  10880
 #define IWL_RATE_MIN_FAILURE_TH       8
@@ -167,7 +167,7 @@ static void iwl3945_clear_window(struct iwl3945_rate_scale_data *window)
 	window->success_counter = 0;
 	window->success_ratio = -1;
 	window->counter = 0;
-	window->average_tpt = IWL_INV_TPT;
+	window->average_tpt = IWL_INVALID_VALUE;
 	window->stamp = 0;
 }
 
@@ -190,7 +190,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 	 * and it has been more than IWL_RATE_WIN_FLUSH
 	 * since we flushed, clear out the gathered statistics
 	 */
-	for (i = 0; i < IWL_RATE_COUNT; i++) {
+	for (i = 0; i < IWL_RATE_COUNT_3945; i++) {
 		if (!rs_sta->win[i].counter)
 			continue;
 
@@ -334,7 +334,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 		window->average_tpt = ((window->success_ratio *
 				rs_sta->expected_tpt[index] + 64) / 128);
 	else
-		window->average_tpt = IWL_INV_TPT;
+		window->average_tpt = IWL_INVALID_VALUE;
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
@@ -425,7 +425,7 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
 	rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
 
-	for (i = 0; i < IWL_RATE_COUNT; i++)
+	for (i = 0; i < IWL_RATE_COUNT_3945; i++)
 		iwl3945_clear_window(&rs_sta->win[i]);
 
 	IWL_DEBUG_RATE("leave\n");
@@ -471,7 +471,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 	retries = info->status.rates[0].count;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
-	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
+	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT_3945)) {
 		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
@@ -575,7 +575,8 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 
 		/* Find the next rate that is in the rate mask */
 		i = index + 1;
-		for (mask = (1 << i); i < IWL_RATE_COUNT; i++, mask <<= 1) {
+		for (mask = (1 << i); i < IWL_RATE_COUNT_3945;
+		     i++, mask <<= 1) {
 			if (rate_mask & mask) {
 				high = i;
 				break;
@@ -641,9 +642,9 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	int index;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct iwl3945_rate_scale_data *window = NULL;
-	int current_tpt = IWL_INV_TPT;
-	int low_tpt = IWL_INV_TPT;
-	int high_tpt = IWL_INV_TPT;
+	int current_tpt = IWL_INVALID_VALUE;
+	int low_tpt = IWL_INVALID_VALUE;
+	int high_tpt = IWL_INVALID_VALUE;
 	u32 fail_count;
 	s8 scale_action = 0;
 	unsigned long flags;
@@ -667,7 +668,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	}
 
 	rate_mask = sta->supp_rates[sband->band];
-	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
+	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT_3945 - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
@@ -737,16 +738,18 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
-	} else if ((low_tpt == IWL_INV_TPT) && (high_tpt == IWL_INV_TPT))
+	} else if ((low_tpt == IWL_INVALID_VALUE) &&
+		   (high_tpt == IWL_INVALID_VALUE))
 		scale_action = 1;
-	else if ((low_tpt != IWL_INV_TPT) && (high_tpt != IWL_INV_TPT) &&
+	else if ((low_tpt != IWL_INVALID_VALUE) &&
+		 (high_tpt != IWL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
 		IWL_DEBUG_RATE("No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
 			       low_tpt, high_tpt, current_tpt);
 		scale_action = 0;
 	} else {
-		if (high_tpt != IWL_INV_TPT) {
+		if (high_tpt != IWL_INVALID_VALUE) {
 			if (high_tpt > current_tpt)
 				scale_action = 1;
 			else {
@@ -754,7 +757,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 				    ("decrease rate because of high tpt\n");
 				scale_action = -1;
 			}
-		} else if (low_tpt != IWL_INV_TPT) {
+		} else if (low_tpt != IWL_INVALID_VALUE) {
 			if (low_tpt > current_tpt) {
 				IWL_DEBUG_RATE
 				    ("decrease rate because of low tpt\n");
@@ -828,7 +831,7 @@ static ssize_t iwl3945_sta_dbgfs_stats_table_read(struct file *file,
 			lq_sta->tx_packets,
 			lq_sta->last_txrate_idx,
 			lq_sta->start_rate, jiffies_to_msecs(lq_sta->flush_time));
-	for (j = 0; j < IWL_RATE_COUNT; j++) {
+	for (j = 0; j < IWL_RATE_COUNT_3945; j++) {
 		desc += sprintf(buff+desc,
 				"counter=%d success=%d %%=%d\n",
 				lq_sta->win[j].counter,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
deleted file mode 100644
index b5a6613..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ /dev/null
@@ -1,206 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
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
-#ifndef __iwl_3945_rs_h__
-#define __iwl_3945_rs_h__
-
-struct iwl3945_rate_info {
-	u8 plcp;		/* uCode API:  IWL_RATE_6M_PLCP, etc. */
-	u8 ieee;		/* MAC header:  IWL_RATE_6M_IEEE, etc. */
-	u8 prev_ieee;		/* previous rate in IEEE speeds */
-	u8 next_ieee;		/* next rate in IEEE speeds */
-	u8 prev_rs;		/* previous rate used in rs algo */
-	u8 next_rs;		/* next rate used in rs algo */
-	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
-	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
-	u8 table_rs_index;	/* index in rate scale table cmd */
-	u8 prev_table_rs;	/* prev in rate table cmd */
-};
-
-/*
- * These serve as indexes into
- * struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
- */
-enum {
-	IWL_RATE_1M_INDEX = 0,
-	IWL_RATE_2M_INDEX,
-	IWL_RATE_5M_INDEX,
-	IWL_RATE_11M_INDEX,
-	IWL_RATE_6M_INDEX,
-	IWL_RATE_9M_INDEX,
-	IWL_RATE_12M_INDEX,
-	IWL_RATE_18M_INDEX,
-	IWL_RATE_24M_INDEX,
-	IWL_RATE_36M_INDEX,
-	IWL_RATE_48M_INDEX,
-	IWL_RATE_54M_INDEX,
-	IWL_RATE_COUNT,
-	IWL_RATE_INVM_INDEX,
-	IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
-};
-
-enum {
-	IWL_RATE_6M_INDEX_TABLE = 0,
-	IWL_RATE_9M_INDEX_TABLE,
-	IWL_RATE_12M_INDEX_TABLE,
-	IWL_RATE_18M_INDEX_TABLE,
-	IWL_RATE_24M_INDEX_TABLE,
-	IWL_RATE_36M_INDEX_TABLE,
-	IWL_RATE_48M_INDEX_TABLE,
-	IWL_RATE_54M_INDEX_TABLE,
-	IWL_RATE_1M_INDEX_TABLE,
-	IWL_RATE_2M_INDEX_TABLE,
-	IWL_RATE_5M_INDEX_TABLE,
-	IWL_RATE_11M_INDEX_TABLE,
-	IWL_RATE_INVM_INDEX_TABLE = IWL_RATE_INVM_INDEX,
-};
-
-enum {
-	IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
-	IWL_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
-	IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
-	IWL_LAST_CCK_RATE = IWL_RATE_11M_INDEX,
-};
-
-/* #define vs. enum to keep from defaulting to 'large integer' */
-#define	IWL_RATE_6M_MASK   (1 << IWL_RATE_6M_INDEX)
-#define	IWL_RATE_9M_MASK   (1 << IWL_RATE_9M_INDEX)
-#define	IWL_RATE_12M_MASK  (1 << IWL_RATE_12M_INDEX)
-#define	IWL_RATE_18M_MASK  (1 << IWL_RATE_18M_INDEX)
-#define	IWL_RATE_24M_MASK  (1 << IWL_RATE_24M_INDEX)
-#define	IWL_RATE_36M_MASK  (1 << IWL_RATE_36M_INDEX)
-#define	IWL_RATE_48M_MASK  (1 << IWL_RATE_48M_INDEX)
-#define	IWL_RATE_54M_MASK  (1 << IWL_RATE_54M_INDEX)
-#define	IWL_RATE_1M_MASK   (1 << IWL_RATE_1M_INDEX)
-#define	IWL_RATE_2M_MASK   (1 << IWL_RATE_2M_INDEX)
-#define	IWL_RATE_5M_MASK   (1 << IWL_RATE_5M_INDEX)
-#define	IWL_RATE_11M_MASK  (1 << IWL_RATE_11M_INDEX)
-
-/* 3945 uCode API values for (legacy) bit rates, both OFDM and CCK */
-enum {
-	IWL_RATE_6M_PLCP = 13,
-	IWL_RATE_9M_PLCP = 15,
-	IWL_RATE_12M_PLCP = 5,
-	IWL_RATE_18M_PLCP = 7,
-	IWL_RATE_24M_PLCP = 9,
-	IWL_RATE_36M_PLCP = 11,
-	IWL_RATE_48M_PLCP = 1,
-	IWL_RATE_54M_PLCP = 3,
-	IWL_RATE_1M_PLCP = 10,
-	IWL_RATE_2M_PLCP = 20,
-	IWL_RATE_5M_PLCP = 55,
-	IWL_RATE_11M_PLCP = 110,
-};
-
-/* MAC header values for bit rates */
-enum {
-	IWL_RATE_6M_IEEE = 12,
-	IWL_RATE_9M_IEEE = 18,
-	IWL_RATE_12M_IEEE = 24,
-	IWL_RATE_18M_IEEE = 36,
-	IWL_RATE_24M_IEEE = 48,
-	IWL_RATE_36M_IEEE = 72,
-	IWL_RATE_48M_IEEE = 96,
-	IWL_RATE_54M_IEEE = 108,
-	IWL_RATE_1M_IEEE = 2,
-	IWL_RATE_2M_IEEE = 4,
-	IWL_RATE_5M_IEEE = 11,
-	IWL_RATE_11M_IEEE = 22,
-};
-
-#define IWL_CCK_BASIC_RATES_MASK    \
-       (IWL_RATE_1M_MASK          | \
-	IWL_RATE_2M_MASK)
-
-#define IWL_CCK_RATES_MASK          \
-       (IWL_BASIC_RATES_MASK      | \
-	IWL_RATE_5M_MASK          | \
-	IWL_RATE_11M_MASK)
-
-#define IWL_OFDM_BASIC_RATES_MASK   \
-	(IWL_RATE_6M_MASK         | \
-	IWL_RATE_12M_MASK         | \
-	IWL_RATE_24M_MASK)
-
-#define IWL_OFDM_RATES_MASK         \
-       (IWL_OFDM_BASIC_RATES_MASK | \
-	IWL_RATE_9M_MASK          | \
-	IWL_RATE_18M_MASK         | \
-	IWL_RATE_36M_MASK         | \
-	IWL_RATE_48M_MASK         | \
-	IWL_RATE_54M_MASK)
-
-#define IWL_BASIC_RATES_MASK         \
-	(IWL_OFDM_BASIC_RATES_MASK | \
-	 IWL_CCK_BASIC_RATES_MASK)
-
-#define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
-
-#define IWL_INV_TPT    -1
-
-#define IWL_MIN_RSSI_VAL                 -100
-#define IWL_MAX_RSSI_VAL                    0
-
-extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
-
-static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
-{
-	u8 rate = iwl3945_rates[rate_index].prev_ieee;
-
-	if (rate == IWL_RATE_INVALID)
-		rate = rate_index;
-	return rate;
-}
-
-/**
- * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
- *
- * The specific throughput table used is based on the type of network
- * the associated with, including A, B, G, and G w/ TGG protection
- */
-extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
-
-/**
- * iwl3945_rate_control_register - Register the rate control algorithm callbacks
- *
- * Since the rate control algorithm is hardware specific, there is no need
- * or reason to place it as a stand alone module.  The driver can call
- * iwl3945_rate_control_register in order to register the rate control callbacks
- * with the mac80211 subsystem.  This should be performed prior to calling
- * ieee80211_register_hw
- *
- */
-extern int iwl3945_rate_control_register(void);
-
-/**
- * iwl3945_rate_control_unregister - Unregister the rate control callbacks
- *
- * This should be called after calling ieee80211_unregister_hw, but before
- * the driver is unloaded.
- */
-extern void iwl3945_rate_control_unregister(void);
-
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4455475..538bbfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -43,7 +43,7 @@
 #include "iwl-commands.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
-#include "iwl-3945-rs.h"
+#include "iwl-agn-rs.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,   \
@@ -65,7 +65,7 @@
  * maps to IWL_RATE_INVALID
  *
  */
-const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT] = {
+const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945] = {
 	IWL_DECLARE_RATE_INFO(1, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IWL_DECLARE_RATE_INFO(2, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IWL_DECLARE_RATE_INFO(5, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -1701,7 +1701,7 @@ int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
 	/* fill cmd with power settings for all rates for current channel */
 	/* Fill OFDM rate */
 	for (rate_idx = IWL_FIRST_OFDM_RATE, i = 0;
-	     rate_idx <= IWL_LAST_OFDM_RATE; rate_idx++, i++) {
+	     rate_idx <= IWL39_LAST_OFDM_RATE; rate_idx++, i++) {
 
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = iwl3945_rates[rate_idx].plcp;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 3295244..6d0ec0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -233,7 +233,7 @@ struct iwl3945_clip_group {
 	const s8 clip_powers[IWL_MAX_RATES];
 };
 
-#include "iwl-3945-rs.h"
+#include "iwl-agn-rs.h"
 
 #define IWL_TX_FIFO_AC0	0
 #define IWL_TX_FIFO_AC1	1
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 78ee83a..7c21292 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -27,8 +27,6 @@
 #ifndef __iwl_agn_rs_h__
 #define __iwl_agn_rs_h__
 
-#include "iwl-dev.h"
-
 struct iwl_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
@@ -43,6 +41,19 @@ struct iwl_rate_info {
 	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
 };
 
+struct iwl3945_rate_info {
+	u8 plcp;		/* uCode API:  IWL_RATE_6M_PLCP, etc. */
+	u8 ieee;		/* MAC header:  IWL_RATE_6M_IEEE, etc. */
+	u8 prev_ieee;		/* previous rate in IEEE speeds */
+	u8 next_ieee;		/* next rate in IEEE speeds */
+	u8 prev_rs;		/* previous rate used in rs algo */
+	u8 next_rs;		/* next rate used in rs algo */
+	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
+	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
+	u8 table_rs_index;	/* index in rate scale table cmd */
+	u8 prev_table_rs;	/* prev in rate table cmd */
+};
+
 /*
  * These serve as indexes into
  * struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
@@ -62,12 +73,30 @@ enum {
 	IWL_RATE_54M_INDEX,
 	IWL_RATE_60M_INDEX,
 	IWL_RATE_COUNT, /*FIXME:RS:change to IWL_RATE_INDEX_COUNT,*/
+	IWL_RATE_COUNT_3945 = IWL_RATE_COUNT - 1,
 	IWL_RATE_INVM_INDEX = IWL_RATE_COUNT,
 	IWL_RATE_INVALID = IWL_RATE_COUNT,
 };
 
 enum {
+	IWL_RATE_6M_INDEX_TABLE = 0,
+	IWL_RATE_9M_INDEX_TABLE,
+	IWL_RATE_12M_INDEX_TABLE,
+	IWL_RATE_18M_INDEX_TABLE,
+	IWL_RATE_24M_INDEX_TABLE,
+	IWL_RATE_36M_INDEX_TABLE,
+	IWL_RATE_48M_INDEX_TABLE,
+	IWL_RATE_54M_INDEX_TABLE,
+	IWL_RATE_1M_INDEX_TABLE,
+	IWL_RATE_2M_INDEX_TABLE,
+	IWL_RATE_5M_INDEX_TABLE,
+	IWL_RATE_11M_INDEX_TABLE,
+	IWL_RATE_INVM_INDEX_TABLE = IWL_RATE_INVM_INDEX - 1,
+};
+
+enum {
 	IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
+	IWL39_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
 	IWL_LAST_OFDM_RATE = IWL_RATE_60M_INDEX,
 	IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
 	IWL_LAST_CCK_RATE = IWL_RATE_11M_INDEX,
@@ -248,6 +277,7 @@ enum {
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
 extern const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
+extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945];
 
 enum iwl_table_type {
 	LQ_NONE,
@@ -303,6 +333,23 @@ static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
 	return rate;
 }
 
+static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
+{
+	u8 rate = iwl3945_rates[rate_index].prev_ieee;
+
+	if (rate == IWL_RATE_INVALID)
+		rate = rate_index;
+	return rate;
+}
+
+/**
+ * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
+ *
+ * The specific throughput table used is based on the type of network
+ * the associated with, including A, B, G, and G w/ TGG protection
+ */
+extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
+
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
  *
@@ -314,6 +361,7 @@ static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
  *
  */
 extern int iwlagn_rate_control_register(void);
+extern int iwl3945_rate_control_register(void);
 
 /**
  * iwl_rate_control_unregister - Unregister the rate control callbacks
@@ -322,5 +370,6 @@ extern int iwlagn_rate_control_register(void);
  * the driver is unloaded.
  */
 extern void iwlagn_rate_control_unregister(void);
+extern void iwl3945_rate_control_unregister(void);
 
 #endif /* __iwl_agn__rs__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8c2d30d..ee77066 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4853,7 +4853,7 @@ static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
-		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
+		if ((i > IWL39_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
 			/*
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
-- 
1.5.3.6

