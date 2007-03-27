Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbXC1JMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:15 -0400
Subject: [PATCH] mac80211: add sta item when changing WDS address
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 18:01:17 +0200
Message-Id: <1175011277.9282.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a sta item for the new address when you change a WDS
link's address. If the sta item cannot be created return an error.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-27 16:33:29.523155480 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-27 16:33:47.163155480 +0200
@@ -4418,6 +4418,15 @@ int ieee80211_if_update_wds(struct net_d
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 
+	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
+		return 0;
+
+	/* Create STA entry for the new peer */
+	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
+	sta_info_put(sta);
+
 	/* Remove STA entry for the old peer */
 	sta = sta_info_get(local, sdata->u.wds.remote_addr);
 	if (sta) {


