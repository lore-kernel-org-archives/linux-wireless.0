Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:58264 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbbJXTdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 15:33:50 -0400
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix crash on mesh local link ID generation with VIFs
Date: Sat, 24 Oct 2015 21:25:51 +0200
Message-Id: <410200d1bd404c5c3acf66b8cabaae2860df2241.1445714370.git.mschiffer@universe-factory.net> (sfid-20151024_213417_424404_3C15B02D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

llid_in_use needs to be limited to stations of the same VIF, otherwise it
will cause a NULL deref as the sta_info of non-mesh-VIFs don't have
sta->mesh set.

Steps to reproduce:

   modprobe mac80211_hwsim channels=2
   iw phy phy0 interface add ibss0 type ibss
   iw phy phy0 interface add mesh0 type mp
   iw phy phy1 interface add ibss1 type ibss
   iw phy phy1 interface add mesh1 type mp
   ip link set ibss0 up
   ip link set mesh0 up
   ip link set ibss1 up
   ip link set mesh1 up
   iw dev ibss0 ibss join foo 2412
   iw dev ibss1 ibss join foo 2412
   # Ensure that ibss0 and ibss1 are actually associated; I often need to
   # leave and join the cell on ibss1 a second time.
   iw dev mesh0 mesh join bar
   iw dev mesh1 mesh join bar # crash

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
Should probably be queued for stable, at least for all kernels containing
"mac80211: move mesh related station fields to own struct" (the bug was
there before, but it didn't crash without that commit).


 net/mac80211/mesh_plink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5838464..d1224d3 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -677,6 +677,9 @@ static bool llid_in_use(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+
 		if (!memcmp(&sta->mesh->llid, &llid, sizeof(llid))) {
 			in_use = true;
 			break;
-- 
2.6.2

