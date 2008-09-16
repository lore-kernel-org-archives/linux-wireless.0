Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYIPSc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:32:57 -0400
Subject: [PATCH] mac80211: refuse invalid interface configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 20:32:04 +0200
Message-Id: <1221589924.8916.52.camel@johannes.berg> (sfid-20080916_203323_424249_F57B27E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refuse setting mesh_id on non-mesh or monitor flags on non-monitor
interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-09-16 20:24:53.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-16 20:28:14.000000000 +0200
@@ -105,14 +105,21 @@ static int ieee80211_change_iface(struct
 	if (netif_running(sdata->dev))
 		return -EBUSY;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
-		ieee80211_sdata_set_mesh_id(sdata,
-					    params->mesh_id_len,
-					    params->mesh_id);
+	if (params->mesh_id_len) {
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_sdata_set_mesh_id(sdata,
+						    params->mesh_id_len,
+						    params->mesh_id);
+		else
+			return -EINVAL;
+	}
 
-	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
+	if (!flags)
 		return 0;
 
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		return -EINVAL;
+
 	sdata->u.mntr_flags = *flags;
 	return 0;
 }


