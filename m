Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab1CQS7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:23 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:22 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 9/9] mwl8k: Queue ADDBA requests in respective data queues
Date: Thu, 17 Mar 2011 11:58:49 -0700
Message-Id: <1300388329-15380-9-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Queue ADDBA requests in respective data queues to avoid ADDBA
requests and the the related data packets (to the same ra/tid)
queued in the hardware to be sent out asynchronously.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5473f4c..ae56d2f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1518,6 +1518,33 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		     MWL8K_TXD_STATUS_OK_RETRY |		\
 		     MWL8K_TXD_STATUS_OK_MORE_RETRY))
 
+static int mwl8k_tid_queue_mapping(u8 tid)
+{
+	BUG_ON(tid > 7);
+
+	switch (tid) {
+	case 0:
+	case 3:
+		return IEEE80211_AC_BE;
+		break;
+	case 1:
+	case 2:
+		return IEEE80211_AC_BK;
+		break;
+	case 4:
+	case 5:
+		return IEEE80211_AC_VI;
+		break;
+	case 6:
+	case 7:
+		return IEEE80211_AC_VO;
+		break;
+	default:
+		return -1;
+		break;
+	}
+}
+
 /* The firmware will fill in the rate information
  * for each packet that gets queued in the hardware
  * in this structure
@@ -1745,6 +1772,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	u8 tid = 0;
 	struct mwl8k_ampdu_stream *stream = NULL;
 	bool start_ba_session = false;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
 	wh = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_data_qos(wh->frame_control))
@@ -1788,6 +1816,24 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 			qos |= MWL8K_QOS_ACK_POLICY_NORMAL;
 	}
 
+	/* Queue ADDBA request in the respective data queue.  While setting up
+	 * the ampdu stream, mac80211 queues further packets for that
+	 * particular ra/tid pair.  However, packets piled up in the hardware
+	 * for that ra/tid pair will still go out. ADDBA request and the
+	 * related data packets going out from different queues asynchronously
+	 * will cause a shift in the receiver window which might result in
+	 * ampdu packets getting dropped at the receiver after the stream has
+	 * been setup.
+	 */
+	if (unlikely(ieee80211_is_action(wh->frame_control) &&
+	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
+	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ &&
+	    priv->ap_fw)) {
+		u16 capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
+		tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+		index = mwl8k_tid_queue_mapping(tid);
+	}
+
 	txpriority = index;
 
 	if (ieee80211_is_data_qos(wh->frame_control) &&
-- 
1.7.1.1

