Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58663 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab3AMWK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 17:10:28 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix monitor mode injection
Date: Sun, 13 Jan 2013 23:10:26 +0100
Message-Id: <1358115026-6090-1-git-send-email-nbd@openwrt.org> (sfid-20130113_231034_372662_0597F1DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel contexts are not always used with monitor interfaces. If no channel
context is set, use the oper channel, otherwise tx fails.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9eadc4..8010879 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1673,10 +1673,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 			chanctx_conf =
 				rcu_dereference(tmp_sdata->vif.chanctx_conf);
 	}
-	if (!chanctx_conf)
-		goto fail_rcu;
-
-	chan = chanctx_conf->def.chan;
+	if (chanctx_conf)
+		chan = chanctx_conf->def.chan;
+	else
+		chan = local->_oper_channel;
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
-- 
1.8.0.2

