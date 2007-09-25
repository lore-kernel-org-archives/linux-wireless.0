Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXIYVIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:08:16 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, jbenc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1187692485.4288.11.camel@johannes.berg>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <200708162243.05809.linux@baker-net.org.uk>
	 <1187345617.23489.143.camel@johannes.berg>
	 <200708202121.35543.linux@baker-net.org.uk>
	 <1187692485.4288.11.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 23:09:07 +0200
Message-Id: <1190754547.18521.326.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-21 at 12:34 +0200, Johannes Berg wrote:

> At that point, sdata->bss should point to the master device, which
> apparently hasn't been initialised yet. The device initialisation code
> is pretty black magic to me, Jiri/Michael?

No reply. Can you try this patch?

---
 net/mac80211/ieee80211.c       |    3 +--
 net/mac80211/ieee80211_iface.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

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


