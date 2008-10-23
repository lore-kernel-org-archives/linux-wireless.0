Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYJWGvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:51:24 -0400
Subject: [PATCH v2] mac80211: fix two kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224744329.5865.15.camel@johannes.berg> (sfid-20081023_084603_268923_7F561D5E)
References: <1224744329.5865.15.camel@johannes.berg>
	 (sfid-20081023_084603_268923_7F561D5E)
Content-Type: text/plain
Date: Thu, 23 Oct 2008 08:51:20 +0200
Message-Id: <1224744680.5865.17.camel@johannes.berg> (sfid-20081023_085128_480996_E1B41ECF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One parameter wasn't described and one I forgot to update when
renaming it; also update TBDs in sta_info.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h  |    4 +++-
 net/mac80211/sta_info.h |   38 ++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 19 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-10-23 08:43:41.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-23 08:44:28.000000000 +0200
@@ -291,7 +291,7 @@ enum mac80211_rate_control_flags {
  *
  * @idx: rate index to attempt to send with
  * @flags: rate control flags (&enum mac80211_rate_control_flags)
- * @limit: number of retries before fallback
+ * @count: number of tries in this rate before going to the next rate
  *
  * A value of -1 for @idx indicates an invalid rate and, if used
  * in an array of retry rates, that no more rates should be tried.
@@ -1903,6 +1903,8 @@ struct ieee80211_sta *ieee80211_find_sta
  * @short_preamble: whether mac80211 will request short-preamble transmission
  *	if the selected rate supports it
  * @max_rate_idx: user-requested maximum rate (not MCS for now)
+ * @skb: the skb that will be transmitted, the control information in it needs
+ *	to be filled in
  */
 struct ieee80211_tx_rate_control {
 	struct ieee80211_hw *hw;
--- everything.orig/net/mac80211/sta_info.h	2008-10-23 08:45:40.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-10-23 08:50:32.000000000 +0200
@@ -160,18 +160,20 @@ struct sta_ampdu_mlme {
  * @list: global linked list entry
  * @hnext: hash table linked list pointer
  * @local: pointer to the global information
- * @sdata: TBD
- * @key: TBD
- * @rate_ctrl: TBD
- * @rate_ctrl_priv: TBD
+ * @sdata: virtual interface this station belongs to
+ * @key: peer key negotiated with this station, if any
+ * @rate_ctrl: rate control algorithm reference
+ * @rate_ctrl_priv: rate control private per-STA pointer
+ * @last_tx_rate: rate used for last transmit, to report to userspace as
+ *	"the" transmit rate
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @flaglock: spinlock for flags accesses
  * @addr: MAC address of this STA
  * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
  *	only used in AP (and IBSS?) mode
- * @listen_interval: TBD
- * @pin_status: TBD
+ * @listen_interval: listen interval of this station, when we're acting as AP
+ * @pin_status: used internally for pinning a STA struct into memory
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
  * @ps_tx_buf: buffer of frames to transmit to this station
  *	when it leaves power saving state
@@ -180,8 +182,8 @@ struct sta_ampdu_mlme {
  *	power saving state
  * @rx_packets: Number of MSDUs received from this STA
  * @rx_bytes: Number of bytes received from this STA
- * @wep_weak_iv_count: TBD
- * @last_rx: TBD
+ * @wep_weak_iv_count: number of weak WEP IVs received from this station
+ * @last_rx: time (in jiffies) when last frame was received from this STA
  * @num_duplicates: number of duplicate frames received from this STA
  * @rx_fragments: number of received MPDUs
  * @rx_dropped: number of dropped MPDUs from this STA
@@ -189,26 +191,26 @@ struct sta_ampdu_mlme {
  * @last_qual: qual of last received frame from this STA
  * @last_noise: noise of last received frame from this STA
  * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
- * @tx_filtered_count: TBD
- * @tx_retry_failed: TBD
- * @tx_retry_count: TBD
+ * @tx_filtered_count: number of frames the hardware filtered for this STA
+ * @tx_retry_failed: number of frames that failed retry
+ * @tx_retry_count: total number of retries for frames to this STA
  * @fail_avg: moving percentage of failed MSDUs
  * @tx_packets: number of RX/TX MSDUs
- * @tx_bytes: TBD
+ * @tx_bytes: number of bytes transmitted to this STA
  * @tx_fragments: number of transmitted MPDUs
  * @last_txrate: description of the last used transmit rate
- * @tid_seq: TBD
- * @ampdu_mlme: TBD
+ * @tid_seq: per-TID sequence numbers for sending to this STA
+ * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
  * @tid_to_tx_q: map tid to tx queue
  * @llid: Local link ID
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
  * @plink_retries: Retries in establishment
- * @ignore_plink_timer: TBD
- * @plink_state plink_state: TBD
- * @plink_timeout: TBD
- * @plink_timer: TBD
+ * @ignore_plink_timer: ignore the peer-link timer (used internally)
+ * @plink_state: peer link state
+ * @plink_timeout: timeout of peer link
+ * @plink_timer: peer link watch timer
  * @debugfs: debug filesystem info
  * @sta: station information we share with the driver
  */


