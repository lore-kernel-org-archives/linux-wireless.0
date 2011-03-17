Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42318 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1CQS7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:21 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3123030iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:21 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 8/9] mwl8k: Check outgoing rate for a station to decide if ampdu can be created
Date: Thu, 17 Mar 2011 11:58:48 -0700
Message-Id: <1300388329-15380-8-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

If the outgoing packet rate to a particular HT station is <=6.5
Mbps, do not attempt to create an ampdu. Also, if the outgoing
rate is legacy rate, do not create an ampdu.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   60 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b90178d..5473f4c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -291,6 +291,7 @@ struct mwl8k_vif {
 struct mwl8k_sta {
 	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8 peer_id;
+	u8 is_ampdu_allowed;
 };
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
@@ -1517,6 +1518,27 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		     MWL8K_TXD_STATUS_OK_RETRY |		\
 		     MWL8K_TXD_STATUS_OK_MORE_RETRY))
 
+/* The firmware will fill in the rate information
+ * for each packet that gets queued in the hardware
+ * in this structure
+ */
+
+struct rateinfo {
+	__le16  format:1;
+	__le16  short_gi:1;
+	__le16  band_width:1;
+	__le16  rate_id_mcs:6;
+	__le16  adv_coding:2;
+	__le16  antenna:2;
+	__le16  act_sub_chan:2;
+	__le16  preamble_type:1;
+	__le16  power_id:4;
+	__le16  antenna2:1;
+	__le16  reserved:1;
+	__le16  tx_bf_frame:1;
+	__le16  green_field:1;
+} __packed;
+
 static int
 mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 {
@@ -1533,6 +1555,11 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		struct sk_buff *skb;
 		struct ieee80211_tx_info *info;
 		u32 status;
+		struct ieee80211_sta *sta;
+		struct mwl8k_sta *sta_info = NULL;
+		u16 rate_info;
+		struct rateinfo *rate;
+		struct ieee80211_hdr *wh;
 
 		tx = txq->head;
 		tx_desc = txq->txd + tx;
@@ -1561,11 +1588,34 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 
 		mwl8k_remove_dma_header(skb, tx_desc->qos_control);
 
+		wh = (struct ieee80211_hdr *) skb->data;
+
 		/* Mark descriptor as unused */
 		tx_desc->pkt_phys_addr = 0;
 		tx_desc->pkt_len = 0;
 
 		info = IEEE80211_SKB_CB(skb);
+		if (ieee80211_is_data(wh->frame_control)) {
+			sta = info->control.sta;
+			if (sta) {
+				sta_info = MWL8K_STA(sta);
+				BUG_ON(sta_info == NULL);
+				rate_info = le16_to_cpu(tx_desc->rate_info);
+				rate = (struct rateinfo *)&rate_info;
+				/* If rate is < 6.5 Mpbs for an ht station
+				 * do not form an ampdu. If the station is a
+				 * legacy station (format = 0), do not form an
+				 * ampdu
+				 */
+				if (rate->rate_id_mcs < 1 ||
+				    rate->format == 0) {
+					sta_info->is_ampdu_allowed = false;
+				} else {
+					sta_info->is_ampdu_allowed = true;
+				}
+			}
+		}
+
 		ieee80211_tx_info_clear_status(info);
 
 		/* Rate control is happening in the firmware.
@@ -1784,9 +1834,11 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 			 * prevents sequence number mismatch at the recepient
 			 * as described above.
 			 */
-			stream = mwl8k_add_stream(hw, sta, tid);
-			if (stream != NULL)
-				start_ba_session = true;
+			if (MWL8K_STA(sta)->is_ampdu_allowed) {
+				stream = mwl8k_add_stream(hw, sta, tid);
+				if (stream != NULL)
+					start_ba_session = true;
+			}
 		}
 		spin_unlock(&priv->stream_lock);
 	}
@@ -4719,6 +4771,8 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 		ret = mwl8k_cmd_update_stadb_add(hw, vif, sta);
 		if (ret >= 0) {
 			MWL8K_STA(sta)->peer_id = ret;
+			if (sta->ht_cap.ht_supported)
+				MWL8K_STA(sta)->is_ampdu_allowed = true;
 			ret = 0;
 		}
 
-- 
1.7.1.1

