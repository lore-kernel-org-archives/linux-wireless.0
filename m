Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from david.siemens.de ([192.35.17.14]:19739 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0BWLE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 06:04:57 -0500
From: "Porsch, Marco" <marco.porsch@siemens.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Date: Tue, 23 Feb 2010 11:35:56 +0100
Subject: [PATCH] mac80211: fix PREQ processing and one small bug
Message-ID: <7F2FE3504A6CB54497542A539E401A7B6AB18057@DEMCHP99E15MSX.ww902.siemens.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1st) a PREQ should only be processed, if it has the same SN and better metric (instead of better or equal).
2nd) next_hop[ETH_ALEN] now actually used to buffer mpath->next_hop->sta.addr for use out of lock.

Signed-off-by: Marco Porsch <marco.porsch@siemens.com>
Acked-by: Javier Cardona <javier@cozybit.com>

---
 net/mac80211/mesh_hwmp.c |   4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -upr a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/mesh_hwmp.c        2010-02-18 14:44:47.000000000 +0100
+++ b/net/mac80211/mesh_hwmp.c 2010-02-18 14:45:32.000000000 +0100
@@ -391,7 +391,7 @@ static u32 hwmp_route_info_get(struct ie
                                 if (SN_GT(mpath->sn, orig_sn) ||
                                     (mpath->sn == orig_sn &&
                                      action == MPATH_PREQ &&
-                                    new_metric > mpath->metric)) {
+                                    new_metric >= mpath->metric)) {
                                         process = false;
                                         fresh_info = false;
                                 }
@@ -611,7 +611,7 @@ static void hwmp_prep_frame_process(stru
 
         mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
                 cpu_to_le32(orig_sn), 0, target_addr,
-               cpu_to_le32(target_sn), mpath->next_hop->sta.addr, hopcount,
+               cpu_to_le32(target_sn), next_hop, hopcount,
                 ttl, cpu_to_le32(lifetime), cpu_to_le32(metric),
                 0, sdata);
         rcu_read_unlock();