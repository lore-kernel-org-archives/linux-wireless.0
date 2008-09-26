Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26083 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYIZJBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 05:01:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 02:01:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix oops on wme.c where mdev is assumed to be a wiphy
Date: Fri, 26 Sep 2008 02:01:27 -0700
Message-ID: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com> (sfid-20080926_110153_430052_F995BFEF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After Johannes' patch which set mdev as non wiphy
there were some remaining bits of code which required
changing the assumption that mdev was a wiphy. We
change two callers to get to struct ieee80211_local
the non-wiphy and actual mdev way.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Tested with ath5k on v2.6.27-rc7-1972-gfb8961a.

 net/mac80211/wme.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 6748ded..7d114bd 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -75,8 +75,16 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 /* Indicate which queue to use.  */
 static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_master_priv *mpriv;
+
+	/* this is not for wiphys, just for mdev */
+	BUG_ON (dev->ieee80211_ptr);
+
+	mpriv = netdev_priv(dev);
+	local = mpriv->local;
+
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
 		/* management frames go on AC_VO queue, but are sent
@@ -114,12 +122,19 @@ static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_master_priv *mpriv;
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
 
+	/* this is not for wiphys, just for mdev */
+	BUG_ON (dev->ieee80211_ptr);
+
+	mpriv = netdev_priv(dev);
+	local = mpriv->local;
+
 	queue = classify80211(skb, dev);
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
-- 
1.5.6.rc2.15.g457bb.dirty

