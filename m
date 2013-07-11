Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab3GKUhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 16:37:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UxNbr-0000JJ-U4
	for linux-wireless@vger.kernel.org; Thu, 11 Jul 2013 22:37:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix duplicate retransmission detection
Date: Thu, 11 Jul 2013 22:36:57 +0200
Message-Id: <1373575017-25645-1-git-send-email-johannes@sipsolutions.net> (sfid-20130711_223709_971822_FDFBE3E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The duplicate retransmission detection code in mac80211
erroneously attempts to do the check for every frame,
even frames that don't have a sequence control field or
that don't use it (QoS-Null frames.)

This is problematic because it causes the code to access
data beyond the end of the SKB and depending on the data
there will drop packets erroneously.

Correct the code to not do duplicate detection for such
frames.

I found this error while testing AP powersave, it lead
to retransmitted PS-Poll frames being dropped entirely
as the data beyond the end of the SKB was always zero.

Cc: stable@vger.kernel.org [all versions]
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23dbcfc..2c5a79b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -936,8 +936,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
-	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
-	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
+	/*
+	 * Drop duplicate 802.11 retransmissions
+	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
+	 */
+	if (rx->skb->len >= 24 && rx->sta &&
+	    !ieee80211_is_ctl(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
-- 
1.8.0

