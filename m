Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39182 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3AGPFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 10:05:05 -0500
Received: by mail-bk0-f52.google.com with SMTP id w5so8299593bku.25
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 07:05:04 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv2 3/6] mac80211: move add_tim to subfunction
Date: Mon,  7 Jan 2013 16:04:50 +0100
Message-Id: <1357571093-12868-4-git-send-email-marco@cozybit.com> (sfid-20130107_160512_682054_AE366910)
In-Reply-To: <1357571093-12868-1-git-send-email-marco@cozybit.com>
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This functions will be used for mesh beacons, too.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/mac80211/tx.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9eadc4..1b04984 100644
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

