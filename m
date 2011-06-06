Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:32600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FFXcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 19:32:48 -0400
Message-Id: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org> (sfid-20110607_013251_207527_01583B63)
From: Paul Stewart <pstew@chromium.org>
Date: Mon, 6 Jun 2011 16:00:36 -0700
Subject: [RFC] cfg80211: Fix handling of previous_auth deauth
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WLAN_REASON_PREV_AUTH_NOT_VALID DEAUTH message is sent
to remove current successful authentications, not to to abort
a new authentication attempts.  Therefore, filter this reason
code out when deciding whether to remove authtry_bsses[] entries.

This is the least invasive change which prevents this issue
from appearing.  It doesn't address the fact that the mac80211
code still retries authentications if it is DEAUTHed for some
other reason during authentication.  If one of those retries
succeeds the client can do nothing with it sicne authtry_bsses[]
has been cleared.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/wireless/mlme.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 493b939..48e965d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -150,6 +150,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
 	const u8 *bssid = mgmt->bssid;
 	int i;
 	bool found = false, was_current = false;
+	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -170,7 +171,9 @@ void __cfg80211_send_deauth(struct net_device *dev,
 			break;
 		}
 		if (wdev->authtry_bsses[i] &&
-		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
+		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
+			   ETH_ALEN) == 0 &&
+		    reason_code != WLAN_REASON_PREV_AUTH_NOT_VALID) {
 			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			wdev->authtry_bsses[i] = NULL;
@@ -185,11 +188,8 @@ void __cfg80211_send_deauth(struct net_device *dev,
 	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (wdev->sme_state == CFG80211_SME_CONNECTED && was_current) {
-		u16 reason_code;
 		bool from_ap;
 
-		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
-
 		from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
 		__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
-- 
1.7.3.1

