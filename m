Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:60973 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751823Ab1HWIme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:42:34 -0400
Received: by mail-bw0-f49.google.com with SMTP id 17so6861133bke.22
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 01:42:33 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.1] wl12xx: add max_sched_scan_ssids value to the hw description
Date: Tue, 23 Aug 2011 11:42:25 +0300
Message-Id: <1314088945-19848-1-git-send-email-coelho@ti.com> (sfid-20110823_104237_748216_D5C091FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit 5a865ba, we require a separate value to indicate the
number of supported SSIDs in scheduled scans.  This patch adds a
proper value to the wl12xx driver.

This fixes a regression in 3.1-rc3 where scheduled scans were not
working properly with the wl12xx driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e58c22d..b70ae40 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4283,6 +4283,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	wl->hw->wiphy->max_scan_ssids = 1;
+	wl->hw->wiphy->max_sched_scan_ssids = 1;
 	/*
 	 * Maximum length of elements in scanning probe request templates
 	 * should be the maximum length possible for a template, without
-- 
1.7.1

