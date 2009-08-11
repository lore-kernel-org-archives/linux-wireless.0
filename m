Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtitmf2.realtek.com ([60.250.210.236]:4820 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZHKL7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:34 -0400
Message-ID: <4A815A3B.3080404@realsil.com.cn>
Date: Tue, 11 Aug 2009 19:47:07 +0800
From: david woo <xinhua_wu@realsil.com.cn>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "javier@cozybit.com" <javier@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"andrey@cozybit.com" <andrey@cozybit.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Subject: Re: diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
References: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn> <1249987806.5705.0.camel@johannes.local>
In-Reply-To: <1249987806.5705.0.camel@johannes.local>
Content-Type: multipart/mixed;
	boundary="------------000300070302030508080700"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------000300070302030508080700
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit

Johannes Berg Ð´µÀ:
> On Tue, 2009-08-11 at 18:22 +0800, David Woo wrote:
>> static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>  				    struct ieee80211_mgmt *mgmt,
>> -				    u8 *preq_elem, u32 metric)
>> -{
>> +				    u8 *preq_elem, u32 metric) {
> 
> And other than adding this coding style mistake, what does this patch
> do?
> 
> johannes

It's my first time to submit the patch file, I just mean to submit the attched 
patch file.

[PATCH] mac80211: Fix preq frame process and peer link frame baselen.
  
This patch is just to fix rreq reply condition, and peer link confirm frame baselen.

Signed-off-by: David Woo <xinhua_wu@realsil.com.cn>
---
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e1a763e..c065854 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -397,7 +397,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *preq_elem, u32 metric) {
+				    u8 *preq_elem, u32 metric)
+{
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
@@ -430,7 +431,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
 					DSN_LT(mpath->dsn, dst_dsn)) {
 				mpath->dsn = dst_dsn;
-				mpath->flags &= MESH_PATH_DSN_VALID;
+				mpath->flags |= MESH_PATH_DSN_VALID;
 			} else if ((!(dst_flags & MP_F_DO)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
@@ -447,14 +448,15 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = ifmsh->mshcfg.dot11MeshTTL;
-		if (ttl != 0)
+		ttl = PREQ_IE_TTL(preq_elem);
+		if (ttl != 0) {
+			ttl = ifmsh->mshcfg.dot11MeshTTL;
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
 				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
-		else
+		} else
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cb14253..ffcbad7 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -409,7 +409,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
 	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
 		baseaddr += 4;
-		baselen -= 4;
+		baselen += 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
 	if (!elems.peer_link) {

  
David


--------------000300070302030508080700
Content-Type: text/x-patch; name="mesh.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="mesh.patch"

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e1a763e..c065854 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -397,7 +397,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *preq_elem, u32 metric) {
+				    u8 *preq_elem, u32 metric)
+{
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
@@ -430,7 +431,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
 					DSN_LT(mpath->dsn, dst_dsn)) {
 				mpath->dsn = dst_dsn;
-				mpath->flags &= MESH_PATH_DSN_VALID;
+				mpath->flags |= MESH_PATH_DSN_VALID;
 			} else if ((!(dst_flags & MP_F_DO)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
@@ -447,14 +448,15 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = ifmsh->mshcfg.dot11MeshTTL;
-		if (ttl != 0)
+		ttl = PREQ_IE_TTL(preq_elem);
+		if (ttl != 0) {
+			ttl = ifmsh->mshcfg.dot11MeshTTL;
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
 				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
-		else
+		} else
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cb14253..ffcbad7 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -409,7 +409,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
 	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
 		baseaddr += 4;
-		baselen -= 4;
+		baselen += 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
 	if (!elems.peer_link) {

--------------000300070302030508080700--
