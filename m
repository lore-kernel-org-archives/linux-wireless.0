Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46743 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbbFQIlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/14] mac80211: fix comment referring to RX queue
Date: Wed, 17 Jun 2015 10:41:07 +0200
Message-Id: <1434530475-3553-7-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104133_646035_2B9D9FA0)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are no RX queues in mac80211 (yet), the comment should refer
to the TID (including one slot for non-QoS) rather than 'RX queue'.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 147464dbc455..db76103b4445 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -317,7 +317,8 @@ struct ieee80211_fast_tx {
  * @last_signal: signal of last received frame from this STA
  * @avg_signal: moving average of signal of received frames from this STA
  * @last_ack_signal: signal of last received Ack frame from this STA
- * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
+ * @last_seq_ctrl: last received seq/frag number from this STA (per TID
+ *	plus one for non-QoS frames)
  * @tx_filtered_count: number of frames the hardware filtered for this STA
  * @tx_retry_failed: number of frames that failed retry
  * @tx_retry_count: total number of retries for frames to this STA
-- 
2.1.4

