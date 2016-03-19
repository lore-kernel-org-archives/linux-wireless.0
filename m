Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:33972 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbcCSCLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:43 -0400
Received: by mail-qg0-f67.google.com with SMTP id j92so6595966qgj.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:43 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/5] mac80211: mesh: fix mesh path kerneldoc
Date: Fri, 18 Mar 2016 22:11:32 -0400
Message-Id: <1458353492-8654-6-git-send-email-me@bobcopeland.com> (sfid-20160319_031157_406097_34D9B0DA)
In-Reply-To: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
References: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several of the mesh path fields are undocumented and some
of the documentation is no longer correct or relevant after
the switch to rhashtable.  Clean up the kernel doc
accordingly and reorder some fields to match the structure
layout.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4a59c034cc6d..f298987228c9 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -21,8 +21,6 @@
 /**
  * enum mesh_path_flags - mac80211 mesh path flags
  *
- *
- *
  * @MESH_PATH_ACTIVE: the mesh path can be used for forwarding
  * @MESH_PATH_RESOLVING: the discovery process is running for this mesh path
  * @MESH_PATH_SN_VALID: the mesh path contains a valid destination sequence
@@ -70,12 +68,16 @@ enum mesh_deferred_task_flags {
  * struct mesh_path - mac80211 mesh path structure
  *
  * @dst: mesh path destination mac address
+ * @mpp: mesh proxy mac address
+ * @rhash: rhashtable list pointer
+ * @gate_list: list pointer for known gates list
  * @sdata: mesh subif
  * @next_hop: mesh neighbor to which frames for this destination will be
  *	forwarded
  * @timer: mesh path discovery timer
  * @frame_queue: pending queue for frames sent to this destination while the
  *	path is unresolved
+ * @rcu: rcu head for freeing mesh path
  * @sn: target sequence number
  * @metric: current metric to this destination
  * @hop_count: hops to destination
@@ -94,10 +96,10 @@ enum mesh_deferred_task_flags {
  * @is_gate: the destination station of this path is a mesh gate
  *
  *
- * The combination of dst and sdata is unique in the mesh path table. Since the
- * next_hop STA is only protected by RCU as well, deleting the STA must also
- * remove/substitute the mesh_path structure and wait until that is no longer
- * reachable before destroying the STA completely.
+ * The dst address is unique in the mesh path table. Since the mesh_path is
+ * protected by RCU, deleting the next_hop STA must remove / substitute the
+ * mesh_path structure and wait until that is no longer reachable before
+ * destroying the STA completely.
  */
 struct mesh_path {
 	u8 dst[ETH_ALEN];
@@ -127,10 +129,11 @@ struct mesh_path {
 /**
  * struct mesh_table
  *
- * @entries: number of entries in the table
  * @known_gates: list of known mesh gates and their mpaths by the station. The
  * gate's mpath may or may not be resolved and active.
- * @rhash: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @gates_lock: protects updates to known_gates
+ * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @entries: number of entries in the table
  */
 struct mesh_table {
 	struct hlist_head known_gates;
@@ -151,6 +154,7 @@ struct mesh_table {
  * @seqnum: mesh sequence number of the frame
  * @exp_time: expiration time of the entry, in jiffies
  * @sa: source address of the frame
+ * @list: hashtable list pointer
  *
  * The Recent Multicast Cache keeps track of the latest multicast frames that
  * have been received by a mesh interface and discards received multicast frames
-- 
2.6.1

