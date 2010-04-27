Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab0D0RPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 13:15:03 -0400
From: <shanyu.zhao@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Shanyu Zhao <shanyu.zhao@intel.com>
Subject: [PATCH 1/1] mac80211: fix rts threshold check
Date: Tue, 27 Apr 2010 11:15:12 -0700
Message-Id: <1272392112-28301-1-git-send-email-shanyu.zhao@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Currently whenever rts thresold is set, every packet will use RTS
protection no matter its size exceeds the threshold or not. This is
due to a bug in the rts threshold check.
	if (len > tx->local->hw.wiphy->rts_threshold) {
		txrc.rts = rts = true;
	}
Basically it is comparing an int (len) and a u32 (rts_threshold),
and the variable len is assigned as:
	len = min_t(int, tx->skb->len + FCS_LEN,
			 tx->local->hw.wiphy->frag_threshold);
However, when frag_threshold is "-1", len is always "-1", which is
0xffffffff therefore rts is always set to true.

CC: stable@kernel.org

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
---
 net/mac80211/tx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e2aa972..f3841f4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -593,7 +593,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	struct ieee80211_hdr *hdr = (void *)tx->skb->data;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
-	int i, len;
+	int i;
+	u32 len;
 	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
 	u32 sta_flags;
@@ -602,7 +603,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	len = min_t(int, tx->skb->len + FCS_LEN,
+	len = min_t(u32, tx->skb->len + FCS_LEN,
 			 tx->local->hw.wiphy->frag_threshold);
 
 	/* set up the tx rate control struct we give the RC algo */
-- 
1.6.0.4

