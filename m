Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44237 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3BCBDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 20:03:33 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so24180pab.17
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 17:03:32 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] mac80211: generate mesh probe responses
Date: Sat,  2 Feb 2013 17:02:21 -0800
Message-Id: <1359853341-29237-4-git-send-email-thomas@cozybit.com> (sfid-20130203_020339_132706_4010D7F4)
In-Reply-To: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh interfaces will now respond to any broadcast (or
matching directed mesh) probe requests with a probe
response.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c   |    5 ++--
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e08abc0..697ebc1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -802,6 +802,66 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->u.mesh.timers_running = 0;
 }
 
+static void
+ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
+			    struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct sk_buff *presp;
+	struct beacon_data *bcn;
+	struct ieee80211_mgmt *hdr;
+	struct ieee802_11_elems elems;
+	size_t baselen;
+	u8 *pos, *end;
+
+	end = ((u8 *) mgmt) + len;
+	pos = mgmt->u.probe_req.variable;
+	baselen = (u8 *) pos - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(pos, len - baselen, &elems);
+
+	/* 802.11-2012 10.1.4.3.2 */
+	if ((!ether_addr_equal(mgmt->da, sdata->vif.addr) &&
+	     !is_broadcast_ether_addr(mgmt->da)) ||
+	    elems.ssid_len != 0)
+		return;
+
+	if (elems.mesh_id_len != 0 &&
+	    (elems.mesh_id_len != ifmsh->mesh_id_len ||
+	     memcmp(elems.mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len))) {
+		mpl_dbg(sdata, "ignoring probe request for different MBSS\n");
+		return;
+	}
+
+	rcu_read_lock();
+	bcn = rcu_dereference(ifmsh->beacon);
+
+	if (!bcn)
+		goto out;
+
+	presp = dev_alloc_skb(local->tx_headroom +
+			      bcn->head_len + bcn->tail_len);
+	if (WARN_ON(!presp))
+		goto out;
+
+	skb_reserve(presp, local->tx_headroom);
+	memcpy(skb_put(presp, bcn->head_len), bcn->head, bcn->head_len);
+	memcpy(skb_put(presp, bcn->tail_len), bcn->tail, bcn->tail_len);
+	hdr = (struct ieee80211_mgmt *) presp->data;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					 IEEE80211_STYPE_PROBE_RESP);
+	memcpy(hdr->da, mgmt->sa, ETH_ALEN);
+	mpl_dbg(sdata, "sending probe resp. to %pM\n", hdr->da);
+	IEEE80211_SKB_CB(presp)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, presp);
+out:
+	rcu_read_unlock();
+	return;
+}
+
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 					u16 stype,
 					struct ieee80211_mgmt *mgmt,
@@ -891,6 +951,9 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		ieee80211_mesh_rx_bcn_presp(sdata, stype, mgmt, skb->len,
 					    rx_status);
 		break;
+	case IEEE80211_STYPE_PROBE_REQ:
+		ieee80211_mesh_rx_probe_req(sdata, mgmt, skb->len);
+		break;
 	case IEEE80211_STYPE_ACTION:
 		ieee80211_mesh_rx_mgmt_action(sdata, mgmt, skb->len, rx_status);
 		break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a190895..226ae06 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2677,8 +2677,9 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 			return RX_DROP_MONITOR;
 		break;
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
-		/* process only for ibss */
-		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+		/* process only for ibss and mesh */
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 			return RX_DROP_MONITOR;
 		break;
 	default:
-- 
1.7.10.4

