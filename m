Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992432AbXDLJ7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 05:59:25 -0400
Subject: [PATCH] cfg80211/nl80211: remove reassociate command
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 12:00:54 +0200
Message-Id: <1176372055.7052.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't seem to be useful. If we need it later we can add it back then.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |    1 -
 include/net/cfg80211.h  |    3 ---
 net/wireless/nl80211.c  |    8 --------
 3 files changed, 12 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-04-12 11:57:40.195366513 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-04-12 11:58:33.725366513 +0200
@@ -75,7 +75,6 @@ enum nl80211_commands {
 	NL80211_CMD_GET_ASSOCIATION,
 	NL80211_CMD_ASSOCIATION_CHANGED,
 	NL80211_CMD_ASSOCIATE,
-	NL80211_CMD_REASSOCIATE,
 	NL80211_CMD_DISASSOCIATE,
 	NL80211_CMD_DEAUTH,
 	NL80211_CMD_GET_AUTH_LIST,
--- wireless-dev.orig/net/wireless/nl80211.c	2007-04-12 11:58:33.195366513 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-04-12 11:58:33.725366513 +0200
@@ -146,7 +146,6 @@ static int nl80211_get_cmdlist(struct sk
 	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
 	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
 	CHECK_CMD(associate, ASSOCIATE);
-	CHECK_CMD(reassociate, REASSOCIATE);
 	CHECK_CMD(disassociate, DISASSOCIATE);
 	CHECK_CMD(deauth, DEAUTH);
 	CHECK_CMD(initiate_scan, INITIATE_SCAN);
@@ -839,13 +838,6 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
-/*
-	{
-		.cmd = NL80211_CMD_REASSOCIATE,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-*/
 	{
 		.cmd = NL80211_CMD_DISASSOCIATE,
 		.doit = nl80211_disassoc_deauth,
--- wireless-dev.orig/include/net/cfg80211.h	2007-04-12 11:57:40.265366513 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-04-12 11:58:33.725366513 +0200
@@ -94,8 +94,6 @@ struct wiphy;
  *
  * @associate: associate with given parameters
  *
- * @reassociate: reassociate with settings
- *
  * @disassociate: disassociate from current AP
  *
  * @deauth: deauth from current AP
@@ -121,7 +119,6 @@ struct cfg80211_ops {
 
 	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
 			     struct association_params *params);
-	int	(*reassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
 


