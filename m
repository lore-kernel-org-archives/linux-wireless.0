Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBGJpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 04:45:47 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix number of channels in interface combinations
Date: Fri,  7 Feb 2014 10:45:41 +0100
Message-Id: <1391766341-10566-1-git-send-email-johannes@sipsolutions.net> (sfid-20140207_104602_420270_5A4B8688)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's little point in setting the number of channels if the
entire combination struct is overwritten again later - that
was clearly intended the other way around, fix it.

Reported-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f7e3562..771b8c5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2004,11 +2004,11 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		/* For channels > 1 DFS is not allowed */
 		hw->wiphy->n_iface_combinations = 1;
 		hw->wiphy->iface_combinations = &data->if_combination;
-		data->if_combination.num_different_channels = data->channels;
 		if (p2p_device)
 			data->if_combination = hwsim_if_comb_p2p_dev[0];
 		else
 			data->if_combination = hwsim_if_comb[0];
+		data->if_combination.num_different_channels = data->channels;
 	} else if (p2p_device) {
 		hw->wiphy->iface_combinations = hwsim_if_comb_p2p_dev;
 		hw->wiphy->n_iface_combinations =
-- 
1.8.5.3

