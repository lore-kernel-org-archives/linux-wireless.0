Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43613 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3FRWEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:04:34 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/6] wireless:  Make sure __cfg80211_connect_result always puts bss.
Date: Tue, 18 Jun 2013 15:03:34 -0700
Message-Id: <1371593017-10985-3-git-send-email-greearb@candelatech.com> (sfid-20130619_000436_473916_2DB180AE)
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, we can leak a bss reference.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/sme.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6066720..ea2ce33 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -420,6 +420,7 @@ void cfg80211_sme_failed_assoc(struct wireless_dev *wdev)
 	schedule_work(&rdev->conn_work);
 }
 
+/** This method must consume bss one way or another */
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
@@ -435,11 +436,17 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)) {
+		if (bss)
+			cfg80211_put_bss(wdev->wiphy, bss);
 		return;
+	}
 
-	if (wdev->sme_state != CFG80211_SME_CONNECTING)
+	if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+		if (bss)
+			cfg80211_put_bss(wdev->wiphy, bss);
 		return;
+	}
 
 	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
-- 
1.7.3.4

