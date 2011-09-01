Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61873 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1IARFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 13:05:14 -0400
Received: by yie30 with SMTP id 30so1552556yie.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 10:05:13 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2] mac80211: Defer tranmission of mesh path errors
Date: Thu,  1 Sep 2011 10:04:45 -0700
Message-Id: <1314896685-2932-2-git-send-email-javier@cozybit.com> (sfid-20110901_190517_383951_9BED628E)
In-Reply-To: <1314896685-2932-1-git-send-email-javier@cozybit.com>
References: <1314767494.4161.2.camel@jlt3.sipsolutions.net>
 <1314896685-2932-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under failure conditions, the mesh stack sends PERR messages to the
previous sender of the failed frame.  This happens in the tx feedback
path, in which the transmission queue lock may be taken.  Avoid a
deadlock by sending the path error via the pending queue.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: - Helper to prepare skb for deferred transmission (Johannes)
    - Reword comment (Johannes)

 net/mac80211/mesh_hwmp.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fd4f76a..cda4818 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include "wme.h"
 #include "mesh.h"
 
 #ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
@@ -202,6 +203,25 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	return 0;
 }
 
+
+static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
+		struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, 0);
+	skb_set_transport_header(skb, 0);
+
+	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
+	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+	skb->priority = 7;
+
+	info->control.vif = &sdata->vif;
+	ieee80211_set_qos_hdr(local, skb);
+}
+
 /**
  * mesh_send_path error - Sends a PERR mesh management frame
  *
@@ -209,6 +229,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
  * @target_sn: SN of the broken destination
  * @target_rcode: reason code for this PERR
  * @ra: node this frame is addressed to
+ *
+ * Note: This function may be called with driver locks taken that the driver
+ * also acquires in the TX path.  To avoid a deadlock we don't transmit the
+ * frame directly but add it to the pending queue instead.
  */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       __le16 target_rcode, const u8 *ra,
@@ -222,7 +246,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 
 	if (!skb)
 		return -1;
-	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_reserve(skb, local->tx_headroom + local->hw.extra_tx_headroom);
 	/* 25 is the size of the common mgmt part (24) plus the size of the
 	 * common action part (1)
 	 */
@@ -263,7 +287,9 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	pos += 4;
 	memcpy(pos, &target_rcode, 2);
 
-	ieee80211_tx_skb(sdata, skb);
+	/* see note in function header */
+	prepare_frame_for_deferred_tx(sdata, skb);
+	ieee80211_add_pending_skb(local, skb);
 	return 0;
 }
 
-- 
1.7.6

