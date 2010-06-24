Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58807 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0FXPPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: don't shadow mgmt variable in ieee80211_rx_h_action
Date: Thu, 24 Jun 2010 11:14:51 -0400
Message-Id: <1277392491-10525-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/rx.c:2059:39: warning: symbol 'mgmt' shadows an earlier one
net/mac80211/rx.c:1916:31: originally declared here

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f76352..ab58a5d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2056,11 +2056,11 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	nskb = skb_copy_expand(rx->skb, local->hw.extra_tx_headroom, 0,
 			       GFP_ATOMIC);
 	if (nskb) {
-		struct ieee80211_mgmt *mgmt = (void *)nskb->data;
+		struct ieee80211_mgmt *nmgmt = (void *)nskb->data;
 
-		mgmt->u.action.category |= 0x80;
-		memcpy(mgmt->da, mgmt->sa, ETH_ALEN);
-		memcpy(mgmt->sa, rx->sdata->vif.addr, ETH_ALEN);
+		nmgmt->u.action.category |= 0x80;
+		memcpy(nmgmt->da, nmgmt->sa, ETH_ALEN);
+		memcpy(nmgmt->sa, rx->sdata->vif.addr, ETH_ALEN);
 
 		memset(nskb->cb, 0, sizeof(nskb->cb));
 
-- 
1.7.0.1

