Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:60466 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab1LTGHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 01:07:15 -0500
Date: Tue, 20 Dec 2011 11:37:08 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Call ieee80211_stop_tx_ba_cb_irqsafe for already
 deleted BA stream
Message-ID: <20111220060657.GA4591@hertz.marvell.com> (sfid-20111220_070718_566398_98CCD895)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When stack calls ampdu_action with action = IEEE80211_AMPDU_TX_STOP
for a stream that has already been removed from the driver, call
ieee80211_tx_ba_stop_irqsafe to clear the stream in the stack.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 995695c..901cd79 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5044,14 +5044,14 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		if (stream == NULL)
-			break;
-		if (stream->state == AMPDU_STREAM_ACTIVE) {
-			spin_unlock(&priv->stream_lock);
-			mwl8k_destroy_ba(hw, stream);
-			spin_lock(&priv->stream_lock);
+		if (stream) {
+			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				spin_unlock(&priv->stream_lock);
+				mwl8k_destroy_ba(hw, stream);
+				spin_lock(&priv->stream_lock);
+			}
+			mwl8k_remove_stream(hw, stream);
 		}
-		mwl8k_remove_stream(hw, stream);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-- 
1.7.5.4

