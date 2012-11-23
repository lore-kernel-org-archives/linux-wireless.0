Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40102 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2KWUTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:30 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 12/13] mac80211: add TIM IE to mesh beacons
Date: Fri, 23 Nov 2012 12:18:53 -0800
Message-Id: <1353701934-12752-13-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_214526_175142_119FB9A2)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a TIM IE similarly to AP mode and add it to mesh beacons.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/tx.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1194020..44a597b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2332,6 +2332,31 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static int mesh_add_tim_ie(struct sk_buff *skb,
+			   struct ieee80211_sub_if_data *sdata,
+			   u16 *tim_offset, u16 *tim_length)
+{
+	struct ieee80211_local *local = sdata->local;
+	u16 tmp = skb->len;
+
+	if (local->tim_in_locked_section) {
+		ieee80211_beacon_add_tim(sdata, &sdata->u.mesh.ps, skb);
+	} else {
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->tim_lock, flags);
+		ieee80211_beacon_add_tim(sdata, &sdata->u.mesh.ps, skb);
+		spin_unlock_irqrestore(&local->tim_lock, flags);
+	}
+
+	if (tim_offset)
+		*tim_offset = tmp - local->hw.extra_tx_headroom;
+	if (tim_length)
+		*tim_length = skb->len - tmp;
+
+	return 0;
+}
+
 struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
@@ -2439,6 +2464,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + /* NULL SSID */
 				    2 + 8 + /* supported rates */
 				    2 + 3 + /* DS params */
+				    256 + /* TIM IE */
 				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 				    2 + sizeof(struct ieee80211_ht_cap) +
 				    2 + sizeof(struct ieee80211_ht_operation) +
@@ -2472,6 +2498,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
+		    mesh_add_tim_ie(skb, sdata, tim_offset, tim_length) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
-- 
1.7.9.5

