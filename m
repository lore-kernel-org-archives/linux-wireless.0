Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-hk1hn0121.outbound.protection.outlook.com ([134.170.140.121]:5528
	"EHLO APAC01-HK1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbaKUJMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:12:35 -0500
From: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"Bob Copeland (me@bobcopeland.com)" <me@bobcopeland.com>
Subject: [PATCH v3] mac80211: keep sending peer candidate events while in
 listen state
Date: Fri, 21 Nov 2014 09:11:25 +0000
Message-ID: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C8BC@JPYOKXMS113.jp.sony.com> (sfid-20141121_101258_074290_AAFA54B9)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of sending peer candidate events just once, send them as long as the peer remains in the LISTEN state in the peering state machine, when userspace is implementing the peering manager.  Userspace may silence the events from a peer by progressing the state machine or by setting the link state to BLOCKED.

Fixes the problem that a mesh peering process won't be fired again after the previous first peering trial fails due to like air propagation error if the peering is managed by user space such as wpa_supplicant.

This patch works with another patch for wpa_supplicant described here which fires a peering process again triggered by the notice from kernel.
http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html

Signed-off-by: Kenzoh Nishikawa <Kenzoh.Nishikawa at jp.sony.com>
---
net/mac80211/mesh_plink.c |    7 +++++++
1 file changed, 7 insertions(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c index 32c7bd0..dfc429b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -524,6 +524,13 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    sdata->u.mesh.mshcfg.auto_open_plinks &&
 	    rssi_threshold_check(sta, sdata))
 		changed = mesh_plink_open(sta);
+	else if (sta->plink_state == NL80211_PLINK_LISTEN &&
+		(sdata->u.mesh.user_mpm ||
+		sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED))
+		cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
+							   elems->ie_start,
+							   elems->total_len,
+							   GFP_ATOMIC);
 
 	ieee80211_mps_frame_release(sta, elems);
 out:

