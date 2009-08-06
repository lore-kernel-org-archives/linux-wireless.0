Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbZHFSqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:46:23 -0400
Message-Id: <20090806184234.313983716@sipsolutions.net>
References: <20090806184131.114246687@sipsolutions.net>
Date: Thu, 06 Aug 2009 20:41:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/3] cfg80211: fix nl80211 disconnected events
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When reporting a disconnection to userspace, we try
to report whether it was from the AP or by our own
choice. However, we misreported a broadcast deauth
or disassoc as being by own choice, which is wrong.
Fix this by checking the sender address instead of
the destination address.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-08-06 20:36:05.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-08-06 20:40:09.000000000 +0200
@@ -149,7 +149,7 @@ static void __cfg80211_send_deauth(struc
 
 		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
+		from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
 		__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
 		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
@@ -215,7 +215,7 @@ static void __cfg80211_send_disassoc(str
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
+	from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
 	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 }
 

-- 

