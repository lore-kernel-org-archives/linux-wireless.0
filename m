Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZGXX51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 19:57:27 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	davidepesa@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: fix oops due to missing private data
Date: Fri, 24 Jul 2009 19:57:25 -0400
Message-Id: <1248479845-22677-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was caused by patch:

"mac80211: cooperate more with network namespaces"

The version of the patch applied doesn't match Johannes' latest:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-netns.patch

The skb->cb virtual interface data wasn't being reset for
reuse so ath9k pooped out when trying to dereference the
private rate control info from the skb.

BUG: unable to handle kernel NULL pointer dereference
RIP: 0010:[<ffffffffa0258173>] ath_tx_rc_status+0x33/0x150 [ath9k]
<-- snip etc -->

Reported-by: Davide Pesavento <davidepesa@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1b9e081..2cf9ff7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1170,13 +1170,15 @@ static int __ieee80211_tx(struct ieee80211_local *local,
 		}
 
 		ret = drv_tx(local, skb);
-		info->control.vif = &sdata->vif;
 		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
 			dev_kfree_skb(skb);
 			ret = NETDEV_TX_OK;
 		}
-		if (ret != NETDEV_TX_OK)
+		if (ret != NETDEV_TX_OK) {
+			info->control.vif = &sdata->vif;
 			return IEEE80211_TX_AGAIN;
+		}
+
 		*skbp = skb = next;
 		ieee80211_led_tx(local, 1);
 		fragm = true;
-- 
1.6.0.4

