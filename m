Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:19832 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYJaVuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 17:50:14 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1477216rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 14:50:14 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: disable BSSID filtering for mesh interfaces
Date: Fri, 31 Oct 2008 14:50:12 -0700 (PDT)
Message-ID: <490b7d94.18038e0a.6666.ffff8d72@mx.google.com> (sfid-20081031_225028_306074_A65C54AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh interfaces are currently opened with the FIF_ALLMULTI rx filter flag set,
however there is no BSSID in mesh so BSSID filtering should be disabled by
setting the FIF_OTHER_BSS flag as well.  Also explicitly call 
ieee80211_configure_filter for mesh.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozbit.com>
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cde1452..6c3901a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -229,8 +229,14 @@ static int ieee80211_open(struct net_device *dev)
 		if (res)
 			goto err_stop;
 
-		if (ieee80211_vif_is_mesh(&sdata->vif))
+		if (ieee80211_vif_is_mesh(&sdata->vif)) {
+			local->fif_other_bss++;
+			netif_addr_lock_bh(local->mdev);
+			ieee80211_configure_filter(local);
+			netif_addr_unlock_bh(local->mdev);
+
 			ieee80211_start_mesh(sdata);
+		}
 		changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
@@ -456,8 +462,15 @@ static int ieee80211_stop(struct net_device *dev)
 		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			/* allmulti is always set on mesh ifaces */
+			/* other_bss and allmulti are always set on mesh
+			 * ifaces */
+			local->fif_other_bss--;
 			atomic_dec(&local->iff_allmultis);
+
+			netif_addr_lock_bh(local->mdev);
+			ieee80211_configure_filter(local);
+			netif_addr_unlock_bh(local->mdev);
+
 			ieee80211_stop_mesh(sdata);
 		}
 		/* fall through */


