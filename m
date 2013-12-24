Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:35332 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3LXLaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 06:30:05 -0500
Message-ID: <52B97009.3020008@huawei.com> (sfid-20131224_123223_695370_6E9D0196)
Date: Tue, 24 Dec 2013 19:29:13 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
MIME-Version: 1.0
To: Solomon Peachy <pizza@shaftnet.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 16/20] cw1200: atm: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use possibly more efficient ether_addr_equal
instead of memcmp.

Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/wireless/cw1200/sta.c  | 5 +++--
 drivers/net/wireless/cw1200/txrx.c | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 010b252..103f7bc 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 
 #include "cw1200.h"
 #include "sta.h"
@@ -555,8 +556,8 @@ u64 cw1200_prepare_multicast(struct ieee80211_hw *hw,
 		pr_debug("[STA] multicast: %pM\n", ha->addr);
 		memcpy(&priv->multicast_filter.macaddrs[count],
 		       ha->addr, ETH_ALEN);
-		if (memcmp(ha->addr, broadcast_ipv4, ETH_ALEN) &&
-		    memcmp(ha->addr, broadcast_ipv6, ETH_ALEN))
+		if (!ether_addr_equal(ha->addr, broadcast_ipv4) &&
+		    !ether_addr_equal(ha->addr, broadcast_ipv6))
 			priv->has_multicast_subscription = true;
 		count++;
 	}
diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index e824d4d..0bd5411 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -1166,8 +1166,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 			return;
 	} else if (ieee80211_is_beacon(frame->frame_control) &&
 		   !arg->status && priv->vif &&
-		   !memcmp(ieee80211_get_SA(frame), priv->vif->bss_conf.bssid,
-			   ETH_ALEN)) {
+		   ether_addr_equal(ieee80211_get_SA(frame), priv->vif->bss_conf.bssid)) {
 		const u8 *tim_ie;
 		u8 *ies = ((struct ieee80211_mgmt *)
 			  (skb->data))->u.beacon.variable;
-- 
1.8.0


