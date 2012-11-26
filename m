Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57665 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab2KZFR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 00:17:26 -0500
Message-ID: <50B2FB62.2080808@posedge.com> (sfid-20121126_061728_743653_9C6D04D4)
Date: Mon, 26 Nov 2012 10:47:22 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: RFC[2/4] mac80211: add statistic to debugfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide additional statistic support to the debugfs.

Rssi of the Last Ack Frame
         This information is available as part of ieee80211_tx_info 
status structure. Thought this information may be useful(in future).

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.

net/mac80211/debugfs_sta.c |    2 ++
  net/mac80211/sta_info.h    |    2 ++
  net/mac80211/status.c      |    3 +++
  3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..1566941 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -53,6 +53,7 @@ static const struct file_operations sta_ ##name## 
_ops = {		\
  STA_FILE(aid, sta.aid, D);
  STA_FILE(dev, sdata->name, S);
  STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_ack_signal, last_ack_signal, D);

  static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
  			      size_t count, loff_t *ppos)
@@ -369,6 +370,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
  	DEBUGFS_ADD(dev);
  	DEBUGFS_ADD(last_signal);
  	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(last_ack_signal);

  	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
  	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..e1f1fa2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -249,6 +249,7 @@ struct sta_ampdu_mlme {
   * @rx_dropped: number of dropped MPDUs from this STA
   * @last_signal: signal of last received frame from this STA
   * @avg_signal: moving average of signal of received frames from this STA
+ * @last_ack_signal: signal of last received Ack frame from this STA
   * @last_seq_ctrl: last received seq/frag number from this STA (per RX 
queue)
   * @tx_filtered_count: number of frames the hardware filtered for this STA
   * @tx_retry_failed: number of frames that failed retry
@@ -328,6 +329,7 @@ struct sta_info {
  	unsigned long rx_dropped;
  	int last_signal;
  	struct ewma avg_signal;
+	int last_ack_signal;
  	/* Plus 1 for non-QoS frames */
  	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index ab63237..a7f698d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -539,6 +539,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, 
struct sk_buff *skb)
  				sta->lost_packets = 0;
  			}
  		}
+		
+		if (acked)
+			sta->last_ack_signal=info->status.ack_signal;
  	}

  	rcu_read_unlock();
