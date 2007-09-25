Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXIYVaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:30:15 -0400
Subject: [PATCH] mac80211: fix interface initialisation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709252206.57855.mb@bu3sch.de>
References: <200709252206.57855.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 23:31:32 +0200
Message-Id: <1190755892.18521.330.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is registered it is still uninitialised so
ieee80211_if_reinit() can't be called on it (it will oops.)
Hence, we need to move the uninit method assignment. Also,
this patch fixes the bug that the master device is never
initialised at all.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |    3 +--
 net/mac80211/ieee80211_iface.c |   20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-25 22:26:31.341579155 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-25 23:28:21.581572375 +0200
@@ -266,7 +266,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->stop = ieee80211_mgmt_stop;
 	dev->type = ARPHRD_IEEE80211_PRISM;
 	dev->hard_header_parse = header_parse_80211;
-	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
 
@@ -543,7 +542,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
-	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
 
@@ -1234,6 +1232,7 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_dev;
 
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
+	ieee80211_if_set_type(local->mdev, IEEE80211_IF_TYPE_AP);
 
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
 	if (result < 0) {
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-25 22:26:40.111572537 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-25 23:28:21.651570910 +0200
@@ -127,6 +127,12 @@ int ieee80211_if_add_mgmt(struct ieee802
 	if (ret)
 		goto fail;
 
+	/*
+	 * Called even when register_netdevice fails, it would
+	 * oops if assigned before initialising the rest.
+	 */
+	ndev->uninit = ieee80211_if_reinit;
+
 	ieee80211_debugfs_add_netdev(nsdata);
 
 	if (local->open_count > 0)
@@ -155,7 +161,19 @@ void ieee80211_if_set_type(struct net_de
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int oldtype = sdata->type;
 
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	/*
+	 * We need to call this function on the master interface
+	 * which already has a hard_start_xmit routine assigned
+	 * which must not be changed.
+	 */
+	if (!dev->hard_start_xmit)
+		dev->hard_start_xmit = ieee80211_subif_start_xmit;
+
+	/*
+	 * Called even when register_netdevice fails, it would
+	 * oops if assigned before initialising the rest.
+	 */
+	dev->uninit = ieee80211_if_reinit;
 
 	sdata->type = type;
 	switch (type) {


