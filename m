Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45694 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab3ACIAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 03:00:52 -0500
Date: Thu, 3 Jan 2013 13:23:33 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/5] mwl8k: changing mwl8k_destroy_ba prototype
Message-ID: <20130103075328.GA20349@markyou.marvell.com> (sfid-20130103_090054_592016_E39E6A75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mwl8k_ampdu_stream is passed as one of the
argument to the function mwl8k_destroy_ba. Instead of
this pass only the stream index. This will be helpful
during watchdog event handling when bitmap of stream
indices are received.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 704d7d3..a603e64 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3788,7 +3788,7 @@ mwl8k_create_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
 }
 
 static void mwl8k_destroy_ba(struct ieee80211_hw *hw,
-			     struct mwl8k_ampdu_stream *stream)
+			     u8 idx)
 {
 	struct mwl8k_cmd_bastream *cmd;
 
@@ -3800,10 +3800,10 @@ static void mwl8k_destroy_ba(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le32(MWL8K_BA_DESTROY);
 
-	cmd->destroy_params.ba_context = cpu_to_le32(stream->idx);
+	cmd->destroy_params.ba_context = cpu_to_le32(idx);
 	mwl8k_post_cmd(hw, &cmd->header);
 
-	wiphy_debug(hw->wiphy, "Deleted BA stream index %d\n", stream->idx);
+	wiphy_debug(hw->wiphy, "Deleted BA stream index %d\n", idx);
 
 	kfree(cmd);
 }
@@ -5117,7 +5117,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int i, rc = 0;
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_ampdu_stream *stream;
-	u8 *addr = sta->addr;
+	u8 *addr = sta->addr, idx;
 	struct mwl8k_sta *sta_info = MWL8K_STA(sta);
 
 	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
@@ -5198,8 +5198,9 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_STOP:
 		if (stream) {
 			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				idx = stream->idx;
 				spin_unlock(&priv->stream_lock);
-				mwl8k_destroy_ba(hw, stream);
+				mwl8k_destroy_ba(hw, idx);
 				spin_lock(&priv->stream_lock);
 			}
 			mwl8k_remove_stream(hw, stream);
@@ -5215,8 +5216,9 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (!rc)
 			stream->state = AMPDU_STREAM_ACTIVE;
 		else {
+			idx = stream->idx;
 			spin_unlock(&priv->stream_lock);
-			mwl8k_destroy_ba(hw, stream);
+			mwl8k_destroy_ba(hw, idx);
 			spin_lock(&priv->stream_lock);
 			wiphy_debug(hw->wiphy,
 				"Failed adding stream for sta %pM tid %d\n",
-- 
1.8.0.3

