Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33251 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaDNJwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:52:03 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so7892574pde.38
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:52:02 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/6] mac80211: return bool instead of numbers in yes/no function
Date: Mon, 14 Apr 2014 17:51:33 +0800
Message-Id: <7e0cef80705e85eff58298ba03580dc3742335d8.1397469036.git.gamerh2o@gmail.com> (sfid-20140414_115356_662898_890ACAB7)
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
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

