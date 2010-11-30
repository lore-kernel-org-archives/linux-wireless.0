Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:59330 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0K3Ptc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:49:32 -0500
Date: Tue, 30 Nov 2010 16:49:23 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH v4] mac80211/rt2x00: add ieee80211_tx_status_ni()
Message-ID: <20101130154923.GA4618@sig21.net>
References: <20101129145439.GA31910@sig21.net>
 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
 <20101129152735.GA32319@sig21.net>
 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
 <20101129155126.GA32482@sig21.net>
 <1291046320.3532.6.camel@jlt3.sipsolutions.net>
 <20101129161316.GA32760@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101129161316.GA32760@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All rt2x00 drivers except rt2800pci call ieee80211_tx_status() from
a workqueue, which causes "NOHZ: local_softirq_pending 08" messages.

To fix it, add ieee80211_tx_status_ni() similar to ieee80211_rx_ni()
which can be called from process context, and call it from
rt2x00lib_txdone().  For the rt2800pci special case a driver
flag is introduced.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
v2: add ieee80211_tx_status_ni()
v3: simplify accorindg to review
v4: add rt2x00 as first user of ieee80211_tx_status_ni()

The DRIVER_REQUIRE_TASKLET_CONTEXT flag may seem ugly, but there is
a pending rewrite of the rt2800pci irq handling code by
Helmut, so we decided to use this easy solution.

Note: Only tested with rt2800usb.

 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |    9 ++++++---
 include/net/mac80211.h                  |   28 ++++++++++++++++++++++++----
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b48d2d3..3ef0228 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -932,6 +932,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_TASKLET_CONTEXT, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 556b744..28ea59a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -670,6 +670,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_COPY_IV,
 	DRIVER_REQUIRE_L2PAD,
 	DRIVER_REQUIRE_TXSTATUS_FIFO,
+	DRIVER_REQUIRE_TASKLET_CONTEXT,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 87a421b..fa74acd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -376,9 +376,12 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * through a mac80211 library call (RTS/CTS) then we should not
 	 * send the status report back.
 	 */
-	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
-		ieee80211_tx_status(rt2x00dev->hw, entry->skb);
-	else
+	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211)) {
+		if (test_bit(DRIVER_REQUIRE_TASKLET_CONTEXT, &rt2x00dev->flags))
+			ieee80211_tx_status(rt2x00dev->hw, entry->skb);
+		else
+			ieee80211_tx_status_ni(rt2x00dev->hw, entry->skb);
+	} else
 		dev_kfree_skb_any(entry->skb);
 
 	/*
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
-- 
1.7.2.3

