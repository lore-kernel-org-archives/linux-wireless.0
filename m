Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:50589 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0K2Pve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:51:34 -0500
Date: Mon, 29 Nov 2010 16:51:26 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
Message-ID: <20101129155126.GA32482@sig21.net>
References: <20101129145439.GA31910@sig21.net>
 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
 <20101129152735.GA32319@sig21.net>
 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291045056.3532.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_status() documentation says "This function may not be
called in IRQ context", and it is called by rt2800usb
from a workqueue context.  However, ieee80211_tx_status() is
meant to be called from tasklets and thus uses netif_rx().
Add a new ieee80211_tx_status_ni() which does the same
thing but uses netif_rx_ni() instead of netif_rx().

This change fixes the "NOHZ: local_softirq_pending 08"
messages I've been getting with rt2800usb.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
v2: add ieee80211_tx_status_ni()

Note: the patch is now incomplete, rt2x00lib_txdone() is used by
several drivers and I'm currently checking if ieee80211_tx_status_ni()
can be used by all of them of if I need to split rt2x00lib_txdone()
in two versions.  An updated patch with the rt2x00
changes will follow, but I'm seeking feedback if the base
change here is OK.


 include/net/mac80211.h |   23 +++++++++++++++++++----
 net/mac80211/status.c  |   19 ++++++++++++++++---
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index eaa4aff..df42312 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2055,8 +2055,8 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
  *
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls
- * to this function and ieee80211_tx_status_irqsafe() may not be mixed
- * for a single hardware.
+ * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
+ * may not be mixed for a single hardware.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
@@ -2065,13 +2065,28 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb);
 
 /**
+ * ieee80211_tx_status_ni - transmit status callback (in process context)
+ *
+ * Like ieee80211_tx_status() but can be called in process context.
+ *
+ * Calls to this function, ieee80211_tx_status() and
+ * ieee80211_tx_status_irqsafe() may not be mixed
+ * for a single hardware.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @skb: the frame that was transmitted, owned by mac80211 after this call
+ */
+void ieee80211_tx_status_ni(struct ieee80211_hw *hw,
+			    struct sk_buff *skb);
+
+/**
  * ieee80211_tx_status_irqsafe - IRQ-safe transmit status callback
  *
  * Like ieee80211_tx_status() but can be called in IRQ context
  * (internally defers to a tasklet.)
  *
- * Calls to this function and ieee80211_tx_status() may not be mixed for a
- * single hardware.
+ * Calls to this function, ieee80211_tx_status() and
+ * ieee80211_tx_status_ni() may not be mixed for a single hardware.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index bed7e32..ce4d239 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -170,7 +170,8 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
  */
 #define STA_LOST_PKT_THRESHOLD	50
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+void __ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
+			   int (*netif_rx_func)(struct sk_buff *skb))
 {
 	struct sk_buff *skb2;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -403,7 +404,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				skb2 = skb_clone(skb, GFP_ATOMIC);
 				if (skb2) {
 					skb2->dev = prev_dev;
-					netif_rx(skb2);
+					netif_rx_func(skb2);
 				}
 			}
 
@@ -412,10 +413,22 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_rx_func(skb);
 		skb = NULL;
 	}
 	rcu_read_unlock();
 	dev_kfree_skb(skb);
 }
+
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	__ieee80211_tx_status(hw, skb, netif_rx);
+}
 EXPORT_SYMBOL(ieee80211_tx_status);
+
+void ieee80211_tx_status_ni(struct ieee80211_hw *hw,
+			    struct sk_buff *skb)
+{
+	__ieee80211_tx_status(hw, skb, netif_rx_ni);
+}
+EXPORT_SYMBOL(ieee80211_tx_status_ni);
