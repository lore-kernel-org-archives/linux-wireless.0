Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59755 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GGNet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 09:34:49 -0400
Received: by wgbdr13 with SMTP id dr13so10090376wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 06:34:48 -0700 (PDT)
Message-Id: <edffedafcc56e4b333030ce4f5f8cf85c56d6ab4.1341667309.git.chunkeey@googlemail.com> (sfid-20120707_153542_185320_D9417AF3)
In-Reply-To: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com>
References: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 7 Jul 2012 15:13:08 +0200
Subject: [PATCH 2/2] mac80211: request TX status for BlockAck Requests
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because ieee80211_tx_status in status.c checks if
outgoing BlockAck requests have been acked, it is
necessary to tell the driver that tx feedback for
this sort of frame is important.

Otherwise, the stack will continue to send the same
BlockAck request over and over, which can cause
the receiver to flush or clean its reorder buffer
over and over.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
AFAICT no driver will be really affected by this patch since
either the TX status is always reported anyway or not at all.

BTW: ieee80211_tx_skb_tid is used by a few other agg functions
(mostly addba/delba), so maybe it would make sense to do the
same there.
---
 net/mac80211/agg-tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5cc1bf7..0eaf245 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -135,7 +135,8 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
+		IEEE80211_TX_CTL_REQ_TX_STATUS;
 	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
-- 
1.7.10

