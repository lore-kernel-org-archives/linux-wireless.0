Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:39739 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0K2Oyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 09:54:47 -0500
Date: Mon, 29 Nov 2010 15:54:39 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
Message-ID: <20101129145439.GA31910@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_status() documentation says "This function may not be
called in IRQ context", and it is called by rt2800usb
from a workqueue context.  Thus it needs to call
netif_rx_ni() instead of netif_rx().
This change fixes the "NOHZ: local_softirq_pending 08"
messages I've been getting with rt2800usb.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
--
 net/mac80211/status.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index bed7e32..ba8dd8e 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -403,7 +403,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				skb2 = skb_clone(skb, GFP_ATOMIC);
 				if (skb2) {
 					skb2->dev = prev_dev;
-					netif_rx(skb2);
+					netif_rx_ni(skb2);
 				}
 			}
 
@@ -412,7 +412,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_rx_ni(skb);
 		skb = NULL;
 	}
 	rcu_read_unlock();
