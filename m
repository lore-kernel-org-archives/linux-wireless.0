Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46296 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3IPMiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 08:38:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] mac80211: support reporting A-MSDU subframes individually
Date: Mon, 16 Sep 2013 14:38:09 +0200
Message-ID: <1379335089-10538-1-git-send-email-michal.kazior@tieto.com> (sfid-20130916_143829_861770_A51AC17E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices may not be able to report A-MSDUs in
single buffers. Drivers for such devices were
forced to re-assemble A-MSDUs which would then
be eventually disassembled by mac80211. This could
lead to CPU cache thrashing and poor performance.

Since A-MSDU has a single sequence number all
subframes share it. This was in conflict with
retransmission/duplication recovery
(IEEE802.11-2012: 9.3.2.10).

Patch introduces a new flag that is meant to be
set for all individually reported A-MSDU subframes
except the last one. This ensures the
last_seq_ctrl is updated after the last subframe
is processed. If an A-MSDU is actually a duplicate
transmission all reported subframes will be
properly discarded.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/rx.c      |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 06ffae8..f8f049d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -829,6 +829,15 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
  * @RX_FLAG_10MHZ: 10 MHz (half channel) was used
  * @RX_FLAG_5MHZ: 5 MHz (quarter channel) was used
+ * @RX_FLAG_AMSDU_MORE: Some drivers may prefer to report separate A-MSDU
+ *	subframes instead of a one huge frame for performance reasons.
+ *	All, but the last MSDU from an A-MSDU should have this flag set. E.g.
+ *	if an A-MSDU has 3 frames, the first 2 must have the flag set, while
+ *	the 3rd (last) one must not have this flag set. The flag is used to
+ *	deal with retransmission/duplication recovery properly since A-MSDU
+ *	subframes share the same sequence number. Reported subframes can be
+ *	either regular MSDU or singly A-MSDUs. Subframes must not be
+ *	interleaved with other frames.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -859,6 +868,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
 	RX_FLAG_10MHZ			= BIT(28),
 	RX_FLAG_5MHZ			= BIT(29),
+	RX_FLAG_AMSDU_MORE		= BIT(30),
 };
 
 #define RX_FLAG_STBC_SHIFT		26
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8e908e1..43bee02 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -995,7 +995,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 				rx->sta->num_duplicates++;
 			}
 			return RX_DROP_UNUSABLE;
-		} else
+		} else if (!(status->flag & RX_FLAG_AMSDU_MORE))
 			rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
 	}
 
-- 
1.7.9.5

