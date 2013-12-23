Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:42429 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3LWFLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 00:11:39 -0500
Message-ID: <52B7C5DA.9090307@huawei.com> (sfid-20131223_061747_947916_71EF9CC0)
Date: Mon, 23 Dec 2013 13:10:50 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/21] mac8011: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/mac80211/iface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa9f9d..1773e17 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1497,8 +1497,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			bool used = false;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(local->hw.wiphy->addresses[i].addr,
-					   sdata->vif.addr, ETH_ALEN) == 0) {
+				if (ether_addr_equal_unaligned(local->hw.wiphy->addresses[i].addr, sdata->vif.addr)) {
 					used = true;
 					break;
 				}
@@ -1558,8 +1557,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			val += inc;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(tmp_addr, sdata->vif.addr,
-							ETH_ALEN) == 0) {
+				if (ether_addr_equal_unaligned(tmp_addr, sdata->vif.addr)) {
 					used = true;
 					break;
 				}
-- 
1.8.0


