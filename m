Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424713Ab2LGWOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:14:41 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so648555pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:14:41 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [RFCv3 3/5] mac80211: move add_tim to subfunction
Date: Fri,  7 Dec 2012 14:14:01 -0800
Message-Id: <1354918443-3076-4-git-send-email-marco@cozybit.com> (sfid-20121207_231457_276003_609F3849)
In-Reply-To: <1354918443-3076-1-git-send-email-marco@cozybit.com>
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This functions will be used for mesh beacons, too.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/mac80211/tx.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d287a4f..7155199 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2261,9 +2261,9 @@ void ieee80211_tx_pending(unsigned long data)
 
 /* functions for drivers to get certain frames */
 
-static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
-				     struct ps_data *ps,
-				     struct sk_buff *skb)
+static void __ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
+				       struct ps_data *ps,
+				       struct sk_buff *skb)
 {
 	u8 *pos, *tim;
 	int aid0 = 0;
@@ -2325,6 +2325,31 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
+				    struct ps_data *ps,
+				    struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	/* Not very nice, but we want to allow the driver to call
+	 * ieee80211_beacon_get() as a response to the set_tim() callback.
+	 * That, however, is already invoked under the sta_lock to guarantee
+	 * consistent and race-free update of the tim bitmap in mac80211 and
+	 * the driver.
+	 */
+	if (local->tim_in_locked_section) {
+		__ieee80211_beacon_add_tim(sdata, ps, skb);
+	} else {
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->tim_lock, flags);
+		__ieee80211_beacon_add_tim(sdata, ps, skb);
+		spin_unlock_irqrestore(&local->tim_lock, flags);
+	}
+
+	return 0;
+}
+
 struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
@@ -2369,22 +2394,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			memcpy(skb_put(skb, beacon->head_len), beacon->head,
 			       beacon->head_len);
 
-			/*
-			 * Not very nice, but we want to allow the driver to call
-			 * ieee80211_beacon_get() as a response to the set_tim()
-			 * callback. That, however, is already invoked under the
-			 * sta_lock to guarantee consistent and race-free update
-			 * of the tim bitmap in mac80211 and the driver.
-			 */
-			if (local->tim_in_locked_section) {
-				ieee80211_beacon_add_tim(sdata, &ap->ps, skb);
-			} else {
-				unsigned long flags;
-
-				spin_lock_irqsave(&local->tim_lock, flags);
-				ieee80211_beacon_add_tim(sdata, &ap->ps, skb);
-				spin_unlock_irqrestore(&local->tim_lock, flags);
-			}
+			ieee80211_beacon_add_tim(sdata, &ap->ps, skb);
 
 			if (tim_offset)
 				*tim_offset = beacon->head_len;
-- 
1.7.9.5

