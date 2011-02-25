Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50213 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1BYUqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] at76c50x-usb: fix warning caused by at76_mac80211_tx now returning void
Date: Fri, 25 Feb 2011 15:40:47 -0500
Message-Id: <1298666447-30028-1-git-send-email-linville@tuxdriver.com>
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
 drivers/net/wireless/at76c50x-usb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 10b4393..a37c93b 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1756,7 +1756,6 @@ static void at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (compare_ether_addr(priv->bssid, mgmt->bssid)) {
 			memcpy(priv->bssid, mgmt->bssid, ETH_ALEN);
 			ieee80211_queue_work(hw, &priv->work_join_bssid);
-			return NETDEV_TX_BUSY;
 		}
 	}
 
-- 
1.7.4

