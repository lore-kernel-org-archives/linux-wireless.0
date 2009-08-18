Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:53777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZHRXnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 19:43:37 -0400
Received: by ey-out-2122.google.com with SMTP id 22so859163eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 16:43:38 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: fix leaks of wdev->conn->ie
Date: Wed, 19 Aug 2009 00:43:31 +0100
Message-Id: <1250639011-18258-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This only occurs in the following error situations:
 - driver calls connect_result with failure
 - error scheduling authentication on connect
 - error initiating scan (to get BSSID and channel) on
   connect
 - userspace calls disconnect while in the SCANNING or
   SCAN_AGAIN states

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---

I came across this while looking at my orinoco scanning issue. It's
possible I'm wrong...

---

 net/wireless/sme.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6fb6a70..9ddc00e 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -395,6 +395,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 
 	if (status != WLAN_STATUS_SUCCESS) {
 		wdev->sme_state = CFG80211_SME_IDLE;
+		if (wdev->conn)
+			kfree(wdev->conn->ie);
 		kfree(wdev->conn);
 		wdev->conn = NULL;
 		kfree(wdev->connect_keys);
@@ -779,6 +781,7 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 			}
 		}
 		if (err) {
+			kfree(wdev->conn->ie);
 			kfree(wdev->conn);
 			wdev->conn = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
@@ -848,6 +851,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 		    (wdev->conn->state == CFG80211_CONN_SCANNING ||
 		     wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)) {
 			wdev->sme_state = CFG80211_SME_IDLE;
+			kfree(wdev->conn->ie);
 			kfree(wdev->conn);
 			wdev->conn = NULL;
 			wdev->ssid_len = 0;
-- 
1.6.3.3

