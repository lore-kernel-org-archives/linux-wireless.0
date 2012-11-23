Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:38704 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2KWFuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 00:50:15 -0500
Message-ID: <50AF0E91.30709@posedge.com> (sfid-20121123_065025_988486_8AADA812)
Date: Fri, 23 Nov 2012 11:20:09 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: RFC[1/2]mac80211: Add Statistic to debugfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide additional statistic support to the debugfs.

The statistic that are added are the

1. Number of rx packets dropped due to mic failure
	- Currently the debugfs has support for number of rx packets dropped. 
But it doesn't classify the reason for the drop. This statistic will 
count the number of rx packet dropped due to mic failure.

  2. Rssi of the Last Ack Frame.
	- This information is available as part of ieee80211_tx_info status 
structure. Thought this information may be useful(in future).

Signed-off-by: Saravana <saravanad@posedge.com>
  ---
The diff file is generated from wireless-testing git tree.

net/mac80211/debugfs_sta.c |    3 +++
  net/mac80211/sta_info.h    |    4 ++++
  net/mac80211/status.c      |    2 ++
  net/mac80211/wpa.c         |    1 +
  4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5ccec2c..d0508d6 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -52,6 +52,7 @@ static const struct file_operations sta_ ##name##
_ops = {		\
  STA_FILE(aid, sta.aid, D);
  STA_FILE(dev, sdata->name, S);
  STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_ack_signal, last_ack_signal, D);

  static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
  			      size_t count, loff_t *ppos)
@@ -366,6 +367,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
  	DEBUGFS_ADD(dev);
  	DEBUGFS_ADD(last_signal);
  	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(last_ack_signal);

  	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
  	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
@@ -374,6 +376,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
  	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
  	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
  	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
+	DEBUGFS_ADD_COUNTER(rx_dropped_mic_failure,rx_dropped_mic_failure);
  	DEBUGFS_ADD_COUNTER(tx_fragments, tx_fragments);
  	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
  	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c88f161f..0905eda 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -248,8 +248,10 @@ struct sta_ampdu_mlme {
   * @num_duplicates: number of duplicate frames received from this STA
   * @rx_fragments: number of received MPDUs
   * @rx_dropped: number of dropped MPDUs from this STA
+ * @rx_dropped_mic_failure: number of dropped MPDUs due to mic failure
from this STA
   * @last_signal: signal of last received frame from this STA
   * @avg_signal: moving average of signal of received frames from this STA
+ * @last_ack_signal: signal of last received Ack frame from this STA
   * @last_seq_ctrl: last received seq/frag number from this STA (per RX
queue)
   * @tx_filtered_count: number of frames the hardware filtered for this STA
   * @tx_retry_failed: number of frames that failed retry
@@ -327,8 +329,10 @@ struct sta_info {
  	unsigned long num_duplicates;
  	unsigned long rx_fragments;
  	unsigned long rx_dropped;
+	unsigned long rx_dropped_mic_failure;
  	int last_signal;
  	struct ewma avg_signal;
+	int last_ack_signal;
  	/* Plus 1 for non-QoS frames */
  	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES + 1];

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index ab63237..19baafc 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -539,6 +539,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
struct sk_buff *skb)
  				sta->lost_packets = 0;
  			}
  		}
+		if(acked)
+		sta->last_ack_signal=info->status.ack_signal;
  	}

  	rcu_read_unlock();
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 8bd2f5c..87c0c3c 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -166,6 +166,7 @@ mic_fail:
  	 * a driver that supports HW encryption. Send up the key idx only if
  	 * the key is set.
  	 */
+	 rx->sta->rx_dropped_mic_failure++;


