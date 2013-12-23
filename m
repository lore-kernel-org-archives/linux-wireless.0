Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51100 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3LWLlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 06:41:08 -0500
Received: by mail-pa0-f44.google.com with SMTP id fa1so5217547pad.17
        for <linux-wireless@vger.kernel.org>; Mon, 23 Dec 2013 03:41:08 -0800 (PST)
From: Fred Chou <fred.chou.nd@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Chou <fred.chou.nd@gmail.com>
Subject: [PATCH] mac80211: reorder packet checking and processing
Date: Mon, 23 Dec 2013 19:42:55 +0800
Message-Id: <1387798975-17708-1-git-send-email-fred.chou.nd@gmail.com> (sfid-20131223_124112_877063_6AC29F4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check received packet length first and drop the packet
if it is shorter than MAC header. Process packet after
the checking. 

Signed-off-by: 	Fred Chou <fred.chou.nd@gmail.com>
---
 net/mac80211/rx.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 688e0aa..95b8cd9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3145,20 +3145,21 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct sta_info *sta, *tmp, *prev_sta;
 	int err = 0;
 
-	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
-	memset(&rx, 0, sizeof(rx));
-	rx.skb = skb;
-	rx.local = local;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
 
+	/* drop frame if too short for header */
+	if (skb->len < ieee80211_hdrlen(fc)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	/* update counter only for reliable packet */
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		local->dot11ReceivedFragmentCount++;
 
 	if (ieee80211_is_mgmt(fc)) {
-		/* drop frame if too short for header */
-		if (skb->len < ieee80211_hdrlen(fc))
-			err = -ENOBUFS;
-		else
-			err = skb_linearize(skb);
+		err = skb_linearize(skb);
 	} else {
 		err = !pskb_may_pull(skb, ieee80211_hdrlen(fc));
 	}
@@ -3168,7 +3169,10 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr *)skb->data;
+	memset(&rx, 0, sizeof(rx));
+	rx.skb = skb;
+	rx.local = local;
+
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
-- 
1.7.9.5

