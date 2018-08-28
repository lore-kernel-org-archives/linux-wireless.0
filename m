Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Subject: [RFC 3/6] cfg80211: protect against NULL dereference [SQUASH]
Date: Tue, 28 Aug 2018 14:13:50 +0200
Message-Id: <20180828121353.11193-4-johannes@sipsolutions.net> (sfid-20180828_141952_379543_7BCF15AF)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 75e1fc79a890..c08b39a622b7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1643,7 +1643,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, NULL, gfp);
-	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+	if (!res || !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
 
 	/* process each non-transmitting bss */
-- 
2.14.4
