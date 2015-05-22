Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35519 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbbEVBFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 21:05:15 -0400
Received: by lbbuc2 with SMTP id uc2so2512625lbb.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 18:05:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 May 2015 18:05:13 -0700
Message-ID: <CAAnMG+OgtSzFXqLOoZ-JbOr7xnexC3P0+M0fFLWTBtWru=4SKg@mail.gmail.com> (sfid-20150522_030523_449617_91DF4471)
Subject: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely other
 drivers) when fixed mesh paths are used
From: Alexis Green <agreen@cococorp.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a NULL dereference in ath9k (and likely other drivers) when
fixed mesh paths are used. The problem is that when a station comes up
sta_info_alloc allocates ath_node implicitly via hw->sta_data_size. When it
does that the ath_node is zeroed out. The ath_node isn’t actually initialized
until the station becomes associated and ath9k_sta_state is called.

Normally this is OK because paths won't be formed to a station that isn't
authorized. But when the path is fixed the MAC thinks it knows how to
 route the packet, sends it down to ath9k, and winds up inducing reboots
in places like ath_tx_start when tid->ac is dereferenced.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 214e63b..14e146e 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1081,6 +1081,11 @@ int mesh_nexthop_resolve(struct
ieee80211_sub_if_data *sdata,
        if (!err)
                goto endlookup;

+       if (err == -EPERM) {
+               mesh_path_discard_frame(sdata, skb);
+               goto endlookup;
+       }
+
        /* no nexthop found, start resolving */
        mpath = mesh_path_lookup(sdata, target_addr);
        if (!mpath) {
@@ -1145,6 +1150,12 @@ int mesh_nexthop_lookup(struct
ieee80211_sub_if_data *sdata,

        next_hop = rcu_dereference(mpath->next_hop);
        if (next_hop) {
+               if (mpath->flags & MESH_PATH_FIXED) {
+                       if (next_hop->sta_state != IEEE80211_STA_AUTHORIZED) {
+                               err = -EPERM;
+                               goto endlookup;
+                       }
+               }
                memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
                memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
                ieee80211_mps_set_frame_flags(sdata, next_hop, hdr);
