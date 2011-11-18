Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:01 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8L1PK026013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:01 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/77] iwlegacy: remove DEBUG_LIMIT
Date: Fri, 18 Nov 2011 09:21:28 +0100
Message-Id: <1321604559-10707-6-git-send-email-sgruszka@redhat.com> (sfid-20111118_092108_215605_08DB7891)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if messages are generating fast we want to see all of them
when debugging.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c  |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debug.h    |   22 +---------------------
 5 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index c9b5dcf..628adf5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -477,7 +477,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!il->is_open)) {
-		IL_DEBUG_DROP_LIMIT(il,
+		IL_DEBUG_DROP(il,
 			"Dropping packet while interface is not open.\n");
 		return;
 	}
@@ -563,7 +563,7 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 
 	network_packet = il3945_is_network_packet(il, header);
 
-	IL_DEBUG_STATS_LIMIT(il, "[%c] %d RSSI:%d Signal:%u, Rate:%u\n",
+	IL_DEBUG_STATS(il, "[%c] %d RSSI:%d Signal:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
 			      rx_status.signal, rx_status.signal,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 647399e..1564629 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -537,7 +537,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!il->is_open)) {
-		IL_DEBUG_DROP_LIMIT(il,
+		IL_DEBUG_DROP(il,
 		    "Dropping packet while interface is not open.\n");
 		return;
 	}
@@ -647,7 +647,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 	rx_status.signal = il4965_calc_rssi(il, phy_res);
 
 	il_dbg_log_rx_data_frame(il, len, header);
-	IL_DEBUG_STATS_LIMIT(il, "Rssi %d, TSF %llu\n",
+	IL_DEBUG_STATS(il, "Rssi %d, TSF %llu\n",
 		rx_status.signal, (unsigned long long)rx_status.mactime);
 
 	/*
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 60ff0cd..782ec77 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -817,7 +817,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
-	IL_DEBUG_RATE_LIMIT(il,
+	IL_DEBUG_RATE(il,
 		"get frame ack response, update rate scale window\n");
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
@@ -2251,7 +2251,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	struct il_lq_sta *lq_sta = il_sta;
 	int rate_idx;
 
-	IL_DEBUG_RATE_LIMIT(il, "rate scale calculate new rate for skb\n");
+	IL_DEBUG_RATE(il, "rate scale calculate new rate for skb\n");
 
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index d3c8183..01fa6c8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1737,7 +1737,7 @@ static u8 il4965_find_station(struct il_priv *il, const u8 *addr)
 			goto out;
 		}
 
-	IL_DEBUG_ASSOC_LIMIT(il, "can not find STA %pM total %d\n",
+	IL_DEBUG_ASSOC(il, "can not find STA %pM total %d\n",
 			      addr, il->num_stations);
 
  out:
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index a825051..c6dcbf3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -52,14 +52,6 @@ do {									\
 			__func__ , ## args);				\
 } while (0)
 
-#define IL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
-do {									\
-	if ((il_get_debug_level(__priv) & (level)) && net_ratelimit())	\
-		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
-			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
-			 __func__ , ## args);				\
-} while (0)
-
 #define il_print_hex_dump(il, level, p, len) 			\
 do {									\
 	if (il_get_debug_level(il) & level)				\
@@ -69,7 +61,6 @@ do {									\
 
 #else
 #define IL_DEBUG(__priv, level, fmt, args...)
-#define IL_DEBUG_LIMIT(__priv, level, fmt, args...)
 static inline void il_print_hex_dump(struct il_priv *il, int level,
 				      const void *p, u32 len)
 {}
@@ -169,25 +160,14 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 #define IL_DEBUG_FW(p, f, a...)	IL_DEBUG(p, IL_DL_FW, f, ## a)
 #define IL_DEBUG_RF_KILL(p, f, a...)	IL_DEBUG(p, IL_DL_RF_KILL, f, ## a)
 #define IL_DEBUG_DROP(p, f, a...)	IL_DEBUG(p, IL_DL_DROP, f, ## a)
-#define IL_DEBUG_DROP_LIMIT(p, f, a...)	\
-		IL_DEBUG_LIMIT(p, IL_DL_DROP, f, ## a)
 #define IL_DEBUG_AP(p, f, a...)	IL_DEBUG(p, IL_DL_AP, f, ## a)
 #define IL_DEBUG_TXPOWER(p, f, a...)	IL_DEBUG(p, IL_DL_TXPOWER, f, ## a)
 #define IL_DEBUG_RATE(p, f, a...)	IL_DEBUG(p, IL_DL_RATE, f, ## a)
-#define IL_DEBUG_RATE_LIMIT(p, f, a...)	\
-		IL_DEBUG_LIMIT(p, IL_DL_RATE, f, ## a)
 #define IL_DEBUG_NOTIF(p, f, a...)	IL_DEBUG(p, IL_DL_NOTIF, f, ## a)
-#define IL_DEBUG_ASSOC(p, f, a...)	\
-		IL_DEBUG(p, IL_DL_ASSOC | IL_DL_INFO, f, ## a)
-#define IL_DEBUG_ASSOC_LIMIT(p, f, a...)	\
-		IL_DEBUG_LIMIT(p, IL_DL_ASSOC | IL_DL_INFO, f, ## a)
+#define IL_DEBUG_ASSOC(p, f, a...)	IL_DEBUG(p, IL_DL_ASSOC, f, ## a)
 #define IL_DEBUG_HT(p, f, a...)	IL_DEBUG(p, IL_DL_HT, f, ## a)
 #define IL_DEBUG_STATS(p, f, a...)	IL_DEBUG(p, IL_DL_STATS, f, ## a)
-#define IL_DEBUG_STATS_LIMIT(p, f, a...)	\
-		IL_DEBUG_LIMIT(p, IL_DL_STATS, f, ## a)
 #define IL_DEBUG_TX_REPLY(p, f, a...)	IL_DEBUG(p, IL_DL_TX_REPLY, f, ## a)
-#define IL_DEBUG_TX_REPLY_LIMIT(p, f, a...) \
-		IL_DEBUG_LIMIT(p, IL_DL_TX_REPLY, f, ## a)
 #define IL_DEBUG_QOS(p, f, a...)	IL_DEBUG(p, IL_DL_QOS, f, ## a)
 #define IL_DEBUG_RADIO(p, f, a...)	IL_DEBUG(p, IL_DL_RADIO, f, ## a)
 #define IL_DEBUG_POWER(p, f, a...)	IL_DEBUG(p, IL_DL_POWER, f, ## a)
-- 
1.7.1

