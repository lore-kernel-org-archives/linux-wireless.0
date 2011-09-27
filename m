Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50333 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab1I0NWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 09:22:50 -0400
Received: by mail-bw0-f54.google.com with SMTP id zs8so8423255bkb.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 06:22:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: set max_sched_scan_ie_len correctly
Date: Tue, 27 Sep 2011 16:22:35 +0300
Message-Id: <1317129755-14825-1-git-send-email-coelho@ti.com> (sfid-20110927_152253_694293_997DCA21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wiphy max_sched_scan_ie_len attribute was not set correctly and
remained as 0, so when IEs were being passed in a scheduled scan, we
were returning -EINVAL.

Fix this by setting the attribute properly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a51dd0e..723d657 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4677,6 +4677,9 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
 			sizeof(struct ieee80211_header);
 
+	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
+		sizeof(struct ieee80211_header);
+
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
 	/* make sure all our channels fit in the scanned_ch bitmask */
-- 
1.7.1

