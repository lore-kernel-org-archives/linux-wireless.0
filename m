Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXIYUot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 16:44:49 -0400
Subject: Re: mac80211: crash while adding interface.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1190752616.18521.322.camel@johannes.berg>
References: <200709252206.57855.mb@bu3sch.de>
	 <1190752616.18521.322.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 22:45:01 +0200
Message-Id: <1190753101.18521.324.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, try this, it fixes another bug too.

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-25 22:26:31.341579155 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-25 22:43:38.681568738 +0200
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
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-25 22:41:52.251569443 +0200
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
@@ -157,6 +163,12 @@ void ieee80211_if_set_type(struct net_de
 
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 
+	/*
+	 * Called even when register_netdevice fails, it would
+	 * oops if assigned before initialising the rest.
+	 */
+	dev->uninit = ieee80211_if_reinit;
+
 	sdata->type = type;
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:


