Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51662 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0DZW0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 18:26:37 -0400
Message-ID: <4BD6131A.2020703@openwrt.org>
Date: Tue, 27 Apr 2010 00:26:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] mac80211: fix handling of 4-address-mode in ieee80211_change_iface
References: <4BD5D34F.8080205@openwrt.org> <1272318607.22987.2.camel@mj>
In-Reply-To: <1272318607.22987.2.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A misplaced interface type check bails out too early if the interface
is not in monitor mode. This patch moves it to the right place, so that
it only covers changes to the monitor flags.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -97,9 +97,6 @@ static int ieee80211_change_iface(struct
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
-		return 0;
-
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0)
 		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
@@ -107,7 +104,9 @@ static int ieee80211_change_iface(struct
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
-	sdata->u.mntr_flags = *flags;
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
+		sdata->u.mntr_flags = *flags;
+
 	return 0;
 }
 
