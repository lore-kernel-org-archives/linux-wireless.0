Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:54013 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab2KZM4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:56:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 26 Nov 2012 04:56:52 -0800
From: saravanad@posedge.com
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: add debugfs file for mic failure
Message-ID: <67d5ecb12773d91de180d654e6283cbe@posedge.com> (sfid-20121126_135656_608610_50BEF9D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Add a debugfs file showing the number of failure of
rx packet dropped due to mic failures. currently the
number of rx packet dropped is counted in general and
not with respect to a specific reason. This patch
counts the number of packet drop due to mic failure.

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.
net/mac80211/debugfs_sta.c |    1 +
  net/mac80211/sta_info.h    |    3 +++
  net/mac80211/wpa.c         |    1 +
  3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..b1aea94 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -377,6 +377,7 @@ void ieee80211_sta_debugfs_add(struct sta_info 
*sta)
  	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
  	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
  	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
+	DEBUGFS_ADD_COUNTER(rx_dropped_mic_failure, rx_dropped_mic_failure);
  	DEBUGFS_ADD_COUNTER(tx_fragments, tx_fragments);
  	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
  	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..7456a95 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -247,6 +247,8 @@ struct sta_ampdu_mlme {
   * @num_duplicates: number of duplicate frames received from this STA
   * @rx_fragments: number of received MPDUs
   * @rx_dropped: number of dropped MPDUs from this STA
+ * @rx_dropped_mic_failure: number of dropped MPDUs
+ *	due to mic failure from this STA
   * @last_signal: signal of last received frame from this STA
   * @avg_signal: moving average of signal of received frames from this 
STA
   * @last_seq_ctrl: last received seq/frag number from this STA (per RX 
queue)
@@ -326,6 +328,7 @@ struct sta_info {
  	unsigned long num_duplicates;
  	unsigned long rx_fragments;
  	unsigned long rx_dropped;
+	unsigned long rx_dropped_mic_failure;
  	int last_signal;
  	struct ewma avg_signal;
  	/* Plus 1 for non-QoS frames */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 8bd2f5c..960403e 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -166,6 +166,7 @@ mic_fail:
  	 * a driver that supports HW encryption. Send up the key idx only if
  	 * the key is set.
  	 */
+	rx->sta->rx_dropped_mic_failure++;
  	mac80211_ev_michael_mic_failure(rx->sdata,
  					rx->key ? rx->key->conf.keyidx : -1,
  					(void *) skb->data, NULL, GFP_ATOMIC);
