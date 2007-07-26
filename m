Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbXGZPlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 11:41:04 -0400
Subject: [PATCH] mac80211: fix add_interface monitor mode behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 17:41:02 +0200
Message-Id: <1185464462.4006.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it behave the same whether we have monitor during operation
or not.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
will probably crash a few drivers where I pointed out the bugs a few
weeks ago...

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-07-26 17:39:08.567965155 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-07-26 17:39:34.467965155 +0200
@@ -2708,7 +2708,10 @@ static int ieee80211_open(struct net_dev
 
 	conf.if_id = dev->ifindex;
 	conf.type = sdata->type;
-	conf.mac_addr = dev->dev_addr;
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR)
+		conf.mac_addr = NULL;
+	else
+		conf.mac_addr = dev->dev_addr;
 	res = local->ops->add_interface(local_to_hw(local), &conf);
 	if (res) {
 		if (sdata->type == IEEE80211_IF_TYPE_MNTR)


