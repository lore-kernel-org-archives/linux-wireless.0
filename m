Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:44781 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2KFN57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 08:57:59 -0500
Date: Tue, 6 Nov 2012 19:23:01 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Do not expire eapol frames
Message-ID: <20121106135256.GA8458@markyou.marvell.com> (sfid-20121106_145801_870543_1EA5FC0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can cause issues when clients try to connect when the
traffic is heavy

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5b5b9ec..a4d3dcb 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1851,6 +1851,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	bool start_ba_session = false;
 	bool mgmtframe = false;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	bool eapol_frame = false;
 
 	wh = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_data_qos(wh->frame_control))
@@ -1858,6 +1859,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	else
 		qos = 0;
 
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE))
+		eapol_frame = true;
+
 	if (ieee80211_is_mgmt(wh->frame_control))
 		mgmtframe = true;
 
@@ -1916,9 +1920,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 
 	txpriority = index;
 
-	if (priv->ap_fw && sta && sta->ht_cap.ht_supported
-			&& skb->protocol != cpu_to_be16(ETH_P_PAE)
-			&& ieee80211_is_data_qos(wh->frame_control)) {
+	if (priv->ap_fw && sta && sta->ht_cap.ht_supported && !eapol_frame &&
+	    ieee80211_is_data_qos(wh->frame_control)) {
 		tid = qos & 0xf;
 		mwl8k_tx_count_packet(sta, tid);
 		spin_lock(&priv->stream_lock);
@@ -2027,7 +2030,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	else
 		tx->peer_id = 0;
 
-	if (priv->ap_fw)
+	if (priv->ap_fw && ieee80211_is_data(wh->frame_control) && !eapol_frame)
 		tx->timestamp = cpu_to_le32(ioread32(priv->regs +
 						MWL8K_HW_TIMER_REGISTER));
 
-- 
1.7.9.2

