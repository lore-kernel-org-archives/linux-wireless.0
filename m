Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495AbZHEHFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 03:05:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH V2] wireless: display wext SSID when connected by cfg80211
Date: Wed,  5 Aug 2009 15:07:13 +0800
Message-Id: <1249456033-8089-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 displays correct link info when connected by wext. But if
the connection is setup by cfg80211, wext cannot display the SSID.
This patch fixed this issue.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: use wdev->current_bss instead of wdev->ssid

 net/wireless/wext-sme.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 7bacbd1..e4a054a 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -206,7 +206,15 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 	data->flags = 0;
 
 	wdev_lock(wdev);
-	if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
+	if (wdev->current_bss) {
+		const u8 *ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
+						    WLAN_EID_SSID);
+		if (ie) {
+			data->flags = 1;
+			data->length = ie[1];
+			memcpy(ssid, ie + 2, data->length);
+		}
+	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
 		data->flags = 1;
 		data->length = wdev->wext.connect.ssid_len;
 		memcpy(ssid, wdev->wext.connect.ssid, data->length);
-- 
1.6.0.4

