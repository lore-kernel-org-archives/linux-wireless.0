Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0A2Xjo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 18:39:44 -0500
From: <shanyu.zhao@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Shanyu Zhao <shanyu.zhao@intel.com>
Subject: [PATCH 1/1] cfg80211: wext: set bssid to NULL in SIOCIWESSID
Date: Fri, 29 Jan 2010 15:39:36 -0800
Message-Id: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Need to set bssid to NULL in cfg80211's SIOCIWESSID function, otherwise
after "iwconfig wlanx ap <mac>", the "iwconfig wlanx essid" won't work.

Cc: stable@kernel.org

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
---
 net/wireless/wext-sme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index eede356..5a67dd5 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -194,6 +194,7 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 	wdev->wext.connect.ssid = wdev->wext.ssid;
 	memcpy(wdev->wext.ssid, ssid, len);
 	wdev->wext.connect.ssid_len = len;
+	wdev->wext.connect.bssid = NULL;
 
 	wdev->wext.connect.crypto.control_port = false;
 
-- 
1.6.0.4

