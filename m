Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307AbZIQRnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/13] iwlwifi: do not clear TX info flags when receiving BlockAckResponse
Date: Thu, 17 Sep 2009 10:43:49 -0700
Message-Id: <1253209436-2309-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

OR-in AMPDU flags rather than assigning them.  This lets the TX status for
aggregated packets be processed by rs_tx_status.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a7422e5..ee0e26d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1394,7 +1394,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 
 	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
 	memset(&info->status, 0, sizeof(info->status));
-	info->flags = IEEE80211_TX_STAT_ACK;
+	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
 	info->status.ampdu_ack_map = successes;
 	info->status.ampdu_ack_len = agg->frame_count;
-- 
1.5.6.3

