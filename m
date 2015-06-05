Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36054 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbbFESbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 14:31:38 -0400
Received: by lbbqq2 with SMTP id qq2so50966152lbb.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 11:31:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Jun 2015 11:31:36 -0700
Message-ID: <CAAnMG+N0u18J+c78YtufzewYQ43XXPo7uHELfq9mkSRcK-555A@mail.gmail.com> (sfid-20150605_203144_684964_3FC2C14D)
Subject: [PATCH] mac80211: Fix a case of incorrect metric used when forwarding
 a PREQ
From: Alexis Green <agreen@cococorp.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in hwmp_preq_frame_process where the wrong metric
can be used when forwarding a PREQ. This happens because the code uses
the same metric variable to record the value of the metric to the source
of the PREQ and the value of the metric to the target of the PREQ.

This comes into play when both reply and forward are set which happens
when IEEE80211_PREQ_PROACTIVE_PREP_FLAG is set and when MP_F_DO | MP_F_RF
is set. The original code had a special case to handle the first case
but not the second.

The patch uses distinct variables for the two metrics which makes the
code flow much clearer and removes the need to restore the original
value of metric when forwarding.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 214e63b..bb93170 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -510,14 +510,14 @@ static u32 hwmp_route_info_get(struct
ieee80211_sub_if_data *sdata,

 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
                    struct ieee80211_mgmt *mgmt,
-                   const u8 *preq_elem, u32 metric)
+                   const u8 *preq_elem, u32 orig_metric)
 {
    struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
    struct mesh_path *mpath = NULL;
    const u8 *target_addr, *orig_addr;
    const u8 *da;
    u8 target_flags, ttl, flags;
-   u32 orig_sn, target_sn, lifetime, orig_metric;
+   u32 orig_sn, target_sn, lifetime, target_metric;
    bool reply = false;
    bool forward = true;
    bool root_is_gate;
@@ -528,7 +528,6 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
    target_sn = PREQ_IE_TARGET_SN(preq_elem);
    orig_sn = PREQ_IE_ORIG_SN(preq_elem);
    target_flags = PREQ_IE_TARGET_F(preq_elem);
-   orig_metric = metric;
    /* Proactive PREQ gate announcements */
    flags = PREQ_IE_FLAGS(preq_elem);
    root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
@@ -539,7 +538,7 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
        mhwmp_dbg(sdata, "PREQ is for us\n");
        forward = false;
        reply = true;
-       metric = 0;
+       target_metric = 0;
        if (time_after(jiffies, ifmsh->last_sn_update +
                    net_traversal_jiffies(sdata)) ||
            time_before(jiffies, ifmsh->last_sn_update)) {
@@ -556,7 +555,7 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
                reply = true;
                target_addr = sdata->vif.addr;
                target_sn = ++ifmsh->sn;
-               metric = 0;
+               target_metric = 0;
                ifmsh->last_sn_update = jiffies;
            }
            if (root_is_gate)
@@ -574,7 +573,7 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
            } else if ((!(target_flags & MP_F_DO)) &&
                    (mpath->flags & MESH_PATH_ACTIVE)) {
                reply = true;
-               metric = mpath->metric;
+               target_metric = mpath->metric;
                target_sn = mpath->sn;
                if (target_flags & MP_F_RF)
                    target_flags |= MP_F_DO;
@@ -593,7 +592,8 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
            mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
                           orig_sn, 0, target_addr,
                           target_sn, mgmt->sa, 0, ttl,
-                          lifetime, metric, 0, sdata);
+                          lifetime, target_metric,
+                          0, sdata);
        } else {
            ifmsh->mshstats.dropped_frames_ttl++;
        }
@@ -619,13 +619,12 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
        if (flags & IEEE80211_PREQ_PROACTIVE_PREP_FLAG) {
            target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
            target_sn = PREQ_IE_TARGET_SN(preq_elem);
-           metric = orig_metric;
        }

        mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
                       orig_sn, target_flags, target_addr,
                       target_sn, da, hopcount, ttl, lifetime,
-                      metric, preq_id, sdata);
+                      orig_metric, preq_id, sdata);
        if (!is_multicast_ether_addr(da))
            ifmsh->mshstats.fwded_unicast++;
        else
