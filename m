Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53615 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:06:45 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH-WN 1/3] wireless: Make sure __cfg80211_connect_result always puts bss.
Date: Wed, 19 Jun 2013 14:06:25 -0700
Message-Id: <1371675987-28732-1-git-send-email-greearb@candelatech.com> (sfid-20130619_230648_480145_A5400A87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, we can leak a bss reference.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against wireless-next.

 net/wireless/sme.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c0bf781..32dac8c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -557,6 +557,7 @@ static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
  * SME event handling
  */
 
+/* This method must consume bss one way or another */
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
@@ -572,8 +573,10 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)) {
+		cfg80211_put_bss(wdev->wiphy, bss);
 		return;
+	}
 
 	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
-- 
1.7.3.4

