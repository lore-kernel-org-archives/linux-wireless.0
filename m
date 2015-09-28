Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37990 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbI1S6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:58:43 -0400
Received: by wiclk2 with SMTP id lk2so115133413wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2015 11:58:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, helmut.schaa@googlemail.com
Subject: [PATCH] mac80211: fix oops in ieee80211_beacon_get_tim
Date: Mon, 28 Sep 2015 20:58:40 +0200
Message-ID: <1673287.PfdWxMzLgk@debian64> (sfid-20150928_205846_584254_D06C25C4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a crash which is triggered
by __ieee80211_beacon_get returning NULL.
This causes sky_copy to crash later unless
the hardware supports BEACON_TX_STATUS
feature.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
"mac80211: Copy tx'ed beacons to monitor mode" added the skb_copy.
There are few other possibilities to do this. This is just one.
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f7317a7..666e46b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3530,6 +3530,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	int shift;
 
+	if (!bcn)
+		return bcn;
+
 	if (tim_offset)
 		*tim_offset = offs.tim_offset;
 
-- 
2.5.3

