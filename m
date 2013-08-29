Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34331 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3H2VfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 17:35:10 -0400
Received: by mail-lb0-f176.google.com with SMTP id y6so1194602lbh.21
        for <linux-wireless@vger.kernel.org>; Thu, 29 Aug 2013 14:35:08 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: [PATCH] mac80211: Remove superfluous is_multicast_ether_addr() call
Date: Fri, 30 Aug 2013 01:35:09 +0400
Message-Id: <1377812109-22889-1-git-send-email-ryazanov.s.a@gmail.com> (sfid-20130829_233515_689438_B96D6E19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove superfluous call and use locally stored previous result.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..102ce8a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1981,7 +1981,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * EAPOL frames from the local station.
 	 */
 	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
-		     !is_multicast_ether_addr(hdr.addr1) && !authorized &&
+		     !multicast && !authorized &&
 		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-- 
1.8.1.5

