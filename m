Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:41262 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab3GWCTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Stone Piao <piaoyun@marvell.com>
Subject: [PATCH 07/21] mwifiex: skip registering mgmt frame that has already registered
Date: Mon, 22 Jul 2013 19:17:44 -0700
Message-ID: <1374545878-15683-8-git-send-email-bzhao@marvell.com> (sfid-20130723_041910_848952_4385A695)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Before sending command to firmware, we need to check the frame type.
We skip registering the mgmt frame that has already been registered.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d824fee..dbdd3b2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -240,16 +240,20 @@ mwifiex_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 				     u16 frame_type, bool reg)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	u32 mask;
 
 	if (reg)
-		priv->mgmt_frame_mask |= BIT(frame_type >> 4);
+		mask = priv->mgmt_frame_mask | BIT(frame_type >> 4);
 	else
-		priv->mgmt_frame_mask &= ~BIT(frame_type >> 4);
+		mask = priv->mgmt_frame_mask & ~BIT(frame_type >> 4);
 
-	mwifiex_send_cmd_async(priv, HostCmd_CMD_MGMT_FRAME_REG,
-			       HostCmd_ACT_GEN_SET, 0, &priv->mgmt_frame_mask);
-
-	wiphy_dbg(wiphy, "info: mgmt frame registered\n");
+	if (mask != priv->mgmt_frame_mask) {
+		priv->mgmt_frame_mask = mask;
+		mwifiex_send_cmd_async(priv, HostCmd_CMD_MGMT_FRAME_REG,
+				       HostCmd_ACT_GEN_SET, 0,
+				       &priv->mgmt_frame_mask);
+		wiphy_dbg(wiphy, "info: mgmt frame registered\n");
+	}
 }
 
 /*
-- 
1.8.2.3

