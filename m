Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:2728 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLAL45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:56:57 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1269845nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:56:55 -0800 (PST)
Message-ID: <eb3ff54b0812010356g1b11c68fkbbfce711313894d8@mail.gmail.com> (sfid-20081201_125700_838390_31A1BC93)
Date: Mon, 1 Dec 2008 13:56:55 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] mac80211: tx module cleanup.
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary parameter in ieee80211_beacon_add_tim() and
removes unneeded definition and assignment for bdev (instance of net_device) in
ieee80211_beacon_get() and in ieee80211_get_buffered_bc()
(all in tx.c).

(this patch was prepared in wireless-testing tree).

Signed-off-by: Rami Rosen <ramirose@gmail.com>




diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0855cac..3f55138 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1783,8 +1783,7 @@ void ieee80211_tx_pending(unsigned long data)

 /* functions for drivers to get certain frames */

-static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
-				     struct ieee80211_if_ap *bss,
+static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
 				     struct sk_buff *skb,
 				     struct beacon_data *beacon)
 {
@@ -1852,7 +1851,6 @@ struct sk_buff *ieee80211_beacon_get(struct
ieee80211_hw *hw,
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
-	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
 	struct ieee80211_if_sta *ifsta = NULL;
@@ -1865,7 +1863,6 @@ struct sk_buff *ieee80211_beacon_get(struct
ieee80211_hw *hw,
 	rcu_read_lock();

 	sdata = vif_to_sdata(vif);
-	bdev = sdata->dev;

 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		ap = &sdata->u.ap;
@@ -1893,12 +1890,12 @@ struct sk_buff *ieee80211_beacon_get(struct
ieee80211_hw *hw,
 			 * of the tim bitmap in mac80211 and the driver.
 			 */
 			if (local->tim_in_locked_section) {
-				ieee80211_beacon_add_tim(local, ap, skb, beacon);
+				ieee80211_beacon_add_tim(ap, skb, beacon);
 			} else {
 				unsigned long flags;

 				spin_lock_irqsave(&local->sta_lock, flags);
-				ieee80211_beacon_add_tim(local, ap, skb, beacon);
+				ieee80211_beacon_add_tim(ap, skb, beacon);
 				spin_unlock_irqrestore(&local->sta_lock, flags);
 			}

@@ -2020,14 +2017,12 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct sta_info *sta;
 	struct ieee80211_tx_data tx;
-	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_tx_info *info;

 	sdata = vif_to_sdata(vif);
-	bdev = sdata->dev;
 	bss = &sdata->u.ap;

 	if (!bss)
