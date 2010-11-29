Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:54107 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0K2QNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 11:13:25 -0500
Date: Mon, 29 Nov 2010 17:13:16 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH v3 RFC] mac80211: add ieee80211_tx_status_ni()
Message-ID: <20101129161316.GA32760@sig21.net>
References: <20101129145439.GA31910@sig21.net>
 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
 <20101129152735.GA32319@sig21.net>
 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
 <20101129155126.GA32482@sig21.net>
 <1291046320.3532.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291046320.3532.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_status() documentation says "This function may not be
called in IRQ context", and it is called by rt2800usb
from a workqueue context.  However, ieee80211_tx_status() is
meant to be called from tasklets and thus uses netif_rx().
Add a new ieee80211_tx_status_ni() which does the same
thing but is safe to be called from process context.

Using ieee80211_tx_status_ni() for rt2800usb fixes the
"NOHZ: local_softirq_pending 08" messages I've been getting.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
v2: add ieee80211_tx_status_ni()
v3: simplify accorindg to review

Note: the patch is now incomplete, rt2x00lib_txdone() is used by
several drivers, rt2800usb calls it from a workqueue while
e.g. while rt2800pci calls it from a tasklet
(rt2800pci_txstatus_tasklet).  I need to sort this out with
the rt2x00 developers.


 include/net/mac80211.h |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index eaa4aff..e411cf8 100644
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
@@ -2065,13 +2065,33 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
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
+static inline void ieee80211_tx_status_ni(struct ieee80211_hw *hw,
+					  struct sk_buff *skb)
+{
+	local_bh_disable();
+	ieee80211_tx_status(hw, skb);
+	local_bh_enable();
+}
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
