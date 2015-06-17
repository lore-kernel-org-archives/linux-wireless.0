Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46846 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbbFQI4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:56:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/14] mac80211: remove IEEE80211_RX_FRAGMENTED
Date: Wed, 17 Jun 2015 10:41:13 +0200
Message-Id: <1434530475-3553-13-git-send-email-johannes@sipsolutions.net> (sfid-20150617_105639_002208_A848EADF)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a long-standing TODO item to use this flag in the cooked
monitor RX, but clearly it was never needed and now this hasn't
been used by userspace for a long time, so no userspace changes
could require it now.

Remove the unused flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 --
 net/mac80211/rx.c          | 2 --
 2 files changed, 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7d75f93bac7d..68b091a0cae1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -181,7 +181,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
 
 /**
  * enum ieee80211_packet_rx_flags - packet RX flags
- * @IEEE80211_RX_FRAGMENTED: fragmented frame
  * @IEEE80211_RX_AMSDU: a-MSDU packet
  * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
  * @IEEE80211_RX_DEFERRED_RELEASE: frame was subjected to receive reordering
@@ -190,7 +189,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
  * @rx_flags field of &struct ieee80211_rx_status.
  */
 enum ieee80211_packet_rx_flags {
-	IEEE80211_RX_FRAGMENTED			= BIT(2),
 	IEEE80211_RX_AMSDU			= BIT(3),
 	IEEE80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
 	IEEE80211_RX_DEFERRED_RELEASE		= BIT(5),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3037bd152ffa..3a1462810c8e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1917,7 +1917,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	/* Complete frame has been reassembled - process it now */
 	status = IEEE80211_SKB_RXCB(rx->skb);
-	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
 
  out:
 	ieee80211_led_rx(rx->local);
@@ -3037,7 +3036,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
-/* TODO: use IEEE80211_RX_FRAGMENTED */
 static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 					struct ieee80211_rate *rate)
 {
-- 
2.1.4

