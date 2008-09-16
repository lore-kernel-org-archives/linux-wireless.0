Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYIPSXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:23:44 -0400
Subject: [PATCH] mac80211: allow interface settings changes only when down
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 20:22:21 +0200
Message-Id: <1221589341.8916.48.camel@johannes.berg> (sfid-20080916_202348_022661_03CAA616)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We currently allow monitor flags changes and mesh ID changes when
the interface is up, which can lead to trouble. Change it to only
allow when down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    3 +++
 1 file changed, 3 insertions(+)

--- everything.orig/net/mac80211/cfg.c	2008-09-16 20:19:48.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-16 20:20:37.000000000 +0200
@@ -102,6 +102,9 @@ static int ieee80211_change_iface(struct
 	if (ret)
 		return ret;
 
+	if (netif_running(sdata->dev))
+		return -EBUSY;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
 		ieee80211_sdata_set_mesh_id(sdata,
 					    params->mesh_id_len,


