Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1H1MKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 08:10:33 -0400
Received: by wwf5 with SMTP id 5so4873496wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 05:10:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/5] wl12xx: don't use WL1271_SCAN_OPT_PRIORITY_HIGH flag
Date: Sun, 28 Aug 2011 15:11:54 +0300
Message-Id: <1314533517-24639-2-git-send-email-eliad@wizery.com> (sfid-20110828_141043_802669_166D2F34)
In-Reply-To: <1314533517-24639-1-git-send-email-eliad@wizery.com>
References: <1314533517-24639-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting the WL1271_SCAN_OPT_PRIORITY_HIGH flag, the
driver requests a scan *now*, and the fw doesn't enter psm
before scanning, which in turn might cause packets loss.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index af4ad23..b2e2abd 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -164,9 +164,6 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 		goto out;
 	}
 
-	/* We always use high priority scans */
-	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
-
 	/* No SSIDs means that we have a forced passive scan */
 	if (passive || wl->scan.req->n_ssids == 0)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
-- 
1.7.6.401.g6a319

