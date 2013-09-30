Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53469 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3I3Mwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 08:52:34 -0400
Received: by mail-ea0-f181.google.com with SMTP id d10so2700475eaj.12
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 05:52:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: simon.wunderlich@s2003.tu-chemnitz.de,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
Date: Mon, 30 Sep 2013 14:52:37 +0200
Message-Id: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20130930_145237_378765_F25FE9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow management frame injection on DFS channels if the channel has been CAC
checked and is available

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..edb1d3e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1694,8 +1694,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-			    IEEE80211_CHAN_PASSIVE_SCAN)))
+	if (((chan->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
+			     IEEE80211_CHAN_NO_IBSS))) ||
+	    ((chan->flags & IEEE80211_CHAN_RADAR) &&
+	     chan->dfs_state != NL80211_DFS_AVAILABLE))
 		goto fail_rcu;
 
 	ieee80211_xmit(sdata, skb, chan->band);
-- 
1.8.1.2

