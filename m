Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZGTDq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/5] cfg80211: fix typo of IWEVASSOCRESPIE
Date: Mon, 20 Jul 2009 11:47:44 +0800
Message-Id: <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It should be IWEVASSOCREQIE instead.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/sme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index e7a8851..82de2d9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -341,7 +341,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		if (req_ie && status == WLAN_STATUS_SUCCESS) {
 			memset(&wrqu, 0, sizeof(wrqu));
 			wrqu.data.length = req_ie_len;
-			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
+			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu, req_ie);
 		}
 
 		if (resp_ie && status == WLAN_STATUS_SUCCESS) {
@@ -474,7 +474,7 @@ void __cfg80211_roamed(struct wireless_dev *wdev, const u8 *bssid,
 	if (req_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = req_ie_len;
-		wireless_send_event(wdev->netdev, IWEVASSOCRESPIE,
+		wireless_send_event(wdev->netdev, IWEVASSOCREQIE,
 				    &wrqu, req_ie);
 	}
 
-- 
1.6.0.4

