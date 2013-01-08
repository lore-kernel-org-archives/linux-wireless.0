Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60226 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457Ab3AHExi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 23:53:38 -0500
Date: Tue, 8 Jan 2013 10:16:37 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Delete ampdu streams with state AMPDU_STREAM_NEW in
 sta remove
Message-ID: <20130108044633.GA13033@markyou.marvell.com> (sfid-20130108_055341_156611_EC782483)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station deauths, we do not delete the streams with state
AMPDU_STREAM_NEW and these remain created forever. Fix this issue by
removing such streams in the driver

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f5ea78c..86e0a38 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3934,7 +3934,30 @@ static int mwl8k_cmd_set_new_stn_del(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, u8 *addr)
 {
 	struct mwl8k_cmd_set_new_stn *cmd;
-	int rc;
+	struct mwl8k_priv *priv = hw->priv;
+	int rc, i;
+	u8 idx;
+
+	spin_lock(&priv->stream_lock);
+	/* Destroy any active ampdu streams for this sta */
+	for (i = 0; i < MWL8K_NUM_AMPDU_STREAMS; i++) {
+		struct mwl8k_ampdu_stream *s;
+		s = &priv->ampdu[i];
+		if (s->state != AMPDU_NO_STREAM) {
+			if (memcmp(s->sta->addr, addr, ETH_ALEN) == 0) {
+				if (s->state == AMPDU_STREAM_ACTIVE) {
+					idx = s->idx;
+					spin_unlock(&priv->stream_lock);
+					mwl8k_destroy_ba(hw, idx);
+					spin_lock(&priv->stream_lock);
+				} else if (s->state == AMPDU_STREAM_NEW) {
+					mwl8k_remove_stream(hw, s);
+				}
+			}
+		}
+	}
+
+	spin_unlock(&priv->stream_lock);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
-- 
1.8.0.3

