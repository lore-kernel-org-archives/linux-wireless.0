Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17045 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbXK1G5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 01:57:01 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: Fix behavior of ieee80211_open and ieee80211_close
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2007 01:57:08 -0500
Message-ID: <20071128065708.9961.15992.stgit@tetra.sourmilk.net> (sfid-20071128_065705_054871_55A99BBC)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes:
- Incorrect calls to ieee80211_hw_config when the radiotap flag is set.
- Failure to actually unset the radiotap flag when all monitors are down.
- Failure to call ieee80211_hw_config after successful interface start.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 59350b8..fc8b29c 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -216,6 +216,7 @@ static int ieee80211_open(struct net_device *dev)
 			res = local->ops->start(local_to_hw(local));
 		if (res)
 			return res;
+		ieee80211_hw_config(local);
 	}
 
 	switch (sdata->type) {
@@ -232,7 +233,6 @@ static int ieee80211_open(struct net_device *dev)
 			netif_tx_unlock_bh(local->mdev);
 
 			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-			ieee80211_hw_config(local);
 		}
 		break;
 	case IEEE80211_IF_TYPE_STA:
@@ -334,8 +334,7 @@ static int ieee80211_stop(struct net_device *dev)
 			ieee80211_configure_filter(local);
 			netif_tx_unlock_bh(local->mdev);
 
-			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-			ieee80211_hw_config(local);
+			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
 		}
 		break;
 	case IEEE80211_IF_TYPE_STA:


