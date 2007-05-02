Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37162 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161764AbXEBVOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 17:14:42 -0400
Received: from griffin.suse.cz (griffin.suse.cz [10.20.1.99])
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 787E46280B5
	for <linux-wireless@vger.kernel.org>; Wed,  2 May 2007 23:14:41 +0200 (CEST)
Date: Wed, 2 May 2007 23:14:25 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix false lockdep warning
Message-ID: <20070502231425.135f87b4@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes lockdep aware of xmit_lock hierarchy between master and virtual
interfaces.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/ieee80211.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

--- mac80211.orig/net/mac80211/ieee80211.c
+++ mac80211/net/mac80211/ieee80211.c
@@ -2167,6 +2167,16 @@ static int ieee80211_change_mtu_apdev(st
 	return 0;
 }
 
+enum netif_tx_lock_class {
+	TX_LOCK_NORMAL,
+	TX_LOCK_MASTER,
+}
+
+static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
+{
+	spin_lock_nested(&dev->_xmit_lock, subclass);
+	dev->xmit_lock_owner = smp_processor_id();
+}
 
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
@@ -2174,7 +2184,7 @@ static void ieee80211_set_multicast_list
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	unsigned short flags;
 
-	netif_tx_lock(local->mdev);
+	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
 	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
 		if (sdata->allmulti) {
 			sdata->allmulti = 0;


-- 
Jiri Benc
SUSE Labs
