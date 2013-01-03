Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60340 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab3ACIA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 03:00:58 -0500
Date: Thu, 3 Jan 2013 13:24:03 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 3/5] mwl8k: Handle Watchdog events for the new ampdu streams
Message-ID: <20130103075358.GA20387@markyou.marvell.com> (sfid-20130103_090100_336093_E25D2EFE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With more ampdu streams, we need to handle watchdog
events for the new ampdu streams. Handle these
events appropriately.

Earlier mwl8k_cmd_get_watchdog_bitmap used to return
only one stream index and hence bitwise operations
on the return value were not required. Now the function
returns a bitmap with different bits are mapped with
different stream indices.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a603e64..07b7546 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3603,7 +3603,11 @@ static int mwl8k_cmd_get_watchdog_bitmap(struct ieee80211_hw *hw, u8 *bitmap)
 	return rc;
 }
 
-#define INVALID_BA	0xAA
+#define MWL8K_WMM_QUEUE_NUMBER	3
+
+static void mwl8k_destroy_ba(struct ieee80211_hw *hw,
+			     u8 idx);
+
 static void mwl8k_watchdog_ba_events(struct work_struct *work)
 {
 	int rc;
@@ -3611,24 +3615,40 @@ static void mwl8k_watchdog_ba_events(struct work_struct *work)
 	struct mwl8k_ampdu_stream *streams;
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, watchdog_ba_handle);
+	struct ieee80211_hw *hw = priv->hw;
+	int i;
+	u32 status = 0;
+
+	mwl8k_fw_lock(hw);
 
 	rc = mwl8k_cmd_get_watchdog_bitmap(priv->hw, &bitmap);
 	if (rc)
-		return;
+		goto done;
 
-	if (bitmap == INVALID_BA)
-		return;
+	spin_lock(&priv->stream_lock);
 
 	/* the bitmap is the hw queue number.  Map it to the ampdu queue. */
-	stream_index = bitmap - MWL8K_TX_WMM_QUEUES;
-
-	BUG_ON(stream_index >= priv->num_ampdu_queues);
-
-	streams = &priv->ampdu[stream_index];
-
-	if (streams->state == AMPDU_STREAM_ACTIVE)
-		ieee80211_stop_tx_ba_session(streams->sta, streams->tid);
+	for (i = 0; i < TOTAL_HW_TX_QUEUES; i++) {
+		if (bitmap & (1 << i)) {
+			stream_index = (i + MWL8K_WMM_QUEUE_NUMBER) %
+				       TOTAL_HW_TX_QUEUES;
+			streams = &priv->ampdu[stream_index];
+			if (streams->state == AMPDU_STREAM_ACTIVE) {
+				ieee80211_stop_tx_ba_session(streams->sta,
+							     streams->tid);
+				spin_unlock(&priv->stream_lock);
+				mwl8k_destroy_ba(hw, stream_index);
+				spin_lock(&priv->stream_lock);
+			}
+		}
+	}
 
+	spin_unlock(&priv->stream_lock);
+done:
+	status = ioread32(priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
+	iowrite32((status | MWL8K_A2H_INT_BA_WATCHDOG),
+		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
+	mwl8k_fw_unlock(hw);
 	return;
 }
 
-- 
1.8.0.3

