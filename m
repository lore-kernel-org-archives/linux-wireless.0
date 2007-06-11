Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52820 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbXFKJBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:01:09 -0400
Date: Mon, 11 Jun 2007 17:00:10 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/6] mac80211: fix typo in net/mac80211/ieee80211_sta.c
Message-ID: <20070611090010.GA5570@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo in net/mac80211/ieee80211_sta.c.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/ieee80211.c     |    2 +-
 net/mac80211/ieee80211_sta.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e903197..ffec69b 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1557,7 +1557,7 @@ static int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
 	} else if (sdata->type == IEEE80211_IF_TYPE_STA) {
-		if (dls_link_status(local, skb->data) == DLS_STATUS_OK){
+		if (dls_link_status(local, skb->data) == DLS_STATUS_OK) {
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index fc77345..af9419e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -826,7 +826,7 @@ void ieee80211_send_delts(struct net_device *dev,
 	u8 index = ieee80211_ts_index(direction);
 
 	if (ifsta->ts_data[tsid][index].status == TS_STATUS_UNUSED) {
-		printk(KERN_DEBUG "%s: Tring to delete an ACM disabled TS "
+		printk(KERN_DEBUG "%s: Trying to delete an ACM disabled TS "
 		       "(%u:%u)\n", dev->name, tsid, direction);
 		return;
 	}
-- 
1.5.0.rc2.g73a2
