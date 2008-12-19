Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbYLSCpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:03 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/43] iwl3945: Getting rid of iwl-3945-debug.h
Date: Fri, 19 Dec 2008 10:37:08 +0800
Message-Id: <1229654263-21454-9-git-send-email-yi.zhu@intel.com> (sfid-20081219_034521_897877_B2CE0BE0)
In-Reply-To: <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

At the cost of adding a debug_level field to iwl3945_priv, we are now able to
get rid of iwl-3945-debug.h, and use iwl-debug.h instead.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h |  167 -------------------------
 drivers/net/wireless/iwlwifi/iwl-3945-io.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c    |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   95 ++++++--------
 7 files changed, 59 insertions(+), 227 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debug.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
deleted file mode 100644
index 85eb778..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ /dev/null
@@ -1,167 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
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
-#ifndef __iwl3945_debug_h__
-#define __iwl3945_debug_h__
-
-#ifdef CONFIG_IWL3945_DEBUG
-extern u32 iwl3945_debug_level;
-#define IWL_DEBUG(level, fmt, args...) \
-do { if (iwl3945_debug_level & (level)) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
-
-#define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((iwl3945_debug_level & (level)) && net_ratelimit()) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
-
-static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
-{
-	if (!(iwl3945_debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-}
-#else
-static inline void IWL_DEBUG(int level, const char *fmt, ...)
-{
-}
-static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
-{
-}
-static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
-{
-}
-#endif	/* CONFIG_IWL3945_DEBUG */
-
-
-
-/*
- * To use the debug system;
- *
- * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of:
- *
- * #define IWL_DL_xxxx VALUE
- *
- * shifting value to the left one bit from the previous entry.  xxxx should be
- * the name of the classification (for example, WEP)
- *
- * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
- * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
- * to send output to that classification.
- *
- * To add your debug level to the list of levels seen when you perform
- *
- * % cat /proc/net/iwl/debug_level
- *
- * you simply need to add your entry to the iwl3945_debug_levels array.
- *
- * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWL3945_DEBUG defined in your kernel configuration
- *
- */
-
-#define IWL_DL_INFO          (1 << 0)
-#define IWL_DL_MAC80211      (1 << 1)
-#define IWL_DL_HOST_COMMAND  (1 << 2)
-#define IWL_DL_STATE         (1 << 3)
-
-#define IWL_DL_RADIO         (1 << 7)
-#define IWL_DL_POWER         (1 << 8)
-#define IWL_DL_TEMP          (1 << 9)
-
-#define IWL_DL_NOTIF         (1 << 10)
-#define IWL_DL_SCAN          (1 << 11)
-#define IWL_DL_ASSOC         (1 << 12)
-#define IWL_DL_DROP          (1 << 13)
-
-#define IWL_DL_TXPOWER       (1 << 14)
-
-#define IWL_DL_AP            (1 << 15)
-
-#define IWL_DL_FW            (1 << 16)
-#define IWL_DL_RF_KILL       (1 << 17)
-#define IWL_DL_FW_ERRORS     (1 << 18)
-
-#define IWL_DL_LED           (1 << 19)
-
-#define IWL_DL_RATE          (1 << 20)
-
-#define IWL_DL_CALIB         (1 << 21)
-#define IWL_DL_WEP           (1 << 22)
-#define IWL_DL_TX            (1 << 23)
-#define IWL_DL_RX            (1 << 24)
-#define IWL_DL_ISR           (1 << 25)
-#define IWL_DL_HT            (1 << 26)
-#define IWL_DL_IO            (1 << 27)
-#define IWL_DL_11H           (1 << 28)
-
-#define IWL_DL_STATS         (1 << 29)
-#define IWL_DL_TX_REPLY      (1 << 30)
-#define IWL_DL_QOS           (1 << 31)
-
-#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
-#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
-#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
-
-#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
-#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
-#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
-#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
-#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
-#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
-#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
-#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
-#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
-#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
-#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
-#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
-	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
-#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
-#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
-#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
-#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
-
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 2440fd6..d49dfd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -31,7 +31,7 @@
 
 #include <linux/io.h>
 
-#include "iwl-3945-debug.h"
+#include "iwl-debug.h"
 
 /*
  * IO, register, and NIC memory access functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 871c65e..a42c0b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -52,6 +52,7 @@ struct iwl3945_rate_scale_data {
 
 struct iwl3945_rs_sta {
 	spinlock_t lock;
+	struct iwl3945_priv *priv;
 	s32 *expected_tpt;
 	unsigned long last_partial_flush;
 	unsigned long last_flush;
@@ -182,6 +183,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 	int unflushed = 0;
 	int i;
 	unsigned long flags;
+	struct iwl3945_priv *priv = rs_sta->priv;
 
 	/*
 	 * For each rate, if we have collected data on that rate
@@ -214,6 +216,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
 	struct iwl3945_rs_sta *rs_sta = (void *)data;
+	struct iwl3945_priv *priv = rs_sta->priv;
 	int unflushed = 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
@@ -287,6 +290,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 {
 	unsigned long flags;
 	s32 fail_count;
+	struct iwl3945_priv *priv = rs_sta->priv;
 
 	if (!retries) {
 		IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
@@ -380,10 +384,11 @@ static void rs_free(void *priv)
 	return;
 }
 
-static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
+static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct iwl3945_rs_sta *rs_sta;
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
+	struct iwl3945_priv *priv = iwl_priv;
 	int i;
 
 	/*
@@ -403,6 +408,8 @@ static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 
 	spin_lock_init(&rs_sta->lock);
 
+	rs_sta->priv = priv;
+
 	rs_sta->start_rate = IWL_RATE_INVALID;
 
 	/* default to just 802.11b */
@@ -426,11 +433,12 @@ static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	return rs_sta;
 }
 
-static void rs_free_sta(void *priv, struct ieee80211_sta *sta,
+static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
+	struct iwl3945_priv *priv = rs_sta->priv;
 
 	psta->rs_sta = NULL;
 
@@ -548,6 +556,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 {
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
+	struct iwl3945_priv *priv = rs_sta->priv;
 
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0fd8a22..10d6537 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -542,7 +542,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl3945_print_hex_dump(IWL_DL_RX, data, length);
+		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
 }
 #else
 static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
@@ -708,7 +708,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 			      rx_status.noise, rx_status.rate_idx);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & (IWL_DL_RX))
+	if (priv->debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
 		iwl3945_dbg_report_frame(priv, pkt, header, 1);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 5d5176a..d5154ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -47,7 +47,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-3945-hw.h"
-#include "iwl-3945-debug.h"
+#include "iwl-debug.h"
 #include "iwl-3945-led.h"
 
 /* Highest firmware API version supported */
@@ -889,6 +889,7 @@ struct iwl3945_priv {
 
 #ifdef CONFIG_IWL3945_DEBUG
 	/* debugging info */
+	u32 debug_level;
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 56c13b4..f00e30d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -29,6 +29,8 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
+struct iwl_priv;
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (priv->debug_level & (level)) \
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 00600d6..c85e136 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -52,10 +52,6 @@
 #include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWL3945_DEBUG
-u32 iwl3945_debug_level;
-#endif
-
 static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 				  struct iwl3945_tx_queue *txq);
 
@@ -2438,7 +2434,7 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
-		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 	}
 	/* If we are in monitor mode, use BCAST. This is required for
@@ -2646,10 +2642,10 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
-	iwl3945_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
+	iwl_print_hex_dump(priv, IWL_DL_TX, out_cmd->cmd.payload,
 			   sizeof(out_cmd->cmd.tx));
 
-	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
@@ -3056,7 +3052,8 @@ static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl3945_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw,
+			   le32_to_cpu(pkt->len));
 }
 
 static void iwl3945_bg_beacon_update(struct work_struct *work)
@@ -3856,13 +3853,13 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl3945_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
-			IWL_DEBUG(IWL_DL_HOST_COMMAND | IWL_DL_RX | IWL_DL_ISR,
+			IWL_DEBUG(IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
 				"r = %d, i = %d, %s, 0x%02x\n", r, i,
 				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 		} else {
 			/* No handling needed */
-			IWL_DEBUG(IWL_DL_HOST_COMMAND | IWL_DL_RX | IWL_DL_ISR,
+			IWL_DEBUG(IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
 				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
@@ -3957,12 +3954,13 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
-static void iwl3945_print_rx_config_cmd(struct iwl3945_rxon_cmd *rxon)
+static void iwl3945_print_rx_config_cmd(struct iwl3945_priv *priv,
+					struct iwl3945_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl3945_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
@@ -4198,10 +4196,10 @@ static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & IWL_DL_FW_ERRORS) {
+	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl3945_dump_nic_error_log(priv);
 		iwl3945_dump_nic_event_log(priv);
-		iwl3945_print_rx_config_cmd(&priv->staging_rxon);
+		iwl3945_print_rx_config_cmd(priv, &priv->staging_rxon);
 	}
 #endif
 
@@ -4265,7 +4263,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	iwl3945_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & IWL_DL_ISR) {
+	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -4299,7 +4297,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	}
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & (IWL_DL_ISR)) {
+	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
 			IWL_DEBUG_ISR("Scheduler finished to transmit "
@@ -4370,7 +4368,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 		iwl3945_enable_interrupts(priv);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & (IWL_DL_ISR)) {
+	if (priv->debug_level & (IWL_DL_ISR)) {
 		inta = iwl3945_read32(priv, CSR_INT);
 		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
@@ -7160,9 +7158,6 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 static int iwl3945_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
-	IWL_DEBUG_MAC80211("enter\n");
-	IWL_DEBUG_MAC80211("leave\n");
-
 	return 0;
 }
 
@@ -7277,29 +7272,33 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
  *
  * See the level definitions in iwl for details.
  */
-
-static ssize_t show_debug_level(struct device_driver *d, char *buf)
+static ssize_t show_debug_level(struct device *d,
+				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "0x%08X\n", iwl3945_debug_level);
+	struct iwl3945_priv *priv = d->driver_data;
+
+	return sprintf(buf, "0x%08X\n", priv->debug_level);
 }
-static ssize_t store_debug_level(struct device_driver *d,
+static ssize_t store_debug_level(struct device *d,
+				struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	char *p = (char *)buf;
-	u32 val;
+	struct iwl3945_priv *priv = d->driver_data;
+	unsigned long val;
+	int ret;
 
-	val = simple_strtoul(p, &p, 0);
-	if (p == buf)
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in hex or decimal form.\n", buf);
 	else
-		iwl3945_debug_level = val;
+		priv->debug_level = val;
 
 	return strnlen(buf, count);
 }
 
-static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
-		   show_debug_level, store_debug_level);
+static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
+			show_debug_level, store_debug_level);
 
 #endif /* CONFIG_IWL3945_DEBUG */
 
@@ -7780,7 +7779,9 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-
+#ifdef CONFIG_IWL3945_DEBUG
+	&dev_attr_debug_level.attr,
+#endif
 	NULL
 };
 
@@ -7820,13 +7821,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 1. Allocating HW data
 	 * ********************/
 
-	/* Disabling hardware scan means that mac80211 will perform scans
-	 * "the hard way", rather than using device's scan. */
-	if (iwl3945_param_disable_hw_scan) {
-		IWL_DEBUG_INFO("Disabling hw_scan\n");
-		iwl3945_hw_ops.hw_scan = NULL;
-	}
-
 	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
 	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
@@ -7851,6 +7845,13 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 	priv->cfg = cfg;
 
+	/* Disabling hardware scan means that mac80211 will perform scans
+	 * "the hard way", rather than using device's scan. */
+	if (iwl3945_param_disable_hw_scan) {
+		IWL_DEBUG_INFO("Disabling hw_scan\n");
+		iwl3945_hw_ops.hw_scan = NULL;
+	}
+
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	hw->rate_control_algorithm = "iwl-3945-rs";
 	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
@@ -7858,7 +7859,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Select antenna (may be helpful if only one antenna is connected) */
 	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
 #ifdef CONFIG_IWL3945_DEBUG
-	iwl3945_debug_level = iwl3945_param_debug;
+	priv->debug_level = iwl3945_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -8319,20 +8320,9 @@ static int __init iwl3945_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		goto error_register;
 	}
-#ifdef CONFIG_IWL3945_DEBUG
-	ret = driver_create_file(&iwl3945_driver.driver, &driver_attr_debug_level);
-	if (ret) {
-		IWL_ERROR("Unable to create driver sysfs file\n");
-		goto error_debug;
-	}
-#endif
 
 	return ret;
 
-#ifdef CONFIG_IWL3945_DEBUG
-error_debug:
-	pci_unregister_driver(&iwl3945_driver);
-#endif
 error_register:
 	iwl3945_rate_control_unregister();
 	return ret;
@@ -8340,9 +8330,6 @@ error_register:
 
 static void __exit iwl3945_exit(void)
 {
-#ifdef CONFIG_IWL3945_DEBUG
-	driver_remove_file(&iwl3945_driver.driver, &driver_attr_debug_level);
-#endif
 	pci_unregister_driver(&iwl3945_driver);
 	iwl3945_rate_control_unregister();
 }
-- 
1.5.3.6

