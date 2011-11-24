Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52749 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1KXO5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 09:57:00 -0500
Received: by faas1 with SMTP id s1so1647292faa.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 06:56:59 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: call skb_put() before copying the data (trivial)
Date: Thu, 24 Nov 2011 16:50:00 +0200
Message-Id: <1322146200-2819-1-git-send-email-eliad@wizery.com> (sfid-20111124_155705_349809_A7645334)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't have any actual effect here, but we should
skb_put() *before* copying the data.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6b86f77..b1661ba 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2177,10 +2177,10 @@ static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
 		/* Bitmap control */
 		*pos++ = n1 | aid0;
 		/* Part Virt Bitmap */
+		skb_put(skb, n2 - n1);
 		memcpy(pos, bss->tim + n1, n2 - n1 + 1);
 
 		tim[1] = n2 - n1 + 4;
-		skb_put(skb, n2 - n1);
 	} else {
 		*pos++ = aid0; /* Bitmap control */
 		*pos++ = 0; /* Part Virt Bitmap */
-- 
1.7.6.401.g6a319

