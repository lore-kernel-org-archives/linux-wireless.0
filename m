Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34826 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbcGOJGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 05:06:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so1362133wmg.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 02:06:49 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 4/4 v2 iface_work] Function renaming
Date: Fri, 15 Jul 2016 12:06:36 +0300
Message-Id: <1468573596-20055-4-git-send-email-br.shurik@gmail.com> (sfid-20160715_110656_145364_002077C9)
In-Reply-To: <1468573596-20055-1-git-send-email-br.shurik@gmail.com>
References: <1468573596-20055-1-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace iee80211 prefix with mac80211 prefix as it affects mac80211
only.

* Was unable to fit mac80211_is_skb_handled_by_frame_control function
signature into 80 char. line, compromised on parenthesis alignment.

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6f55901..bd376e8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1198,9 +1198,9 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = ieee80211_if_free;
 }
 
-static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
-						 struct ieee80211_sub_if_data
-						 *sdata)
+static bool mac80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
+						struct ieee80211_sub_if_data
+						*sdata)
 {
 	struct ieee80211_ra_tid *ra_tid;
 	struct ieee80211_rx_agg *rx_agg;
@@ -1245,9 +1245,8 @@ static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
 	return true;
 }
 
-static bool ieee80211_is_handled_by_frame_control(struct sk_buff *skb,
-						  struct ieee80211_sub_if_data
-						  *sdata)
+static bool mac80211_is_skb_handled_by_frame_control(struct sk_buff *skb,
+			struct ieee80211_sub_if_datai *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -1324,8 +1323,8 @@ static bool ieee80211_is_handled_by_frame_control(struct sk_buff *skb,
 	return true;
 }
 
-static void ieee80211_handle_by_vif_type(struct sk_buff *skb,
-					 struct ieee80211_sub_if_data *sdata)
+static void mac80211_skb_handle_by_vif_type(struct sk_buff *skb,
+					    struct ieee80211_sub_if_data *sdata)
 {
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
@@ -1363,9 +1362,9 @@ static void ieee80211_iface_work(struct work_struct *work)
 
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
-		if (!ieee80211_is_skb_handled_by_pkt_type(skb, sdata) &&
-		    !ieee80211_is_handled_by_frame_control(skb, sdata)) {
-			ieee80211_handle_by_vif_type(skb, sdata);
+		if (!mac80211_is_skb_handled_by_pkt_type(skb, sdata) &&
+		    !mac80211_is_skb_handled_by_frame_control(skb, sdata)) {
+			mac80211_skb_handle_by_vif_type(skb, sdata);
 		}
 
 		kfree_skb(skb);
-- 
2.5.0

