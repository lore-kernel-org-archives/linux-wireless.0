Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19229 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYGIVr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 17:47:26 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, harvey.harrison@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1 V3] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Date: Thu, 10 Jul 2008 00:47:19 +0300
Message-Id: <1215640039-15992-1-git-send-email-tomas.winkler@intel.com> (sfid-20080709_234732_486356_47CFEC51)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes the check at the entrance to ieee80211_rx_reorder_ampdu.
This check has been broken by 511fe3f3c4ba0b5b77421336f64a19b6cd00e65f
'mac80211: rx.c use new helpers'

Letting QoS NULL packet in ieee80211_rx_reorder_ampdu led to packet loss in
RX.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fab443d..e977ff6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2046,8 +2046,8 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
-	/* null data frames are excluded */
-	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
+	/* qos null data frames are excluded */
+	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
 		goto end_reorder;
 
 	/* new un-ordered ampdu frame - process it */
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

