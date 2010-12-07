Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55012 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0LGWGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 17:06:45 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless: Remove spurious warning in mlme.c
Date: Tue,  7 Dec 2010 14:06:39 -0800
Message-Id: <1291759599-14698-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Seems that we should not be warning if all of the
authtry_bsses are already NULL.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 d7680f2... 866d016... M	net/wireless/mlme.c
 net/wireless/mlme.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d7680f2..866d016 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(cfg80211_send_disassoc);
 static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
 {
 	int i;
-	bool done = false;
+	bool done = true;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -277,9 +277,10 @@ static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
 			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			wdev->authtry_bsses[i] = NULL;
-			done = true;
 			break;
 		}
+		else if (wdev->authtry_bsses[i])
+			done = false;
 	}
 
 	WARN_ON(!done);
-- 
1.7.2.3

