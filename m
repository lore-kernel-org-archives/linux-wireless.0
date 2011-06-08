Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:26677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1FHNOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:14:38 -0400
From: Paul Stewart <pstew@chromium.org>
Date: Wed, 8 Jun 2011 05:52:52 -0700
In-Reply-To: <1307533801.3961.14.camel@jlt3.sipsolutions.net>
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	<1307530922.3961.4.camel@jlt3.sipsolutions.net>
	<BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com>
	<1307533479.3961.13.camel@jlt3.sipsolutions.net>
	<BANLkTikc-6hwZwT4Qt-dB-qBkwxEWLwrkg@mail.gmail.com>
	<1307533801.3961.14.camel@jlt3.sipsolutions.net>
Subject: [PATCH] cfg80211: Ignore downstream DEAUTH for authtry_bsses
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Message-Id: <20110608131433.DC6B62034B@glenhelen.mtv.corp.google.com> (sfid-20110608_151446_767217_00F2EFD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Downsteram DEAUTH messages do not refer to a current authentication
attempt -- AUTH responses do.  Therefore we should not allow DEAUTH
from an AP to void state for an AUTH attempt in progress.

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

