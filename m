Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34054 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbaD3M6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 08:58:24 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so846313wiw.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 05:58:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: free sme on connection failures
Date: Wed, 30 Apr 2014 15:58:13 +0300
Message-Id: <1398862693-19264-1-git-send-email-eliad@wizery.com> (sfid-20140430_145842_109351_1022E417)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 is notified about connection failures by
__cfg80211_connect_result() call. However, this
function currently does not free cfg80211 sme.

This results in hanging connection attempts in some cases

e.g. when mac80211 authentication attempt is denied,
we have this function call:
ieee80211_rx_mgmt_auth() -> cfg80211_rx_mlme_mgmt() ->
cfg80211_process_auth() -> cfg80211_sme_rx_auth() ->
__cfg80211_connect_result()

but cfg80211_sme_free() is never get called.

Fixes: ceca7b712 ("cfg80211: separate internal SME implementation")
Cc: stable@vger.kernel.org (3.10+)
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4bc21a2..1f05cfc 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -236,7 +236,6 @@ void cfg80211_conn_work(struct work_struct *work)
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					false, NULL);
-			cfg80211_sme_free(wdev);
 		}
 		wdev_unlock(wdev);
 	}
@@ -649,6 +648,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wdev->wiphy, bss);
 		}
+		cfg80211_sme_free(wdev);
 		return;
 	}
 
-- 
1.8.5.2.229.g4448466.dirty

