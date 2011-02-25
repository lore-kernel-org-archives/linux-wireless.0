Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37639 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYWN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 17:13:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, kalle.valo@iki.fi, kvalo@adurom.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] at76c50x-usb: fix warning caused by at76_mac80211_tx now returning void
Date: Fri, 25 Feb 2011 17:03:56 -0500
Message-Id: <1298671436-2052-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1298666834.4329.20.camel@jlt3.sipsolutions.net>
References: <1298666834.4329.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/at76c50x-usb.o
drivers/net/wireless/at76c50x-usb.c: In function ‘at76_mac80211_tx’:
drivers/net/wireless/at76c50x-usb.c:1759:4: warning: ‘return’ with a value, in function returning void

This is fallout from commit 7bb4568372856688bc070917265bce0b88bb7d4d
("mac80211: make tx() operation return void").

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 drop the frame and return...duh!

Will this hack still work if we drop the frame?  Did it ever work?

 drivers/net/wireless/at76c50x-usb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 10b4393..2986014 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1756,7 +1756,8 @@ static void at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (compare_ether_addr(priv->bssid, mgmt->bssid)) {
 			memcpy(priv->bssid, mgmt->bssid, ETH_ALEN);
 			ieee80211_queue_work(hw, &priv->work_join_bssid);
-			return NETDEV_TX_BUSY;
+			dev_kfree_skb_any(skb);
+			return;
 		}
 	}
 
-- 
1.7.4

