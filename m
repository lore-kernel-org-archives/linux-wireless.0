Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYBYPcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:20 -0500
Message-Id: <20080225153004.058646000@sipsolutions.net> (sfid-20080225_153231_652593_151D12E9)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 01/10] mac80211: clarify use of TX status/RX callbacks
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch clarifies the use of the irqsafe vs. non-irq-safe
functions and their respective locking requirements.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-02-23 15:13:24.000000000 +0100
+++ everything/include/net/mac80211.h	2008-02-24 10:07:07.000000000 +0100
@@ -38,7 +38,11 @@
  * called in hardware interrupt context. The low-level driver must not call any
  * other functions in hardware interrupt context. If there is a need for such
  * call, the low-level driver should first ACK the interrupt and perform the
- * IEEE 802.11 code call after this, e.g. from a scheduled workqueue function.
+ * IEEE 802.11 code call after this, e.g. from a scheduled workqueue or even
+ * tasklet function.
+ *
+ * NOTE: If the driver opts to use the _irqsafe() functions, it may not also
+ *	 use the non-irqsafe functions!
  */
 
 /**
@@ -1213,7 +1217,10 @@ void __ieee80211_rx(struct ieee80211_hw 
  * buffer in @skb must start with an IEEE 802.11 header or a radiotap
  * header if %RX_FLAG_RADIOTAP is set in the @status flags.
  *
- * This function may not be called in IRQ context.
+ * This function may not be called in IRQ context. Calls to this function
+ * for a single hardware must be synchronized against each other. Calls
+ * to this function and ieee80211_rx_irqsafe() may not be mixed for a
+ * single hardware.
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -1230,7 +1237,10 @@ static inline void ieee80211_rx(struct i
  * ieee80211_rx_irqsafe - receive frame
  *
  * Like ieee80211_rx() but can be called in IRQ context
- * (internally defers to a workqueue.)
+ * (internally defers to a tasklet.)
+ *
+ * Calls to this function and ieee80211_rx() may not be mixed for a
+ * single hardware.
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -1249,6 +1259,11 @@ void ieee80211_rx_irqsafe(struct ieee802
  * transmitted. It is permissible to not call this function for
  * multicast frames but this can affect statistics.
  *
+ * This function may not be called in IRQ context. Calls to this function
+ * for a single hardware must be synchronized against each other. Calls
+ * to this function and ieee80211_tx_status_irqsafe() may not be mixed
+ * for a single hardware.
+ *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  * @status: status information for this frame; the status pointer need not
@@ -1258,6 +1273,22 @@ void ieee80211_rx_irqsafe(struct ieee802
 void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb,
 			 struct ieee80211_tx_status *status);
+
+/**
+ * ieee80211_tx_status_irqsafe - irq-safe transmit status callback
+ *
+ * Like ieee80211_tx_status() but can be called in IRQ context
+ * (internally defers to a tasklet.)
+ *
+ * Calls to this function and ieee80211_tx_status() may not be mixed for a
+ * single hardware.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @skb: the frame that was transmitted, owned by mac80211 after this call
+ * @status: status information for this frame; the status pointer need not
+ *	be valid after this function returns and is not freed by mac80211,
+ *	it is recommended that it points to a stack area
+ */
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb,
 				 struct ieee80211_tx_status *status);

-- 

