Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60082 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab3AYK7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:59:04 -0500
Date: Fri, 25 Jan 2013 16:20:42 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 6/7] mwl8k: Choose interface specific calls on vif type
Message-ID: <20130125105042.GA9494@markyou.marvell.com> (sfid-20130125_115911_836952_518E21F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Choose interface specific function calls
based on interface type instead of
firmware types.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7002fc8..5ca76c8 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4984,11 +4984,9 @@ static void
 mwl8k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct mwl8k_priv *priv = hw->priv;
-
-	if (!priv->ap_fw)
+	if (vif->type == NL80211_IFTYPE_STATION)
 		mwl8k_bss_info_changed_sta(hw, vif, info, changed);
-	else
+	if (vif->type == NL80211_IFTYPE_AP)
 		mwl8k_bss_info_changed_ap(hw, vif, info, changed);
 }
 
-- 
1.8.0.3

