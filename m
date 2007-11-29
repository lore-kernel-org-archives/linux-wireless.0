Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbXK2DLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 32/36] iwlwifi: document 4965 rate scaling
Date: Thu, 29 Nov 2007 11:10:12 +0800
Message-Id: <1196305816-23023-33-git-send-email-yi.zhu@intel.com> (sfid-20071129_033536_883496_95DB4E2F)
In-Reply-To: <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-28-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-29-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-30-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-31-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document 4965 rate scaling

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  251 +++++++++++++++++++++-
 1 files changed, 247 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index cbe91db..7988c75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1322,6 +1322,8 @@ struct iwl4965_compressed_ba_resp {
 
 /*
  * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
+ *
+ * See details under "TXPOWER" in iwl-4965-hw.h.
  */
 struct iwl4965_txpowertable_cmd {
 	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
@@ -1333,39 +1335,280 @@ struct iwl4965_txpowertable_cmd {
 /*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
 #define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1<<0)
 
+/* # of EDCA prioritized tx fifos */
 #define  LINK_QUAL_AC_NUM AC_NUM
+
+/* # entries in rate scale table to support Tx retries */
 #define  LINK_QUAL_MAX_RETRY_NUM 16
 
+/* Tx antenna selection values */
 #define  LINK_QUAL_ANT_A_MSK (1<<0)
 #define  LINK_QUAL_ANT_B_MSK (1<<1)
 #define  LINK_QUAL_ANT_MSK   (LINK_QUAL_ANT_A_MSK|LINK_QUAL_ANT_B_MSK)
 
+
+/**
+ * struct iwl4965_link_qual_general_params
+ *
+ * Used in REPLY_TX_LINK_QUALITY_CMD
+ */
 struct iwl4965_link_qual_general_params {
 	u8 flags;
+
+	/* No entries at or above this (driver chosen) index contain MIMO */
 	u8 mimo_delimiter;
-	u8 single_stream_ant_msk;
-	u8 dual_stream_ant_msk;
+
+	/* Best single antenna to use for single stream (legacy, SISO). */
+	u8 single_stream_ant_msk;	/* LINK_QUAL_ANT_* */
+
+	/* Best antennas to use for MIMO (unused for 4965, assumes both). */
+	u8 dual_stream_ant_msk;		/* LINK_QUAL_ANT_* */
+
+	/*
+	 * If driver needs to use different initial rates for different
+	 * EDCA QOS access categories (as implemented by tx fifos 0-3),
+	 * this table will set that up, by indicating the indexes in the
+	 * rs_table[LINK_QUAL_MAX_RETRY_NUM] rate table at which to start.
+	 * Otherwise, driver should set all entries to 0.
+	 *
+	 * Entry usage:
+	 * 0 = Background, 1 = Best Effort (normal), 2 = Video, 3 = Voice
+	 * TX FIFOs above 3 use same value (typically 0) as TX FIFO 3.
+	 */
 	u8 start_rate_index[LINK_QUAL_AC_NUM];
 } __attribute__ ((packed));
 
+/**
+ * struct iwl4965_link_qual_agg_params
+ *
+ * Used in REPLY_TX_LINK_QUALITY_CMD
+ */
 struct iwl4965_link_qual_agg_params {
+
+	/* Maximum number of uSec in aggregation.
+	 * Driver should set this to 4000 (4 milliseconds). */
 	__le16 agg_time_limit;
+
+	/*
+	 * Number of Tx retries allowed for a frame, before that frame will
+	 * no longer be considered for the start of an aggregation sequence
+	 * (scheduler will then try to tx it as single frame).
+	 * Driver should set this to 3.
+	 */
 	u8 agg_dis_start_th;
+
+	/*
+	 * Maximum number of frames in aggregation.
+	 * 0 = no limit (default).  1 = no aggregation.
+	 * Other values = max # frames in aggregation.
+	 */
 	u8 agg_frame_cnt_limit;
+
 	__le32 reserved;
 } __attribute__ ((packed));
 
 /*
  * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
+ *
+ * For 4965 only; 3945 uses REPLY_RATE_SCALE.
+ *
+ * Each station in the 4965's internal station table has its own table of 16
+ * Tx rates and modulation modes (e.g. legacy/SISO/MIMO) for retrying Tx when
+ * an ACK is not received.  This command replaces the entire table for
+ * one station.
+ *
+ * NOTE:  Station must already be in 4965's station table.  Use REPLY_ADD_STA.
+ *
+ * The rate scaling procedures described below work well.  Of course, other
+ * procedures are possible, and may work better for particular environments.
+ *
+ *
+ * FILLING THE RATE TABLE
+ *
+ * Given a particular initial rate and mode, as determined by the rate
+ * scaling algorithm described below, the Linux driver uses the following
+ * formula to fill the rs_table[LINK_QUAL_MAX_RETRY_NUM] rate table in the
+ * Link Quality command:
+ *
+ *
+ * 1)  If using High-throughput (HT) (SISO or MIMO) initial rate:
+ *     a) Use this same initial rate for first 3 entries.
+ *     b) Find next lower available rate using same mode (SISO or MIMO),
+ *        use for next 3 entries.  If no lower rate available, switch to
+ *        legacy mode (no FAT channel, no MIMO, no short guard interval).
+ *     c) If using MIMO, set command's mimo_delimiter to number of entries
+ *        using MIMO (3 or 6).
+ *     d) After trying 2 HT rates, switch to legacy mode (no FAT channel,
+ *        no MIMO, no short guard interval), at the next lower bit rate
+ *        (e.g. if second HT bit rate was 54, try 48 legacy), and follow
+ *        legacy procedure for remaining table entries.
+ *
+ * 2)  If using legacy initial rate:
+ *     a) Use the initial rate for only one entry.
+ *     b) For each following entry, reduce the rate to next lower available
+ *        rate, until reaching the lowest available rate.
+ *     c) When reducing rate, also switch antenna selection.
+ *     d) Once lowest available rate is reached, repeat this rate until
+ *        rate table is filled (16 entries), switching antenna each entry.
+ *
+ *
+ * ACCUMULATING HISTORY
+ *
+ * The rate scaling algorithm for 4965, as implemented in Linux driver, uses
+ * two sets of frame Tx success history:  One for the current/active modulation
+ * mode, and one for a speculative/search mode that is being attempted.  If the
+ * speculative mode turns out to be more effective (i.e. actual transfer
+ * rate is better), then the driver continues to use the speculative mode
+ * as the new current active mode.
+ *
+ * Each history set contains, separately for each possible rate, data for a
+ * sliding window of the 62 most recent tx attempts at that rate.  The data
+ * includes a shifting bitmap of success(1)/failure(0), and sums of successful
+ * and attempted frames, from which the driver can additionally calculate a
+ * success ratio (success / attempted) and number of failures
+ * (attempted - success), and control the size of the window (attempted).
+ * The driver uses the bit map to remove successes from the success sum, as
+ * the oldest tx attempts fall out of the window.
+ *
+ * When the 4965 makes multiple tx attempts for a given frame, each attempt
+ * might be at a different rate, and have different modulation characteristics
+ * (e.g. antenna, fat channel, short guard interval), as set up in the rate
+ * scaling table in the Link Quality command.  The driver must determine
+ * which rate table entry was used for each tx attempt, to determine which
+ * rate-specific history to update, and record only those attempts that
+ * match the modulation characteristics of the history set.
+ *
+ * When using block-ack (aggregation), all frames are transmitted at the same
+ * rate, since there is no per-attempt acknowledgement from the destination
+ * station.  The Tx response struct iwl_tx_resp indicates the Tx rate in
+ * rate_n_flags field.  After receiving a block-ack, the driver can update
+ * history for the entire block all at once.
+ *
+ *
+ * FINDING BEST STARTING RATE:
+ *
+ * When working with a selected initial modulation mode (see below), the
+ * driver attempts to find a best initial rate.  The initial rate is the
+ * first entry in the Link Quality command's rate table.
+ *
+ * 1)  Calculate actual throughput (success ratio * expected throughput, see
+ *     table below) for current initial rate.  Do this only if enough frames
+ *     have been attempted to make the value meaningful:  at least 6 failed
+ *     tx attempts, or at least 8 successes.  If not enough, don't try rate
+ *     scaling yet.
+ *
+ * 2)  Find available rates adjacent to current initial rate.  Available means:
+ *     a)  supported by hardware &&
+ *     b)  supported by association &&
+ *     c)  within any constraints selected by user
+ *
+ * 3)  Gather measured throughputs for adjacent rates.  These might not have
+ *     enough history to calculate a throughput.  That's okay, we might try
+ *     using one of them anyway!
+ *
+ * 4)  Try decreasing rate if, for current rate:
+ *     a)  success ratio is < 15% ||
+ *     b)  lower adjacent rate has better measured throughput ||
+ *     c)  higher adjacent rate has worse throughput, and lower is unmeasured
+ *
+ *     As a sanity check, if decrease was determined above, leave rate
+ *     unchanged if:
+ *     a)  lower rate unavailable
+ *     b)  success ratio at current rate > 85% (very good)
+ *     c)  current measured throughput is better than expected throughput
+ *         of lower rate (under perfect 100% tx conditions, see table below)
+ *
+ * 5)  Try increasing rate if, for current rate:
+ *     a)  success ratio is < 15% ||
+ *     b)  both adjacent rates' throughputs are unmeasured (try it!) ||
+ *     b)  higher adjacent rate has better measured throughput ||
+ *     c)  lower adjacent rate has worse throughput, and higher is unmeasured
+ *
+ *     As a sanity check, if increase was determined above, leave rate
+ *     unchanged if:
+ *     a)  success ratio at current rate < 70%.  This is not particularly
+ *         good performance; higher rate is sure to have poorer success.
+ *
+ * 6)  Re-evaluate the rate after each tx frame.  If working with block-
+ *     acknowledge, history and statistics may be calculated for the entire
+ *     block (including prior history that fits within the history windows),
+ *     before re-evaluation.
+ *
+ * FINDING BEST STARTING MODULATION MODE:
+ *
+ * After working with a modulation mode for a "while" (and doing rate scaling),
+ * the driver searches for a new initial mode in an attempt to improve
+ * throughput.  The "while" is measured by numbers of attempted frames:
+ *
+ * For legacy mode, search for new mode after:
+ *   480 successful frames, or 160 failed frames
+ * For high-throughput modes (SISO or MIMO), search for new mode after:
+ *   4500 successful frames, or 400 failed frames
+ *
+ * Mode switch possibilities are (3 for each mode):
+ *
+ * For legacy:
+ *   Change antenna, try SISO (if HT association), try MIMO (if HT association)
+ * For SISO:
+ *   Change antenna, try MIMO, try shortened guard interval (SGI)
+ * For MIMO:
+ *   Try SISO antenna A, SISO antenna B, try shortened guard interval (SGI)
+ *
+ * When trying a new mode, use the same bit rate as the old/current mode when
+ * trying antenna switches and shortened guard interval.  When switching to
+ * SISO from MIMO or legacy, or to MIMO from SISO or legacy, use a rate
+ * for which the expected throughput (under perfect conditions) is about the
+ * same or slightly better than the actual measured throughput delivered by
+ * the old/current mode.
+ *
+ * Actual throughput can be estimated by multiplying the expected throughput
+ * by the success ratio (successful / attempted tx frames).  Frame size is
+ * not considered in this calculation; it assumes that frame size will average
+ * out to be fairly consistent over several samples.  The following are
+ * metric values for expected throughput assuming 100% success ratio.
+ * Only G band has support for CCK rates:
+ *
+ *           RATE:  1    2    5   11    6   9   12   18   24   36   48   54   60
+ *
+ *              G:  7   13   35   58   40  57   72   98  121  154  177  186  186
+ *              A:  0    0    0    0   40  57   72   98  121  154  177  186  186
+ *     SISO 20MHz:  0    0    0    0   42  42   76  102  124  159  183  193  202
+ * SGI SISO 20MHz:  0    0    0    0   46  46   82  110  132  168  192  202  211
+ *     MIMO 20MHz:  0    0    0    0   74  74  123  155  179  214  236  244  251
+ * SGI MIMO 20MHz:  0    0    0    0   81  81  131  164  188  222  243  251  257
+ *     SISO 40MHz:  0    0    0    0   77  77  127  160  184  220  242  250  257
+ * SGI SISO 40MHz:  0    0    0    0   83  83  135  169  193  229  250  257  264
+ *     MIMO 40MHz:  0    0    0    0  123 123  182  214  235  264  279  285  289
+ * SGI MIMO 40MHz:  0    0    0    0  131 131  191  222  242  270  284  289  293
+ *
+ * After the new mode has been tried for a short while (minimum of 6 failed
+ * frames or 8 successful frames), compare success ratio and actual throughput
+ * estimate of the new mode with the old.  If either is better with the new
+ * mode, continue to use the new mode.
+ *
+ * Continue comparing modes until all 3 possibilities have been tried.
+ * If moving from legacy to HT, try all 3 possibilities from the new HT
+ * mode.  After trying all 3, a best mode is found.  Continue to use this mode
+ * for the longer "while" described above (e.g. 480 successful frames for
+ * legacy), and then repeat the search process.
+ *
  */
 struct iwl4965_link_quality_cmd {
+
+	/* Index of destination/recipient station in uCode's station table */
 	u8 sta_id;
 	u8 reserved1;
-	__le16 control;
+	__le16 control;		/* not used */
 	struct iwl4965_link_qual_general_params general_params;
 	struct iwl4965_link_qual_agg_params agg_params;
+
+	/*
+	 * Rate info; when using rate-scaling, Tx command's initial_rate_index
+	 * specifies 1st Tx rate attempted, via index into this table.
+	 * 4965 works its way through table when retrying Tx.
+	 */
 	struct {
-		__le32 rate_n_flags;
+		__le32 rate_n_flags;	/* RATE_MCS_*, IWL_RATE_* */
 	} rs_table[LINK_QUAL_MAX_RETRY_NUM];
 	__le32 reserved2;
 } __attribute__ ((packed));
-- 
1.5.3.6
