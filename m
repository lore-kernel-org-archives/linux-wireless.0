Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:8848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbYFVXpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:45:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1780017wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 16:45:31 -0700 (PDT)
Subject: [PATCH 3/4] mac80211: rx.c use new frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 16:45:29 -0700
Message-Id: <1214178329.21092.16.camel@brick> (sfid-20080623_014554_016316_19C6E428)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/rx.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c32a0bc..8962d13 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -61,7 +61,7 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
 				    int present_fcs_len,
 				    int radiotap_len)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		return 1;
@@ -2123,7 +2123,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
 	u16 mpdu_seq_num;
-	u8 ret = 0, *qc;
+	u8 ret = 0;
 	int tid;
 
 	sta = sta_info_get(local, hdr->addr2);
@@ -2135,8 +2135,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		goto end_reorder;
 
-	qc = ieee80211_get_qos_ctl(hdr);
-	tid = qc[0] & QOS_CONTROL_TID_MASK;
+	tid = *ieee80211_get_qos_ctl(hdr) & QOS_CONTROL_TID_MASK;
 
 	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
 		goto end_reorder;
-- 
1.5.6.290.gc4e15


