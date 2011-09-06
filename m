Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64964 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1IFTK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 15:10:56 -0400
Received: by yxj19 with SMTP id 19so3227207yxj.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 12:10:55 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v3] mac80211: Defer tranmission of mesh path errors
Date: Tue,  6 Sep 2011 12:10:43 -0700
Message-Id: <1315336244-23351-1-git-send-email-javier@cozybit.com> (sfid-20110906_211100_331045_73E75338)
In-Reply-To: <1314961190.3927.6.camel@jlt3.sipsolutions.net>
References: <1314961190.3927.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under failure conditions, the mesh stack sends PERR messages to the
previous sender of the failed frame.  This happens in the tx feedback
path, in which the transmission queue lock may be taken.  Avoid a
deadlock by sending the path error via the pending queue.

---
v3: - Comment on headroom size (Johannes)
v2: - Prepare skb for deferred transmission (Johannes)
    - Reword comment (Johannes)

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

 net/mac80211/mesh_hwmp.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fd4f76a..63df0bc 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include "wme.h"
 #include "mesh.h"
 
 #ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
@@ -202,6 +203,27 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	return 0;
 }
 
+
+/*  Headroom is not adjusted.  Caller should ensure that skb has sufficient
+ *  headroom in case the frame is encrypted. */
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
@@ -209,6 +231,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
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
@@ -222,7 +248,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 
 	if (!skb)
 		return -1;
-	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_reserve(skb, local->tx_headroom + local->hw.extra_tx_headroom);
 	/* 25 is the size of the common mgmt part (24) plus the size of the
 	 * common action part (1)
 	 */
@@ -263,7 +289,9 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
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

