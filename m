Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0088.outbound.protection.outlook.com ([104.47.0.88]:61248
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751257AbeAZWCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 17:02:55 -0500
From: peter.oh@bowerswilkins.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Peter Oh <peter.oh@bowerswilkins.com>, johannes.berg@intel.com
Subject: [PATCH v4] mac80211: mesh: fix wrong mesh TTL offset calculation
Date: Fri, 26 Jan 2018 14:02:37 -0800
Message-Id: <5622ae154b32eab5fdba46fee9b0b7ca2e8fed23.1517004051.git.peter.oh@bowerswilkins.com> (sfid-20180126_230259_718169_01CEA7EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <peter.oh@bowerswilkins.com>

mesh TTL offset in Mesh Channel Switch Parameters element depends on
not only Secondary Channel Offset element, but also affected by
HT Control field and Wide Bandwidth Channel Switch element.
So use element structure to manipulate mesh channel swich param IE
after removing its constant attribution to correct the miscalculation.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mesh.c        | 17 ++++++-----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2690002..ae9c33c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1467,7 +1467,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_timeout_interval_ie *timeout_int;
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
-	const struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
+	struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
 	const struct ieee80211_bss_max_idle_period_ie *max_idle_period_ie;
 
 	/* length of them, respectively */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 73ac607..6a381cb 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1255,13 +1255,12 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 }
 
 static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_mgmt *mgmt, size_t len)
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_mgmt *mgmt_fwd;
 	struct sk_buff *skb;
 	struct ieee80211_local *local = sdata->local;
-	u8 *pos = mgmt->u.action.u.chan_switch.variable;
-	size_t offset_ttl;
 
 	skb = dev_alloc_skb(local->tx_headroom + len);
 	if (!skb)
@@ -1269,13 +1268,9 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	skb_reserve(skb, local->tx_headroom);
 	mgmt_fwd = skb_put(skb, len);
 
-	/* offset_ttl is based on whether the secondary channel
-	 * offset is available or not. Subtract 1 from the mesh TTL
-	 * and disable the initiator flag before forwarding.
-	 */
-	offset_ttl = (len < 42) ? 7 : 10;
-	*(pos + offset_ttl) -= 1;
-	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+	elems->mesh_chansw_params_ie->mesh_ttl--;
+	elems->mesh_chansw_params_ie->mesh_flags &=
+		~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
 
 	memcpy(mgmt_fwd, mgmt, len);
 	eth_broadcast_addr(mgmt_fwd->da);
@@ -1323,7 +1318,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	/* forward or re-broadcast the CSA frame */
 	if (fwd_csa) {
-		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
+		if (mesh_fwd_csa_frame(sdata, mgmt, len, &elems) < 0)
 			mcsa_dbg(sdata, "Failed to forward the CSA frame");
 	}
 }
-- 
2.7.4
