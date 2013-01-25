Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41874 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756862Ab3AYK6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:58:42 -0500
Date: Fri, 25 Jan 2013 16:20:28 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 4/7] mwl8k: Enable hw encryption for STA mode on AP fw
Message-ID: <20130125105028.GA9451@markyou.marvell.com> (sfid-20130125_115857_643603_83EC6755)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware supports hardware encryption feature
for the station interface running on AP
firmware.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3515337..a83f3ca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4265,8 +4265,9 @@ static int mwl8k_set_key(struct ieee80211_hw *hw,
 	u8 encr_type;
 	u8 *addr;
 	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+	struct mwl8k_priv *priv = hw->priv;
 
-	if (vif->type == NL80211_IFTYPE_STATION)
+	if (vif->type == NL80211_IFTYPE_STATION && !priv->ap_fw)
 		return -EOPNOTSUPP;
 
 	if (sta == NULL)
-- 
1.8.0.3

