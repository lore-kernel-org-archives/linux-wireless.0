Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:56998 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992684Ab2K3TZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 14:25:28 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix redundant if in transmit path
Date: Fri, 30 Nov 2012 20:25:14 +0100
Message-Id: <1354303514-20255-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121130_202538_071123_76703A96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is already in the right switch branch, no need to check again and
provoke a compiler warning about chanctx_conf might be used
uninitialized.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/tx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d287a4f..ccf0499 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1790,8 +1790,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
 		band = chanctx_conf->def.chan->band;
-- 
1.7.10.4

