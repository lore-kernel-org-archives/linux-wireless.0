Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35556 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbcF1LLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 07:11:05 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-kernel@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S . Miller" <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC: Maital Hahn <maitalm@ti.com>
Subject: [PATCH 1/4] mac80211: mesh: flush stations before beacons are stopped
Date: Tue, 28 Jun 2016 14:13:04 +0300
Message-ID: <20160628111307.8784-2-yanivma@ti.com> (sfid-20160628_131242_322678_C8EEF9F3)
In-Reply-To: <20160628111307.8784-1-yanivma@ti.com>
References: <20160628111307.8784-1-yanivma@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maital Hahn <maitalm@ti.com>

Some drivers (e.g. wl18xx) expect that the last stage in the
de-initialization process will be stopping the beacons, similar to ap.
Update ieee80211_stop_mesh() flow accordingly.

Signed-off-by: Maital Hahn <maitalm@ti.com>
Acked-by: Yaniv Machani <yanivma@ti.com>
---
 net/mac80211/mesh.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 21b1fdf..9214bc1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -896,20 +896,22 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	netif_carrier_off(sdata->dev);
 
+	/* flush STAs and mpaths on this iface */
+	sta_info_flush(sdata);
+	mesh_path_flush_by_iface(sdata);
+
 	/* stop the beacon */
 	ifmsh->mesh_id_len = 0;
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+
+	/* remove beacon */
 	bcn = rcu_dereference_protected(ifmsh->beacon,
 					lockdep_is_held(&sdata->wdev.mtx));
 	RCU_INIT_POINTER(ifmsh->beacon, NULL);
 	kfree_rcu(bcn, rcu_head);
 
-	/* flush STAs and mpaths on this iface */
-	sta_info_flush(sdata);
-	mesh_path_flush_by_iface(sdata);
-
 	/* free all potentially still buffered group-addressed frames */
 	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
 	skb_queue_purge(&ifmsh->ps.bc_buf);
-- 
2.9.0

