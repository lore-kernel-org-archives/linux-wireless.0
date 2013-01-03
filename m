Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:38419 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab3ACH47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:56:59 -0500
Date: Thu, 3 Jan 2013 13:20:47 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Remove redundant txq_idx
Message-ID: <20130103075043.GA19951@markyou.marvell.com> (sfid-20130103_085705_286241_68419B4A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ampdu stream index can be derived from stream->idx.
So we no longer need stream->txq_idx, hence removing it.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0cdae66..93dd0ef 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -160,7 +160,6 @@ struct mwl8k_ampdu_stream {
 	u8 tid;
 	u8 state;
 	u8 idx;
-	u8 txq_idx; /* index of this stream in priv->txq */
 };
 
 struct mwl8k_priv {
@@ -1741,7 +1740,6 @@ mwl8k_add_stream(struct ieee80211_hw *hw, struct ieee80211_sta *sta, u8 tid)
 			stream->state = AMPDU_STREAM_NEW;
 			stream->tid = tid;
 			stream->idx = i;
-			stream->txq_idx = MWL8K_TX_WMM_QUEUES + i;
 			wiphy_debug(hw->wiphy, "Added a new stream for %pM %d",
 				    sta->addr, tid);
 			return stream;
@@ -1928,8 +1926,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		stream = mwl8k_lookup_stream(hw, sta->addr, tid);
 		if (stream != NULL) {
 			if (stream->state == AMPDU_STREAM_ACTIVE) {
-				txpriority = stream->txq_idx;
-				index = stream->txq_idx;
+				txpriority = stream->idx + MWL8K_TX_WMM_QUEUES;
+				index = stream->idx + MWL8K_TX_WMM_QUEUES;
 			} else if (stream->state == AMPDU_STREAM_NEW) {
 				/* We get here if the driver sends us packets
 				 * after we've initiated a stream, but before
-- 
1.8.0.3

