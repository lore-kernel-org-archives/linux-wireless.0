Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYDHOby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 10:31:54 -0400
Subject: [PATCH] mac80211: fix sta-info pinning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 13:08:20 +0200
Message-Id: <1207652901.14253.4.camel@johannes.berg> (sfid-20080408_153200_525828_8EBB7940)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a STA is supposed to be unlinked but is pinned, it still needs
to be unlinked from all structures. Only at the end of the unlink
process should we check for pin status and invalidate the callers
reference if it is pinned. Move the pin status check down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.c |   64 ++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-04-08 11:20:42.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-08 11:22:02.000000000 +0200
@@ -469,8 +469,39 @@ void __sta_info_unlink(struct sta_info *
 		return;
 	}
 
+	list_del(&(*sta)->list);
+
+	if ((*sta)->flags & WLAN_STA_PS) {
+		(*sta)->flags &= ~WLAN_STA_PS;
+		if (sdata->bss)
+			atomic_dec(&sdata->bss->num_sta_ps);
+		__sta_info_clear_tim_bit(sdata->bss, *sta);
+	}
+
+	local->num_sta--;
+
+	if (local->ops->sta_notify) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+			sdata = sdata->u.vlan.ap;
+
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+				       STA_NOTIFY_REMOVE, (*sta)->addr);
+	}
+
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		mesh_accept_plinks_update(sdata);
+#ifdef CONFIG_MAC80211_MESH
+		del_timer(&(*sta)->plink_timer);
+#endif
+	}
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Removed STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, (*sta)->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
 	/*
-	 * Also pull caller's reference if the STA is pinned by the
+	 * Finally, pull caller's reference if the STA is pinned by the
 	 * task that is adding the debugfs entries. In that case, we
 	 * leave the STA "to be freed".
 	 *
@@ -502,37 +533,6 @@ void __sta_info_unlink(struct sta_info *
 		*sta = NULL;
 		return;
 	}
-
-	list_del(&(*sta)->list);
-
-	if ((*sta)->flags & WLAN_STA_PS) {
-		(*sta)->flags &= ~WLAN_STA_PS;
-		if (sdata->bss)
-			atomic_dec(&sdata->bss->num_sta_ps);
-		__sta_info_clear_tim_bit(sdata->bss, *sta);
-	}
-
-	local->num_sta--;
-
-	if (local->ops->sta_notify) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
-			sdata = sdata->u.vlan.ap;
-
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_REMOVE, (*sta)->addr);
-	}
-
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		mesh_accept_plinks_update(sdata);
-#ifdef CONFIG_MAC80211_MESH
-		del_timer(&(*sta)->plink_timer);
-#endif
-	}
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Removed STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mbuf, (*sta)->addr));
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 }
 
 void sta_info_unlink(struct sta_info **sta)


