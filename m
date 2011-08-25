Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1HYQDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:03:19 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2547982wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 09:03:19 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/5] wl12xx: don't use WL1271_SCAN_OPT_PRIORITY_HIGH flag
Date: Thu, 25 Aug 2011 19:04:27 +0300
Message-Id: <1314288270-22380-2-git-send-email-eliad@wizery.com> (sfid-20110825_180322_192033_D7B4569A)
In-Reply-To: <1314288270-22380-1-git-send-email-eliad@wizery.com>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
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

