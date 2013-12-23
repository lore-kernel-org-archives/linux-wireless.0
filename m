Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52268 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LWLGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 06:06:05 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so4963667pdj.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Dec 2013 03:06:04 -0800 (PST)
From: fred.chou.nd@gmail.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Chou <fred.chou.nd@gmail.com>
Subject: [PATCH] mac80211: remove redundant flag check
Date: Mon, 23 Dec 2013 19:07:50 +0800
Message-Id: <52b8191b.6ade440a.6499.ffff91da@mx.google.com> (sfid-20131223_120609_896888_3F61C2D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fred Chou <fred.chou.nd@gmail.com>

It's not necessary to check a flag setting and then
set it anyway. The outer condition check is redundant
in the code below. Remove the outer if.

Signed-off-by: Fred Chou  <fred.chou.nd@gmail.com>
---
 net/mac80211/tx.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2f0e176..52bb276 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1157,13 +1157,11 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	} else
 		tx->flags |= IEEE80211_TX_UNICAST;
-
-	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
-		if (!(tx->flags & IEEE80211_TX_UNICAST) ||
-		    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
-		    info->flags & IEEE80211_TX_CTL_AMPDU)
-			info->flags |= IEEE80211_TX_CTL_DONTFRAG;
-	}
+
+	if (!(tx->flags & IEEE80211_TX_UNICAST) ||
+	    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
+	    info->flags & IEEE80211_TX_CTL_AMPDU)
+		info->flags |= IEEE80211_TX_CTL_DONTFRAG;
 
 	if (!tx->sta)
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-- 
1.7.9.5

