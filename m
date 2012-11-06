Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57327 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab2KFN5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 08:57:36 -0500
Date: Tue, 6 Nov 2012 19:22:35 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: recheck if station still has valid rates
Message-ID: <20121106135231.GA8447@markyou.marvell.com> (sfid-20121106_145748_184270_861AD672)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have 6.5 Mbps is minimum rate of the link
as the criterion for creation of BA.

Although we check this before creating the BA
stream, by the time amdpu_action is called from
the workqueue, the link can get affected in the
meantime.
Hence, add an additional check in amdpu_action.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cb5594d..9961765 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5085,6 +5085,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_ampdu_stream *stream;
 	u8 *addr = sta->addr;
+	struct mwl8k_sta *sta_info = MWL8K_STA(sta);
 
 	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
 		return -ENOTSUPP;
@@ -5127,6 +5128,15 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		/* Release the lock before we do the time consuming stuff */
 		spin_unlock(&priv->stream_lock);
 		for (i = 0; i < MAX_AMPDU_ATTEMPTS; i++) {
+
+			/* Check if link is still valid */
+			if (!sta_info->is_ampdu_allowed) {
+				spin_lock(&priv->stream_lock);
+				mwl8k_remove_stream(hw, stream);
+				spin_unlock(&priv->stream_lock);
+				return -EBUSY;
+			}
+
 			rc = mwl8k_check_ba(hw, stream);
 
 			/* If HW restart is in progress mwl8k_post_cmd will
-- 
1.7.9.2

