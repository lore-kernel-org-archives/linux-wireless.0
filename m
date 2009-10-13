Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43539 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZJMRe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 13:34:57 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/2] mac80211: add ieee80211_rx_ni()
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Tue, 13 Oct 2009 20:33:13 +0300
Message-ID: <20091013173313.13021.80289.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

ieee80211_rx() must be called with bottom halves disabled. To simplify
driver development implement ieee80211_rx_ni() which disables BH. This
function must be used when in process context.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c75b960..c42c4a8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1665,11 +1665,11 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  * header if %RX_FLAG_RADIOTAP is set in the @status flags.
  *
  * This function may not be called in IRQ context. Calls to this function
- * for a single hardware must be synchronized against each other. Calls
- * to this function and ieee80211_rx_irqsafe() may not be mixed for a
- * single hardware.
+ * for a single hardware must be synchronized against each other. Calls to
+ * this function, ieee80211_rx_ni() and ieee80211_rx_irqsafe() may not be
+ * mixed for a single hardware.
  *
- * Note that right now, this function must be called with softirqs disabled.
+ * In process context use instead ieee80211_rx_ni().
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -1682,8 +1682,8 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
  * Like ieee80211_rx() but can be called in IRQ context
  * (internally defers to a tasklet.)
  *
- * Calls to this function and ieee80211_rx() may not be mixed for a
- * single hardware.
+ * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
+ * be mixed for a single hardware.
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -1691,6 +1691,26 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
+ * ieee80211_rx_ni - receive frame (in process context)
+ *
+ * Like ieee80211_rx() but can be called in process context
+ * (internally disables bottom halves).
+ *
+ * Calls to this function, ieee80211_rx() and ieee80211_rx_irqsafe() may
+ * not be mixed for a single hardware.
+ *
+ * @hw: the hardware this frame came in on
+ * @skb: the buffer to receive, owned by mac80211 after this call
+ */
+static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
+				   struct sk_buff *skb)
+{
+	local_bh_disable();
+	ieee80211_rx(hw, skb);
+	local_bh_enable();
+}
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been

