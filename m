Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbXC1JLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:44 -0400
Subject: [PATCH] mac80211: use ARRAY_SIZE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 17:59:26 +0200
Message-Id: <1175011166.9282.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts all applicable instances of
sizeof(array)/sizeof(member) that I found to ARRAY_SIZE.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_ioctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-27 16:33:30.893155480 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-27 16:33:44.363155480 +0200
@@ -3273,11 +3273,9 @@ static const iw_handler ieee80211_privat
 
 const struct iw_handler_def ieee80211_iw_handler_def =
 {
-	.num_standard	= sizeof(ieee80211_handler) / sizeof(iw_handler),
-	.num_private	= sizeof(ieee80211_private_handler) /
-			  sizeof(iw_handler),
-	.num_private_args = sizeof(ieee80211_ioctl_priv) /
-			    sizeof(struct iw_priv_args),
+	.num_standard	= ARRAY_SIZE(ieee80211_handler),
+	.num_private	= ARRAY_SIZE(ieee80211_private_handler),
+	.num_private_args = ARRAY_SIZE(ieee80211_ioctl_priv),
 	.standard	= (iw_handler *) ieee80211_handler,
 	.private	= (iw_handler *) ieee80211_private_handler,
 	.private_args	= (struct iw_priv_args *) ieee80211_ioctl_priv,


