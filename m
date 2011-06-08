Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:45522 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1FITNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 15:13:32 -0400
From: Paul Stewart <pstew@chromium.org>
Date: Wed, 8 Jun 2011 05:52:52 -0700
Subject: [PATCH] cfg80211: Ignore downstream DEAUTH for authtry_bsses
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Message-Id: <20110609191327.20D2C2038D@glenhelen.mtv.corp.google.com> (sfid-20110609_211335_288396_A4068011)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we receive a DEAUTH message from an AP while performing
an AUTH request, this does not constitute a reply to our AUTH
request.  In some cases an incoming DEAUTH may be due to the AP
clearing out old state from a previous authentication.
Instead we should ignore it and continue waiting for an AUTH
response.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/wireless/mlme.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 493b939..3633ab6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -170,7 +170,9 @@ void __cfg80211_send_deauth(struct net_device *dev,
 			break;
 		}
 		if (wdev->authtry_bsses[i] &&
-		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
+		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
+			   ETH_ALEN) == 0 &&
+		    memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) == 0) {
 			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			wdev->authtry_bsses[i] = NULL;
-- 
1.7.3.1

