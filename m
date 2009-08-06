Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1746 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZHFIx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 04:53:28 -0400
Subject: [PATCH] cfg80211: fix disassociation warning due to misuse of
	wdev->current_bss
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 06 Aug 2009 04:52:42 -0400
Message-ID: <20090806085242.23637.82992.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARN_ON was triggered at mlme.c:213 when dissociating from an AP.

wdev->current_bss->pub.bssid should be used in place of
wdev->current_bss for BSSID comparison.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/wireless/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 525e8e2..b44b6c0 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -198,7 +198,7 @@ static void __cfg80211_send_disassoc(struct net_device *dev,
 		return;
 
 	if (wdev->current_bss &&
-	    memcmp(wdev->current_bss, bssid, ETH_ALEN) == 0) {
+	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
 		for (i = 0; i < MAX_AUTH_BSSES; i++) {
 			if (wdev->authtry_bsses[i] || wdev->auth_bsses[i])
 				continue;
