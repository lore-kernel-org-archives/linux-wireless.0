Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33276 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZHTUem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 16:34:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove ieee80211_rx namespace hack
Date: Thu, 20 Aug 2009 16:34:15 -0400
Message-Id: <1250800455-4284-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the libipw naming scheme change, it is no longer necessary for
mac80211 to avoid the ieee80211_rx name clash.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/mac80211.h |   11 +----------
 net/mac80211/rx.c      |    4 ++--
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index aac84d7..466859b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1657,12 +1657,6 @@ void ieee80211_free_hw(struct ieee80211_hw *hw);
  */
 void ieee80211_restart_hw(struct ieee80211_hw *hw);
 
-/*
- * trick to avoid symbol clashes with the ieee80211 subsystem,
- * use the inline below instead
- */
-void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
-
 /**
  * ieee80211_rx - receive frame
  *
@@ -1678,10 +1672,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
  */
-static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	__ieee80211_rx(hw, skb);
-}
+void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
  * ieee80211_rx_irqsafe - receive frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7065fd7..dff2239 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2440,7 +2440,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
@@ -2523,7 +2523,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(__ieee80211_rx);
+EXPORT_SYMBOL(ieee80211_rx);
 
 /* This is a version of the rx handler that can be called from hard irq
  * context. Post the skb on the queue and schedule the tasklet */
-- 
1.6.2.5

