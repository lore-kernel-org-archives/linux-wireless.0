Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:11936
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753011AbeASCJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 21:09:26 -0500
From: peter.oh@bowerswilkins.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Peter Oh <peter.oh@bowerswilkins.com>, johannes.berg@intel.com
Subject: [PATCH v2] mac80211: mesh: fix wrong mesh TTL offset calculation
Date: Thu, 18 Jan 2018 18:09:03 -0800
Message-Id: <5ab069190f29078c2d621acf10ec9ad8aa0b684c.1516327710.git.peter.oh@bowerswilkins.com> (sfid-20180119_030932_332489_2A13DE94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <peter.oh@bowerswilkins.com>

mesh TTL offset in Mesh Channel Switch Parameters element depends on
not only Secondary Channel Offset element, but also affected by
HT Control field and Wide Bandwidth Channel Switch element.
Hence take those values place in.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 net/mac80211/mesh.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 73ac607..8c2aaf0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1255,13 +1255,16 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 }
 
 static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_mgmt *mgmt, size_t len)
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_mgmt *mgmt_fwd;
 	struct sk_buff *skb;
 	struct ieee80211_local *local = sdata->local;
 	u8 *pos = mgmt->u.action.u.chan_switch.variable;
 	size_t offset_ttl;
+	/* mgmt hdr 24 + csa action 15 without sec offset and wide bw */
+	unsigned int basic_hdrlen = 39;
 
 	skb = dev_alloc_skb(local->tx_headroom + len);
 	if (!skb)
@@ -1269,11 +1272,17 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	skb_reserve(skb, local->tx_headroom);
 	mgmt_fwd = skb_put(skb, len);
 
+	if (ieee80211_has_order(mgmt->frame_control))
+		basic_hdrlen += 4;
+
+	if (elems->wide_bw_chansw_ie)
+		basic_hdrlen += 5;
+
 	/* offset_ttl is based on whether the secondary channel
 	 * offset is available or not. Subtract 1 from the mesh TTL
 	 * and disable the initiator flag before forwarding.
 	 */
-	offset_ttl = (len < 42) ? 7 : 10;
+	offset_ttl = (len > basic_hdrlen) ? 10 : 7;
 	*(pos + offset_ttl) -= 1;
 	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
 
@@ -1323,7 +1332,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	/* forward or re-broadcast the CSA frame */
 	if (fwd_csa) {
-		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
+		if (mesh_fwd_csa_frame(sdata, mgmt, len, &elems) < 0)
 			mcsa_dbg(sdata, "Failed to forward the CSA frame");
 	}
 }
-- 
2.7.4
