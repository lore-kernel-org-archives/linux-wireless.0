Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64083 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0EZKtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 06:49:32 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH] cfg80211: Removed warning from cfg80211_send_rx_auth
Date: Wed, 26 May 2010 13:43:45 +0300
Message-Id: <1274870625-19712-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211_send_rx_auth function there was a warning if bssid of the received
authentication message was not found from the authtry_bsses table.

During the beginning of the authentication there is a small time window, when
handling of the received deauthentication message can cause information
for the access point to be removed from the authtry_bsses table before
authentication response is received. This triggers the warning. This has
been seen happening with several access points occasionally. At least
one of those (Asus) has been seen to send spurious deauthentication
messages after deauthentication. Possibly this warning could be triggered also
by forged deauthentication messages sent at a correct time.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/wireless/mlme.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 0855f0d..2565882 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -23,7 +23,6 @@ void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 	u8 *bssid = mgmt->bssid;
 	int i;
 	u16 status = le16_to_cpu(mgmt->u.auth.status_code);
-	bool done = false;
 
 	wdev_lock(wdev);
 
@@ -38,13 +37,10 @@ void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			}
 			wdev->authtry_bsses[i] = NULL;
-			done = true;
 			break;
 		}
 	}
 
-	WARN_ON(!done);
-
 	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
 	cfg80211_sme_rx_auth(dev, buf, len);
 
-- 
1.5.6.3

