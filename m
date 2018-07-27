Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10145 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730771AbeG0O2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:28:00 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <sgruszka@redhat.com>,
        <helmut.schaa@googlemail.com>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rt2x00:  remove redundant functions rt2x00mac_sta_{add/remove}
Date: Fri, 27 Jul 2018 21:05:49 +0800
Message-ID: <20180727130549.12980-1-yuehaibing@huawei.com> (sfid-20180727_150618_189269_18D003E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only rt2800 subdriver of rt2x00 implement sta_add() and sta_remove(),
rt2x00mac_sta_add and rt2x00mac_sta_remove has no callers after
commit 9c87758cf089 ("rt2x00: call sta_add/remove directly in rt2800").
So can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index c380c1f..fa2fd64 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -527,24 +527,6 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 EXPORT_SYMBOL_GPL(rt2x00mac_set_key);
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
-int rt2x00mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	return rt2x00dev->ops->lib->sta_add(rt2x00dev, vif, sta);
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_sta_add);
-
-int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	return rt2x00dev->ops->lib->sta_remove(rt2x00dev, sta);
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_sta_remove);
-
 void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     const u8 *mac_addr)
-- 
2.7.0
