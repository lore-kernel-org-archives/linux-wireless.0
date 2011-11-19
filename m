Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42716 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1KSTKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 14:10:42 -0500
Received: by bke11 with SMTP id 11so4790759bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 11:10:40 -0800 (PST)
Message-Id: <6fa261d3570aa403491add7399e1b8b8c4fac143.1321729714.git.chunkeey@googlemail.com> (sfid-20111119_201044_400626_8A346CCE)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 19 Nov 2011 19:25:02 +0100
Subject: [PATCH 1/2] p54: use ieee80211_free_txskb
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the past, it was fine to simply call
dev_kfree_skb when it was impossible to
transmit a skb. However, with the new
tx status API:
"mac80211: implement wifi TX status"
Every loose skb needs to be handed back
to mac80211.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/txrx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 6ed9c32..42b97bc 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -242,7 +242,7 @@ void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 	skb_unlink(skb, &priv->tx_queue);
 	p54_tx_qos_accounting_free(priv, skb);
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(dev, skb);
 }
 EXPORT_SYMBOL_GPL(p54_free_skb);
 
@@ -788,7 +788,7 @@ void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
 			    &hdr_flags, &aid, &burst_allowed);
 
 	if (p54_tx_qos_accounting_alloc(priv, skb, queue)) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev, skb);
 		return;
 	}
 
-- 
1.7.7.3

