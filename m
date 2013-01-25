Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:48700 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab3AYK4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:53 -0500
Date: Fri, 25 Jan 2013 16:20:12 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 3/7] mwl8k: set mac type to MWL8K_MAC_TYPE_SECONDARY_CLIENT
Message-ID: <20130125105012.GA9432@markyou.marvell.com> (sfid-20130125_115713_693734_2C061247)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set mac type for station interface on AP firmware
as secondary. This allows the firmware to set specific
characteristics for the STA interface.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 59df345..3515337 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3538,7 +3538,10 @@ static int mwl8k_cmd_update_mac_addr(struct ieee80211_hw *hw,
 	mac_type = MWL8K_MAC_TYPE_PRIMARY_AP;
 	if (vif != NULL && vif->type == NL80211_IFTYPE_STATION) {
 		if (mwl8k_vif->macid + 1 == ffs(priv->sta_macids_supported))
-			mac_type = MWL8K_MAC_TYPE_PRIMARY_CLIENT;
+			if (priv->ap_fw)
+				mac_type = MWL8K_MAC_TYPE_SECONDARY_CLIENT;
+			else
+				mac_type = MWL8K_MAC_TYPE_PRIMARY_CLIENT;
 		else
 			mac_type = MWL8K_MAC_TYPE_SECONDARY_CLIENT;
 	} else if (vif != NULL && vif->type == NL80211_IFTYPE_AP) {
-- 
1.8.0.3

