Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2KWHlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:41:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix radiotap vendor area skipping
Date: Fri, 23 Nov 2012 08:41:39 +0100
Message-Id: <1353656499-11817-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084116_346366_7F59EB8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The radiotap vendor area in the skb head must be skipped
and accounted for in a few functions until it is removed.
I missed this in my patch, so a few places use this data
as though it was the 802.11 header, fix these places.

Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ec15a49..ec87902 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -62,13 +62,16 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr;
+
+	hdr = (void *)(skb->data + status->vendor_radiotap_len);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
 			    RX_FLAG_AMPDU_IS_ZEROLEN))
 		return 1;
-	if (unlikely(skb->len < 16 + present_fcs_len))
+	if (unlikely(skb->len < 16 + present_fcs_len +
+				status->vendor_radiotap_len))
 		return 1;
 	if (ieee80211_is_ctl(hdr->frame_control) &&
 	    !ieee80211_is_pspoll(hdr->frame_control) &&
@@ -341,8 +344,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
-	/* make sure hdr->frame_control is on the linear part */
-	if (!pskb_may_pull(origskb, 2)) {
+	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
+	if (!pskb_may_pull(origskb, 2 + status->vendor_radiotap_len)) {
 		dev_kfree_skb(origskb);
 		return NULL;
 	}
-- 
1.8.0

