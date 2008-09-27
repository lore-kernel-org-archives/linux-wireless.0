Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3566 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYI0T6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 15:58:23 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: remove shadowed variables in ieee80211_master_start_xmit
Date: Sat, 27 Sep 2008 22:58:18 +0300
Message-Id: <1222545498-2920-1-git-send-email-tomas.winkler@intel.com> (sfid-20080927_215827_038019_F8F8D276)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes doubly defined variables in ieee80211_master_start_xmit

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0cc2e23..a413d04 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1255,13 +1255,12 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 	return 0;
 }
 
-int ieee80211_master_start_xmit(struct sk_buff *skb,
-				struct net_device *dev)
+int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
 	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct net_device *odev = NULL;
 	struct ieee80211_sub_if_data *osdata;
 	int headroom;
@@ -1308,8 +1307,6 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 		}
 	} else if (unlikely(osdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		struct ieee80211_sub_if_data *sdata;
-		struct ieee80211_local *local = osdata->local;
-		struct ieee80211_hdr *hdr;
 		int hdrlen;
 		u16 len_rthdr;
 
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

