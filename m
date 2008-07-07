Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYGGMcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 08:32:21 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Date: Mon,  7 Jul 2008 15:32:16 +0300
Message-Id: <1215433936-5241-1-git-send-email-tomas.winkler@intel.com> (sfid-20080707_143227_232319_7DE303A5)
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
 include/linux/ieee80211.h |   11 +++++++++++
 net/mac80211/rx.c         |    2 +-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aa603c3..3865d4c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -460,6 +460,17 @@ static inline int ieee80211_is_nullfunc(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
 }
 
+/**
+ * ieee80211_is_nullfunc - check if FTYPE=IEEE80211_FTYPE_DATA and
+ * STYPE=IEEE80211_STYPE_QOS_NULLFUNC
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_qos_nullfunc(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6a88e8f..a6e8214 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2052,7 +2052,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
 	/* null data frames are excluded */
-	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
+	if (unlikely(ieee80211_is_qos_nullfunc(hdr->frame_control)))
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

