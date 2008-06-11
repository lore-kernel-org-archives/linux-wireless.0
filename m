Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:49794 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYFKVWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:13 -0400
Received: by py-out-1112.google.com with SMTP id p76so1566332pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:22:13 -0700 (PDT)
Subject: [PATCHv2 08/11] mac80211: rx.c use new helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:21:59 -0700
Message-Id: <1213219319.5974.181.camel@brick> (sfid-20080611_232217_690287_32DDCB6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/rx.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a3643fd..e80336f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -67,12 +67,9 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
 		return 1;
 	if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
 		return 1;
-	if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
-			cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
-	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
-			cpu_to_le16(IEEE80211_STYPE_PSPOLL)) &&
-	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
-			cpu_to_le16(IEEE80211_STYPE_BACK_REQ)))
+	if (ieee80211_is_ctl(hdr->frame_control) &&
+	    !ieee80211_is_pspoll(hdr->frame_control) &&
+	    !ieee80211_is_back_req(hdr->frame_control))
 		return 1;
 	return 0;
 }
@@ -2118,7 +2115,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta;
 	struct tid_ampdu_rx *tid_agg_rx;
-	u16 fc, sc;
+	u16 sc;
 	u16 mpdu_seq_num;
 	u8 ret = 0, *qc;
 	int tid;
@@ -2127,14 +2124,12 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	if (!sta)
 		return ret;
 
-	fc = le16_to_cpu(hdr->frame_control);
-
 	/* filter the QoS data rx stream according to
 	 * STA/TID and check if this STA/TID is on aggregation */
-	if (!WLAN_FC_IS_QOS_DATA(fc))
+	if (!ieee80211_is_data_qos(hdr->frame_control))
 		goto end_reorder;
 
-	qc = skb->data + ieee80211_get_hdrlen(fc) - QOS_CONTROL_LEN;
+	qc = ieee80211_get_qos_ctl(hdr);
 	tid = qc[0] & QOS_CONTROL_TID_MASK;
 
 	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
@@ -2143,7 +2138,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
 	/* null data frames are excluded */
-	if (unlikely(fc & IEEE80211_STYPE_NULLFUNC))
+	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
 		goto end_reorder;
 
 	/* new un-ordered ampdu frame - process it */
-- 
1.5.6.rc2.261.ga8fbe


