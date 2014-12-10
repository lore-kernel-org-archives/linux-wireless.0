Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51671 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaLJPyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 10:54:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: Fix accounting of multicast frames
Date: Wed, 10 Dec 2014 21:26:11 +0530
Message-Id: <1418226973-13779-2-git-send-email-sujith@msujith.org> (sfid-20141210_165442_725308_B173DC96)
In-Reply-To: <1418226973-13779-1-git-send-email-sujith@msujith.org>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since multicast frames are marked as no-ack, using
IEEE80211_TX_STAT_ACK to check if they have been
successfully transmitted by the driver is incorrect
since a driver can choose to ignore transmission status
for no-ack frames. This results in incorrect accounting
for such frames.

To fix this issue, this patch introduces a new flag
that can be used by drivers to indicate error-free
transmission of no-ack frames.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/status.c  | 9 ++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b36e60d..3c15440 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -505,6 +505,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *	would be fragmented by size (this is optional, only used for
  *	monitor injection).
+ * @IEEE80211_TX_STAT_NOACK_TRANSMITTED: A frame that was marked with
+ *	IEEE80211_TX_CTL_NO_ACK has been successfully transmitted without
+ *	any errors (like issues specific to the driver/HW).
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -540,6 +543,7 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
 	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
+	IEEE80211_TX_STAT_NOACK_TRANSMITTED	= BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index bb146f3..d64037c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -664,13 +664,15 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	int retry_count;
 	int rates_idx;
-	bool acked;
+	bool acked, noack_success;
 
 	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
 	sband = hw->wiphy->bands[info->band];
 
 	acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
+	noack_success = !!(info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED);
+
 	if (pubsta) {
 		struct sta_info *sta;
 
@@ -696,7 +698,7 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 		rate_control_tx_status_noskb(local, sband, sta, info);
 	}
 
-	if (acked) {
+	if (acked || noack_success) {
 		    local->dot11TransmittedFrameCount++;
 		    if (!pubsta)
 			    local->dot11MulticastTransmittedFrameCount++;
@@ -856,7 +858,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * Fragments are passed to low-level drivers as separate skbs, so these
 	 * are actually fragments, not frames. Update frame counters only for
 	 * the first fragment of the frame. */
-	if (info->flags & IEEE80211_TX_STAT_ACK) {
+	if ((info->flags & IEEE80211_TX_STAT_ACK) ||
+	    (info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED)) {
 		if (ieee80211_is_first_frag(hdr->seq_ctrl)) {
 			local->dot11TransmittedFrameCount++;
 			if (is_multicast_ether_addr(hdr->addr1))
-- 
2.1.3

