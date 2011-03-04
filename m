Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44382 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1CDMbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 07:31:46 -0500
Received: by bwz15 with SMTP id 15so2003024bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 04:31:45 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Remove redundant preamble and RTS flag setup in minstrel_ht
Date: Fri,  4 Mar 2011 13:31:31 +0100
Message-Id: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 does the same afterwards anyway. Hence, just drop
this redundant code.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 165a451..775cf15 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -519,9 +519,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		rate->count = mr->retry_count;
 
 	rate->flags = IEEE80211_TX_RC_MCS | group->flags;
-	if (txrc->short_preamble)
-		rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
-	if (txrc->rts || rtscts)
+	if (rtscts)
 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 	rate->idx = index % MCS_GROUP_RATES + (group->streams - 1) * MCS_GROUP_RATES;
 }
-- 
1.7.1

