Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38186 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1HXTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: refactor skb copy to failq in mesh_path_move_to_queue
Date: Wed, 24 Aug 2011 15:12:41 -0400
Message-Id: <1314213161-8871-1-git-send-email-linville@tuxdriver.com> (sfid-20110824_211516_777223_21A93408)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems a bit less awkward, and avoids the following warning:

  CC [M]  net/mac80211/mesh_pathtbl.o
net/mac80211/mesh_pathtbl.c: In function ‘mesh_path_move_to_queue’:
net/mac80211/mesh_pathtbl.c:291:24: warning: ‘cp_skb’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Does it matter if the copy ends-up on the failq before the original goes
to the gateq?

 net/mac80211/mesh_pathtbl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 75e4b60..b5caf5b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -307,14 +307,14 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 
 	while (num_skbs--) {
 		skb = __skb_dequeue(&failq);
-		if (copy)
+		if (copy) {
 			cp_skb = skb_copy(skb, GFP_ATOMIC);
+			if (cp_skb)
+				__skb_queue_tail(&failq, cp_skb);
+		}
 
 		prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
 		__skb_queue_tail(&gateq, skb);
-
-		if (copy && cp_skb)
-			__skb_queue_tail(&failq, cp_skb);
 	}
 
 	spin_lock_irqsave(&gate_mpath->frame_queue.lock, flags);
-- 
1.7.4.4

