Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1KYBPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 20:15:38 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3749758iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 17:15:38 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 3/7] mac80211: fix switched HWMP frame addresses
Date: Thu, 24 Nov 2011 17:15:22 -0800
Message-Id: <1322183726-12436-4-git-send-email-thomas@cozybit.com> (sfid-20111125_021541_909312_18A0E13E)
In-Reply-To: <1322183726-12436-1-git-send-email-thomas@cozybit.com>
References: <1322183726-12436-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HWMP originator and target addresses were switched on the air but also
on reception, which is why path selection still worked.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 1b13135..208ba35 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -393,15 +393,13 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		orig_metric = PREQ_IE_METRIC(hwmp_ie);
 		break;
 	case MPATH_PREP:
-		/* Originator here refers to the MP that was the destination in
-		 * the Path Request. The draft refers to that MP as the
-		 * destination address, even though usually it is the origin of
-		 * the PREP frame. We divert from the nomenclature in the draft
+		/* Originator here refers to the MP that was the target in the
+		 * Path Request. We divert from the nomenclature in the draft
 		 * so that we can easily use a single function to gather path
 		 * information from both PREQ and PREP frames.
 		 */
-		orig_addr = PREP_IE_ORIG_ADDR(hwmp_ie);
-		orig_sn = PREP_IE_ORIG_SN(hwmp_ie);
+		orig_addr = PREP_IE_TARGET_ADDR(hwmp_ie);
+		orig_sn = PREP_IE_TARGET_SN(hwmp_ie);
 		orig_lifetime = PREP_IE_LIFETIME(hwmp_ie);
 		orig_metric = PREP_IE_METRIC(hwmp_ie);
 		break;
@@ -562,9 +560,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
 			mhwmp_dbg("replying to the PREQ");
-			mesh_path_sel_frame_tx(MPATH_PREP, 0, target_addr,
-				cpu_to_le32(target_sn), 0, orig_addr,
-				cpu_to_le32(orig_sn), mgmt->sa, 0, ttl,
+			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
+				cpu_to_le32(orig_sn), 0, target_addr,
+				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
 		} else
@@ -618,14 +616,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	mhwmp_dbg("received PREP from %pM", PREP_IE_ORIG_ADDR(prep_elem));
 
-	/* Note that we divert from the draft nomenclature and denominate
-	 * destination to what the draft refers to as origininator. So in this
-	 * function destnation refers to the final destination of the PREP,
-	 * which corresponds with the originator of the PREQ which this PREP
-	 * replies
-	 */
-	target_addr = PREP_IE_TARGET_ADDR(prep_elem);
-	if (memcmp(target_addr, sdata->vif.addr, ETH_ALEN) == 0)
+	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
+	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
 		/* destination, no forwarding required */
 		return;
 
@@ -636,7 +628,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(target_addr, sdata);
+	mpath = mesh_path_lookup(orig_addr, sdata);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -651,7 +643,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	flags = PREP_IE_FLAGS(prep_elem);
 	lifetime = PREP_IE_LIFETIME(prep_elem);
 	hopcount = PREP_IE_HOPCOUNT(prep_elem) + 1;
-	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
+	target_addr = PREP_IE_TARGET_ADDR(prep_elem);
 	target_sn = PREP_IE_TARGET_SN(prep_elem);
 	orig_sn = PREP_IE_ORIG_SN(prep_elem);
 
-- 
1.7.5.4

