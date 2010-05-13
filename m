Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab0EMVuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/17] iwl3945: remove sequence number assignment
Date: Thu, 13 May 2010 14:49:47 -0700
Message-Id: <1273787399-9280-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unlike agn, where the sequence numbers must
match with the TFD index, the driver for 3945
devices can use the sequence numbers provided
by mac80211 for QoS frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 +-----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 858a548..8538af7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -433,7 +433,7 @@ struct iwl_ht_agg {
 
 
 struct iwl_tid_data {
-	u16 seq_number;
+	u16 seq_number; /* agn only */
 	u16 tfds_in_queue;
 	struct iwl_ht_agg agg;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 68b8a1a..4454064 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -473,10 +473,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u8 unicast;
 	u8 sta_id;
 	u8 tid = 0;
-	u16 seq_number = 0;
 	__le16 fc;
 	u8 wait_write_ptr = 0;
-	u8 *qc = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -519,16 +517,10 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	IWL_DEBUG_RATE(priv, "station Id %d\n", sta_id);
 
 	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		if (unlikely(tid >= MAX_TID_COUNT))
 			goto drop;
-		seq_number = priv->stations[sta_id].tid[tid].seq_number &
-				IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = cpu_to_le16(seq_number) |
-			(hdr->seq_ctrl &
-				cpu_to_le16(IEEE80211_SCTL_FRAG));
-		seq_number += 0x10;
 	}
 
 	/* Descriptor for chosen Tx queue */
@@ -587,8 +579,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
-		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
-- 
1.6.3.3

