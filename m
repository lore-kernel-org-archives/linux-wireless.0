Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61844 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZAFIue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:50:34 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so8320605ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:50:33 -0800 (PST)
Message-ID: <eb3ff54b0901060050g475209d2m75ee43baa0af89c0@mail.gmail.com> (sfid-20090106_095038_296644_BF559A3A)
Date: Tue, 6 Jan 2009 10:50:33 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/6] mac80211: remove an unnecessary assignment to info in __ieee80211_tx().
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes an unnecessary assignment to info
in __ieee80211_tx() , tx.c.

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c723dcc..2627da8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1055,7 +1055,6 @@ static int __ieee80211_tx(struct ieee80211_local
*local, struct sk_buff *skb,
 	if (skb) {
 		if (netif_subqueue_stopped(local->mdev, skb))
 			return IEEE80211_TX_AGAIN;
-		info =  IEEE80211_SKB_CB(skb);

 		ret = local->ops->tx(local_to_hw(local), skb);
 		if (ret)
