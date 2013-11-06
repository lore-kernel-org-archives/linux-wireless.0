Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57850 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3KFKGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:06:43 -0500
Date: Wed, 6 Nov 2013 12:06:30 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: Fix bcn_en_iter to use atomic iteration
Message-ID: <20131106100630.GA32033@jouni.qca.qualcomm.com> (sfid-20131106_110649_285461_2A404DA9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'mac80211_hwsim: Fix tracking of beaconing for multi-vif' introduced an
iteration of active interfaces into the bss_info_changed handler.
However, it used a wrong type of iteration and could result in a dead
lock since iflist_mtx can already be held. Fix this by using the atomic
version of the iteration function.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index de0df86..67628a7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1230,7 +1230,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 					      HRTIMER_MODE_REL);
 		} else if (!info->enable_beacon) {
 			unsigned int count = 0;
-			ieee80211_iterate_active_interfaces(
+			ieee80211_iterate_active_interfaces_atomic(
 				data->hw, IEEE80211_IFACE_ITER_NORMAL,
 				mac80211_hwsim_bcn_en_iter, &count);
 			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
