Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38372 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaDUEzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:04 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so3347656pab.34
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:03 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 04/12] mac80211: return bool instead of numbers in yes/no function
Date: Mon, 21 Apr 2014 12:52:59 +0800
Message-Id: <4159b979438a7c3bdda39245684fb170932ab873.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065508_041952_7DAD04AD)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And some code style changes in the function, and correct a typo in
comment.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/rx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c86a4d6..87c28f8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -54,24 +54,25 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 	return skb;
 }
 
-static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
+static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr;
-
-	hdr = (void *)(skb->data);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
 			    RX_FLAG_AMPDU_IS_ZEROLEN))
-		return 1;
+		return true;
+
 	if (unlikely(skb->len < 16 + present_fcs_len))
-		return 1;
+		return true;
+
 	if (ieee80211_is_ctl(hdr->frame_control) &&
 	    !ieee80211_is_pspoll(hdr->frame_control) &&
 	    !ieee80211_is_back_req(hdr->frame_control))
-		return 1;
-	return 0;
+		return true;
+
+	return false;
 }
 
 static int
@@ -3190,7 +3191,7 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 }
 
 /*
- * This is the actual Rx frames handler. as it blongs to Rx path it must
+ * This is the actual Rx frames handler. as it belongs to Rx path it must
  * be called with rcu_read_lock protection.
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
-- 
1.9.0

