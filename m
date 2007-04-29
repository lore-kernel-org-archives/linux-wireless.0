Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44843 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754480AbXD2Adr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 20:33:47 -0400
Received: from logostar.upir.cz (r2u241.net.upc.cz [62.245.84.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 75F6E628062
	for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 02:33:46 +0200 (CEST)
Date: Sun, 29 Apr 2007 02:33:45 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211: document requirement for atomicity of  callbacks
Message-ID: <20070429023345.43e09faf@logostar.upir.cz>
In-Reply-To: <20070429023215.40c2aea7@logostar.upir.cz>
References: <20070429023215.40c2aea7@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some callbacks must be atomic. This is not documented anywhere.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 include/net/mac80211.h     |   24 ++++++++++++++++--------
 net/mac80211/ieee80211_i.h |    3 ++-
 2 files changed, 18 insertions(+), 9 deletions(-)

--- dscape.orig/include/net/mac80211.h
+++ dscape/include/net/mac80211.h
@@ -582,7 +582,8 @@ struct ieee80211_ops {
 	/* Handler that 802.11 module calls for each transmitted frame.
 	 * skb contains the buffer starting from the IEEE 802.11 header.
 	 * The low-level driver should send the frame out based on
-	 * configuration in the TX control data. */
+	 * configuration in the TX control data.
+	 * Must be atomic. */
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control);
 
@@ -631,7 +632,8 @@ struct ieee80211_ops {
 	 * we need to combine the multicast lists and flags for multiple
 	 * virtual interfaces), they cannot assign set_multicast_list.
 	 * The parameters here replace dev->flags and dev->mc_count,
-	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item. */
+	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item.
+	 * Must be atomic. */
 	void (*set_multicast_list)(struct ieee80211_hw *hw,
 				   unsigned short flags, int mc_count);
 
@@ -639,7 +641,8 @@ struct ieee80211_ops {
 	 * generation, IEEE 802.11 code uses this function to tell the
 	 * low-level to set (or clear if set==0) TIM bit for the given aid. If
 	 * host system is used to generate beacons, this handler is not used
-	 * and low-level driver should set it to NULL. */
+	 * and low-level driver should set it to NULL.
+	 * Must be atomic. */
 	int (*set_tim)(struct ieee80211_hw *hw, int aid, int set);
 
 	/* Set encryption key. IEEE 802.11 module calls this function to set
@@ -647,7 +650,8 @@ struct ieee80211_ops {
 	 * station hwaddr for individual keys. aid of the station is given
 	 * to help low-level driver in selecting which key->hw_key_idx to use
 	 * for this key. TX control data will use the hw_key_idx selected by
-	 * the low-level driver. */
+	 * the low-level driver.
+	 * Must be atomic. */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
 		       u8 *addr, struct ieee80211_key_conf *key, int aid);
 
@@ -675,7 +679,8 @@ struct ieee80211_ops {
 
 	/* Ask the hardware to do a passive scan on a new channel. The hardware
 	 * will do what ever is required to nicely leave the current channel
-	 * including transmit any CTS packets, etc. */
+	 * including transmit any CTS packets, etc.
+	 * Must be atomic. */
 	int (*passive_scan)(struct ieee80211_hw *hw, int state,
 			    struct ieee80211_scan_conf *conf);
 
@@ -712,13 +717,15 @@ struct ieee80211_ops {
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
 
-	/* Number of STAs in STA table notification (NULL = disabled) */
+	/* Number of STAs in STA table notification (NULL = disabled).
+	 * Must be atomic. */
 	void (*sta_table_notification)(struct ieee80211_hw *hw,
 				       int num_sta);
 
 	/* Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
 	 * bursting) for a hardware TX queue.
-	 * queue = IEEE80211_TX_QUEUE_*. */
+	 * queue = IEEE80211_TX_QUEUE_*.
+	 * Must be atomic. */
 	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
 		       const struct ieee80211_tx_queue_params *params);
 
@@ -733,7 +740,8 @@ struct ieee80211_ops {
 
 	/* Get the current TSF timer value from firmware/hardware. Currently,
 	 * this is only used for IBSS mode debugging and, as such, is not a
-	 * required function. */
+	 * required function.
+	 * Must be atomic. */
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 
 	/* Call low level driver with 11n Block Ack action */
--- dscape.orig/net/mac80211/ieee80211_i.h
+++ dscape/net/mac80211/ieee80211_i.h
@@ -495,7 +495,8 @@ struct ieee80211_local {
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
 
-	rwlock_t sub_if_lock; /* protects sub_if_list */
+	rwlock_t sub_if_lock; /* Protects sub_if_list. Cannot be taken under
+			       * sta_bss_lock or sta_lock. */
 	struct list_head sub_if_list;
 	int sta_scanning;
 	int scan_channel_idx;
