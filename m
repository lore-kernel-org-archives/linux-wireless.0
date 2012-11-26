Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57582 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab2KZFPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 00:15:51 -0500
Message-ID: <50B2FB02.3090504@posedge.com> (sfid-20121126_061600_567264_B0C8D8DE)
Date: Mon, 26 Nov 2012 10:45:46 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: RFC[1/4] mac80211: add statistic to debugfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide additional statistic support to the debugfs.

Number of rx packets dropped due to mic failure:
Currently the debugfs has support for number of rx packets dropped. But 
it doesn't classify the reason for the drop. This statistic will count 
the number of rx packet dropped due to mic failure.

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.
  net/mac80211/debugfs_sta.c |    1 +
  net/mac80211/sta_info.h    |    2 ++
  net/mac80211/wpa.c         |    1 +
  3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..3bdaedb 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -377,6 +377,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
  	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
  	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
  	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
+	DEBUGFS_ADD_COUNTER(rx_dropped_mic_failure,rx_dropped_mic_failure);
  	DEBUGFS_ADD_COUNTER(tx_fragments, tx_fragments);
  	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
  	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..5ee25b2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -247,6 +247,7 @@ struct sta_ampdu_mlme {
   * @num_duplicates: number of duplicate frames received from this STA
   * @rx_fragments: number of received MPDUs
   * @rx_dropped: number of dropped MPDUs from this STA
+ * @rx_dropped_mic_failure: number of dropped MPDUs due to mic failure 
from this STA
   * @last_signal: signal of last received frame from this STA
   * @avg_signal: moving average of signal of received frames from this STA
   * @last_seq_ctrl: last received seq/frag number from this STA (per RX 
queue)
@@ -326,6 +327,7 @@ struct sta_info {
  	unsigned long num_duplicates;
  	unsigned long rx_fragments;
  	unsigned long rx_dropped;
+	unsigned long rx_dropped_mic_failure;
  	int last_signal;
  	struct ewma avg_signal;
  	/* Plus 1 for non-QoS frames */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
old mode 100644
new mode 100755
index 8bd2f5c..960403e
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
