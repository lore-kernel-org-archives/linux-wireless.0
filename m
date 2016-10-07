Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod3.natinst.com ([130.164.80.24]:39390 "EHLO ni.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757046AbcJGPqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 11:46:22 -0400
From: Xander Huff <xander.huff@ni.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        James Minor <james.minor@ni.com>, linux-kernel@vger.kernel.org,
        xander.huff@ni.com
Subject: [PATCH] wlcore: Allow scans when in AP mode
Date: Fri, 7 Oct 2016 10:45:57 -0500
Message-Id: <1475855157-21271-1-git-send-email-xander.huff@ni.com> (sfid-20161007_174647_296306_48F1F691)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: James Minor <james.minor@ni.com>

When in AP mode, scans can be done without changing firmware to
the multi-role firmware. Allow the interface to scan if forced
in the scan request.

Signed-off-by: James Minor <james.minor@ni.com>
Signed-off-by: Xander Huff <xander.huff@ni.com>
Reviewed-by: Ben Shelton <ben.shelton@ni.com>
Reviewed-by: Jaeden Amero <jaeden.amero@ni.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 471521a..01ca370 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6120,6 +6120,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 				WIPHY_FLAG_SUPPORTS_SCHED_SCAN |
 				WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
+	wl->hw->wiphy->features |= NL80211_FEATURE_AP_SCAN;
+
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
 		     ARRAY_SIZE(wl1271_channels_5ghz) >
-- 
1.9.1
