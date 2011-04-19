Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40651 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1DSRMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 13:12:41 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: [PATCH V2 3/4] mwl8k: Reserve buffers for tx management frames
Date: Tue, 19 Apr 2011 22:16:21 +0530
Message-Id: <1303231582-17333-3-git-send-email-nishants@marvell.com>
In-Reply-To: <1303231582-17333-1-git-send-email-nishants@marvell.com>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since queues are not stopped anymore, management frames would be
dropped if the corresponding tx queue is full.
This can cause issues say when we want to setup an ampdu stream and
action frames i.e addba requests keep getting dropped frequently.
Fix this by reserving some buffers to allow management frames to
go through in queue full conditions.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index aca0139..82cd725 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1818,6 +1818,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	u8 tid = 0;
 	struct mwl8k_ampdu_stream *stream = NULL;
 	bool start_ba_session = false;
+	bool mgmtframe = false;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
 	wh = (struct ieee80211_hdr *)skb->data;
@@ -1826,6 +1827,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
+	if (ieee80211_is_mgmt(wh->frame_control))
+		mgmtframe = true;
+
 	if (priv->ap_fw)
 		mwl8k_encapsulate_tx_frame(skb);
 	else
@@ -1955,15 +1959,25 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	txq = priv->txq + index;
 
-	if (txq->len >= MWL8K_TX_DESCS) {
-		if (start_ba_session) {
-			spin_lock(&priv->stream_lock);
-			mwl8k_remove_stream(hw, stream);
-			spin_unlock(&priv->stream_lock);
+	/* Mgmt frames that go out frequently are probe responses.
+	 * Other mgmt frames got out relatively infrequently.
+	 * Hence reserve 2 buffers so that other mgmt frames do not get
+	 * dropped due to an already queued probe response in one of
+	 * the reserved buffers.
+	 */
+
+	if (txq->len >= (MWL8K_TX_DESCS - 2)) {
+		if ((mgmtframe == false) ||
+			(txq->len == MWL8K_TX_DESCS)) {
+			if (start_ba_session) {
+				spin_lock(&priv->stream_lock);
+				mwl8k_remove_stream(hw, stream);
+				spin_unlock(&priv->stream_lock);
+			}
+			spin_unlock_bh(&priv->tx_lock);
+			dev_kfree_skb(skb);
+			return;
 		}
-		spin_unlock_bh(&priv->tx_lock);
-		dev_kfree_skb(skb);
-		return;
 	}
 
 	BUG_ON(txq->skb[txq->tail] != NULL);
-- 
1.6.0.3

