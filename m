Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2IFNk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 09:40:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlegacy: mark many functions static
Date: Thu,  6 Sep 2012 15:41:32 +0200
Message-Id: <1346938892-14081-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_154101_261827_2D0D9F00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

sparse correctly complains that a lot of functions
should be static, so mark them static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c |    6 +++---
 drivers/net/wireless/iwlegacy/3945-mac.c   |    2 +-
 drivers/net/wireless/iwlegacy/4965-debug.c |    6 +++---
 drivers/net/wireless/iwlegacy/4965-mac.c   |   16 ++++++++--------
 drivers/net/wireless/iwlegacy/common.c     |    2 +-
 drivers/net/wireless/iwlegacy/debug.c      |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index f767dd1..c1b4441 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -48,7 +48,7 @@ il3945_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	return p;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -313,7 +313,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -403,7 +403,7 @@ il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index e252acb..b759733 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3457,7 +3457,7 @@ static struct attribute_group il3945_attribute_group = {
 	.attrs = il3945_sysfs_entries,
 };
 
-struct ieee80211_ops il3945_mac_ops = {
+static struct ieee80211_ops il3945_mac_ops = {
 	.tx = il3945_mac_tx,
 	.start = il3945_mac_start,
 	.stop = il3945_mac_stop,
diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index c8153fc..e0597bf 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -55,7 +55,7 @@ il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	return p;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -467,7 +467,7 @@ il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -633,7 +633,7 @@ il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index eac4dc8..9d65754 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -609,7 +609,7 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 
 /* Called for N_RX (legacy ABG frames), or
  * N_RX_MPDU (HT high-throughput N frames). */
-void
+static void
 il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -731,7 +731,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 
 /* Cache phy data (Rx signal strength, etc) for HT frame (N_RX_PHY).
  * This will be used later in il_hdl_rx() for N_RX_MPDU. */
-void
+static void
 il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1236,7 +1236,7 @@ il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 	return 0;
 }
 
-void
+static void
 il4965_hdl_missed_beacon(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1343,7 +1343,7 @@ il4965_accumulative_stats(struct il_priv *il, __le32 * stats)
 }
 #endif
 
-void
+static void
 il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	const int recalib_seconds = 60;
@@ -1385,7 +1385,7 @@ il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 		il4965_temperature_calib(il);
 }
 
-void
+static void
 il4965_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -2030,7 +2030,7 @@ il4965_txq_ctx_reset(struct il_priv *il)
 		il_tx_queue_reset(il, txq_id);
 }
 
-void
+static void
 il4965_txq_ctx_unmap(struct il_priv *il)
 {
 	int txq_id;
@@ -2875,7 +2875,7 @@ il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
  */
-void
+static void
 il4965_hdl_compressed_ba(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -6286,7 +6286,7 @@ il4965_tx_queue_set_status(struct il_priv *il, struct il_tx_queue *txq,
 	       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
-const struct ieee80211_ops il4965_mac_ops = {
+static const struct ieee80211_ops il4965_mac_ops = {
 	.tx = il4965_mac_tx,
 	.start = il4965_mac_start,
 	.stop = il4965_mac_stop,
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index eb99875..ba6c424 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1122,7 +1122,7 @@ il_set_power(struct il_priv *il, struct il_powertable_cmd *cmd)
 			       sizeof(struct il_powertable_cmd), cmd);
 }
 
-int
+static int
 il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd, bool force)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index eff2650..b7e03dd 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -31,7 +31,7 @@
 
 #include "common.h"
 
-void
+static void
 il_clear_traffic_stats(struct il_priv *il)
 {
 	memset(&il->tx_stats, 0, sizeof(struct traffic_stats));
-- 
1.7.10.4

