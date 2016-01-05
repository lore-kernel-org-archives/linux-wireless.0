Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36559 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcAEKf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:35:57 -0500
Received: by mail-lb0-f181.google.com with SMTP id oh2so172591628lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 02:35:56 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/2] mac80211: check requested flags in ieee80211_tx_prepare_skb()
Date: Tue,  5 Jan 2016 11:35:33 +0100
Message-Id: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_113606_571114_162A991B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case driver already set info->flags (eg. IEEE80211_TX_CTL_NO_CCK_RATE
in ath9k driver), before this patch we skip this requested flags.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a512c4b..6ea1c65 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1532,6 +1532,7 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_data tx;
 	struct sk_buff *skb2;
+	unsigned int flags = info->flags;
 
 	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
 		return false;
@@ -1539,6 +1540,7 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	info->band = band;
 	info->control.vif = vif;
 	info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
+	info->flags |= flags;
 
 	if (invoke_tx_handlers(&tx))
 		return false;
-- 
1.9.1

