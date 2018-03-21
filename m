Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60932 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeCUIJv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 04:09:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix secondary MAC address assignment
Date: Wed, 21 Mar 2018 09:09:48 +0100
Message-Id: <20180321080948.14324-1-johannes@sipsolutions.net> (sfid-20180321_090955_303429_BD24EB3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

OR'ing in 0x40 before a memcpy() to overwrite the value doesn't
do much good - flip the order of operations are reported and
tested by Jouni.

Fixes: cb1a5bae5684 ("mac80211_hwsim: add permanent mac address option for new radios")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b6c3640a94f..930ddef91093 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2584,8 +2584,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		addr[4] = idx;
 		memcpy(data->addresses[0].addr, addr, ETH_ALEN);
 		/* Why need here second address ? */
-		data->addresses[1].addr[0] |= 0x40;
 		memcpy(data->addresses[1].addr, addr, ETH_ALEN);
+		data->addresses[1].addr[0] |= 0x40;
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 		/* possible address clash is checked at hash table insertion */
-- 
2.15.1
