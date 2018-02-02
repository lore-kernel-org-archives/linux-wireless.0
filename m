Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46041 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbeBBPLO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 10:11:14 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] mac80211: Adjust TSQ pacing shift
Date: Fri,  2 Feb 2018 16:11:05 +0100
Message-Id: <20180202151105.30043-1-toke@toke.dk> (sfid-20180202_161118_455742_0963E55B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have the convenient helper to do so, actually adjust the
TSQ pacing shift for packets going out over a WiFi interface. This
significantly improves throughput for locally-originated TCP
connections. The default pacing shift of 10 corresponds to ~1ms of
queued packet data. Adjusting this to a shift of 8 (i.e. ~4ms) improves
1-hop throughput for ath9k by a factor of 3, whereas increasing it more
has diminishing returns.

Achieved throughput for different values of sk_pacing_shift (average of
5 iterations of 10-sec netperf runs to a host on the other side of the
WiFi hop):

sk_pacing_shift 10:  43.21 Mbps (pre-patch)
sk_pacing_shift  9:  78.17 Mbps
sk_pacing_shift  8: 123.94 Mbps
sk_pacing_shift  7: 128.31 Mbps

Latency for competing flows increases from ~3 ms to ~10 ms with this
change. This is about the same magnitude of queueing latency induced by
flows that are not originated on the WiFi device itself (and so are not
limited by TSQ).

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25904af38839..69722504e3e1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3574,6 +3574,14 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (!IS_ERR_OR_NULL(sta)) {
 		struct ieee80211_fast_tx *fast_tx;
 
+		/* We need a bit of data queued to build aggregates properly, so
+		 * instruct the TCP stack to allow more than a single ms of data
+		 * to be queued in the stack. The value is a bit-shift of 1
+		 * second, so 8 is ~4ms of queued data. Only affects local TCP
+		 * sockets.
+		 */
+		sk_pacing_shift_update(skb->sk, 8);
+
 		fast_tx = rcu_dereference(sta->fast_tx);
 
 		if (fast_tx &&
-- 
2.16.0
