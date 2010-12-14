Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab0LNARI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/14] iwlagn: fix debug variable access
Date: Mon, 13 Dec 2010 16:09:22 -0800
Message-Id: <1292285372-11373-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The compiler correctly warns:
iwl-agn-tx.c: In function ‘iwlagn_tx_status_reply_compressed_ba’:
iwl-agn-tx.c:1240: warning: ‘bitmap’ may be used uninitialized in this function

Move the debug print to the branch that reads the
bitmap, and move the variables too so it's more
obvious where they are needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 72b1f26..24a11b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1237,7 +1237,6 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	int i, sh, ack;
 	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-	u64 bitmap, sent_bitmap;
 	int successes = 0;
 	struct ieee80211_tx_info *info;
 
@@ -1278,6 +1277,8 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 		IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
 				ba_resp->txed, ba_resp->txed_2_done);
 	} else {
+		u64 bitmap, sent_bitmap;
+
 		/* don't use 64-bit values for now */
 		bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
 
@@ -1298,7 +1299,11 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 			sent_bitmap >>= 1;
 			++i;
 		}
+
+		IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n",
+				   (unsigned long long)bitmap);
 	}
+
 	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1313,8 +1318,6 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	}
 	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
-	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
-
 	return 0;
 }
 
-- 
1.7.0.4

