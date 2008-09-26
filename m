Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYIZLfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:35:00 -0400
Subject: [PATCH] mac80211: fixups for "make master iface not wireless"
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com> (sfid-20080926_110153_430052_F995BFEF)
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20080926_110153_430052_F995BFEF)
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:34:54 +0200
Message-Id: <1222428894.10563.115.camel@johannes.berg> (sfid-20080926_133511_943908_6A302BB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In "mac80211: make master iface not wireless" I accidentally
forgot to include these changes ... leading to the expected
BUG_ON errors.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
The wme.c change is pretty much identical to Luis's fix,
the iface.c change is not strictly required, it's just an
additional cleanup.

Sorry I goofed this, it seems I simply forgot to 'quilt edit' the two
files in question, this is the diff I had in my tree after quilt pop -a.

 net/mac80211/iface.c |    9 ++++-----
 net/mac80211/wme.c   |    8 ++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-09-26 13:31:28.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-26 13:31:32.000000000 +0200
@@ -58,8 +58,9 @@ static inline int identical_mac_addr_all
 
 static int ieee80211_open(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata, *nsdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *nsdata;
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_if_init_conf conf;
 	u32 changed = 0;
@@ -67,8 +68,6 @@ static int ieee80211_open(struct net_dev
 	bool need_hw_reconfig = 0;
 	u8 null_addr[ETH_ALEN] = {0};
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	/* fail early if user set an invalid address */
 	if (compare_ether_addr(dev->dev_addr, null_addr) &&
 	    !is_valid_ether_addr(dev->dev_addr))
@@ -512,8 +511,8 @@ static int ieee80211_stop(struct net_dev
 
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	int allmulti, promisc, sdata_allmulti, sdata_promisc;
 
 	allmulti = !!(dev->flags & IFF_ALLMULTI);
--- everything.orig/net/mac80211/wme.c	2008-09-26 13:31:28.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-09-26 13:31:32.000000000 +0200
@@ -73,9 +73,8 @@ static int wme_downgrade_ac(struct sk_bu
 
 
 /* Indicate which queue to use.  */
-static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
+static u16 classify80211(struct ieee80211_local *local, struct sk_buff *skb)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
@@ -113,14 +112,15 @@ static u16 classify80211(struct sk_buff 
 
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
+	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
+	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
 
-	queue = classify80211(skb, dev);
+	queue = classify80211(local, skb);
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 


