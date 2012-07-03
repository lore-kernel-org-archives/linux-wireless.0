Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2GCLvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:51:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix NUM_BANDS usage
Date: Tue,  3 Jul 2012 13:51:47 +0200
Message-Id: <1341316307-17796-1-git-send-email-johannes@sipsolutions.net> (sfid-20120703_135156_408865_3895FE48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to the recent change of NUM_BANDS from 2 to 3 hwsim
broke. Fix the code by using the right constant but don't
support bands other than 2.4 and 5 GHz.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 5bddf53..c68728c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -292,7 +292,7 @@ struct mac80211_hwsim_data {
 	struct list_head list;
 	struct ieee80211_hw *hw;
 	struct device *dev;
-	struct ieee80211_supported_band bands[2];
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
@@ -1855,7 +1855,7 @@ static int __init init_mac80211_hwsim(void)
 				sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
 				break;
 			default:
-				break;
+				continue;
 			}
 
 			sband->ht_cap.ht_supported = true;
-- 
1.7.10

