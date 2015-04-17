Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47624 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbbDQPQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:16:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/11] mac80211: allow checksum offload only in fast-xmit
Date: Fri, 17 Apr 2015 17:15:48 +0200
Message-Id: <1429283751-5104-8-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171617_497512_2B1C1A26)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we go through the complete TX processing, there are a number
of things like fragmentation and software crypto that require the
checksum to be calculated already.

In favour of maintainability, instead of adding the necessary call
to skb_checksum_help() in all the places that need it, just do it
once before the regular TX processing.

Right now this only affects the TI wlcore and QCA ath10k drivers
since they're the only ones using checksum offload. The previous
commits enabled fast-xmit for them in almost all cases.

For wlcore this even fixes a corner case: when a key fails to be
programmed to hardware software encryption gets used, encrypting
frames with a bad checksum.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0f18ee11f097..e76f3e96eb84 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2835,10 +2835,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
-		kfree_skb(skb);
-		goto out;
-	}
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
+		goto out_free;
 
 	if (!IS_ERR_OR_NULL(sta)) {
 		struct ieee80211_fast_tx *fast_tx;
@@ -2850,6 +2848,21 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 	}
 
+	/* the frame could be fragmented, software-encrypted, and other things
+	 * so we cannot really handle checksum offload with it - fix it up in
+	 * software before we handle anything else.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (skb->encapsulation)
+			skb_set_inner_transport_header(skb,
+						       skb_checksum_start_offset(skb));
+		else
+			skb_set_transport_header(skb,
+						 skb_checksum_start_offset(skb));
+		if (skb_checksum_help(skb))
+			goto out_free;
+	}
+
 	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
 	if (IS_ERR(skb))
 		goto out;
@@ -2859,6 +2872,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	dev->trans_start = jiffies;
 
 	ieee80211_xmit(sdata, sta, skb);
+	goto out;
+ out_free:
+	kfree_skb(skb);
  out:
 	rcu_read_unlock();
 }
-- 
2.1.4

