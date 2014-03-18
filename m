Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaCRUKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 16:10:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix potential use-after-free
Date: Tue, 18 Mar 2014 21:09:39 +0100
Message-Id: <1395173379-18400-1-git-send-email-johannes@sipsolutions.net> (sfid-20140318_211022_018221_E2BF26F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The bss struct might be freed in ieee80211_rx_bss_put(),
so we shouldn't use it afterwards.

Cc: stable@vger.kernel.org (3.10+)
Fixes: 817cee7675237 ("mac80211: track AP's beacon rate and give it to the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb3677c..423816f18b55 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2780,8 +2780,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
 	if (bss) {
-		ieee80211_rx_bss_put(local, bss);
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
+		ieee80211_rx_bss_put(local, bss);
 	}
 }
 
-- 
1.8.5.3

