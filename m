Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaBSM0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:26:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with NULL skb
Date: Wed, 19 Feb 2014 13:28:35 +0100
Message-Id: <1392812916-13656-1-git-send-email-sgruszka@redhat.com> (sfid-20140219_132640_718975_460F3097)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we check sta->ps_tx_buf[ac] length without lock, we can get not
updated value. In the worst scenario queue could be currently empty
and we can see length bigger than STA_MAX_TX_BUFFER. When this happen
skb_dequeue() will return NULL and we will crash trying to free NULL
skb:

[ 6335.697678] BUG: unable to handle kernel NULL pointer dereference at 000000ac
[ 6335.697858] IP: [<fefcdc70>] ieee80211_report_used_skb+0x10/0x1e0 [mac80211]
...
[ 6335.700223] Call Trace:
[ 6335.700599]  [<fefcde55>] ieee80211_free_txskb+0x15/0x20 [mac80211]
[ 6335.700697]  [<fefef242>] invoke_tx_handlers+0x1322/0x1370 [mac80211]
[ 6335.700787]  [<c13551b6>] ? dev_hard_start_xmit+0x2b6/0x510
[ 6335.700879]  [<fefef3fb>] ? ieee80211_tx_prepare+0x16b/0x330 [mac80211]
[ 6335.700981]  [<fefef626>] ieee80211_tx+0x66/0xe0 [mac80211]
[ 6335.701072]  [<fefeff43>] ieee80211_xmit+0x93/0xf0 [mac80211]
[ 6335.701163]  [<feff0d45>] ieee80211_subif_start_xmit+0xab5/0xbc0 [mac80211]
[ 6335.701258]  [<c13551b6>] dev_hard_start_xmit+0x2b6/0x510

To fix this problem, recheck queue length with lock taken.

Bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=70551#c11

Reported-and-tested-by: Max Sydorenko <maxim.stargazer@gmail.com>
Fixes: c3e7724b6b ("mac80211: use ieee80211_free_txskb to fix possible skb leaks")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/tx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 722151f..85b9b8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -472,17 +472,25 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		      test_sta_flag(sta, WLAN_STA_PS_DRIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
+		struct sk_buff *old_skb = NULL;
+		unsigned long flags;
 
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
-			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
+			spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
+			/* queue could be modified, recheck length with lock taken */
+			if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER)
+				old_skb = __skb_dequeue(&sta->ps_tx_buf[ac]);
+			spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
+		}
+		if (old_skb) {
 			ps_dbg(tx->sdata,
 			       "STA %pM TX buffer for AC %d full - dropping oldest frame\n",
 			       sta->sta.addr, ac);
-			ieee80211_free_txskb(&local->hw, old);
+			ieee80211_free_txskb(&local->hw, old_skb);
 		} else
 			tx->local->total_ps_buffered++;
 
-- 
1.7.11.7

