Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1H3S3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:29:22 -0400
Received: by iabu26 with SMTP id u26so1804709iab.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 11:29:22 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Defer tranmission of mesh path errors
Date: Tue, 30 Aug 2011 11:29:14 -0700
Message-Id: <1314728954-22646-1-git-send-email-javier@cozybit.com> (sfid-20110830_202927_625112_814087D2)
In-Reply-To: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
References: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under failure conditions, the mesh stack sends PERR messages to the
previous sender of the failed frame.  This happens in the tx feedback
path, in which the transmission queue lock may be taken.  Avoid a
deadlock by sending the path error via the pending queue.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fd4f76a..f760679 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -209,6 +209,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
  * @target_sn: SN of the broken destination
  * @target_rcode: reason code for this PERR
  * @ra: node this frame is addressed to
+ *
+ * Note: This function may be called from the tx feedback path, possibly with
+ * the transmission queue lock taken.  To avoid a deadlock we don't transmit
+ * the frame directly but add it to the pending queue instead.
  */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       __le16 target_rcode, const u8 *ra,
@@ -263,7 +267,8 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	pos += 4;
 	memcpy(pos, &target_rcode, 2);
 
-	ieee80211_tx_skb(sdata, skb);
+	/* see note in function header */
+	ieee80211_add_pending_skb(local, skb);
 	return 0;
 }
 
-- 
1.7.6

