Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:33789 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab1IBL2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 07:28:43 -0400
Received: by mail-bw0-f44.google.com with SMTP id r4so3832176bka.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2011 04:28:42 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] wl12xx: increase number of allowed SSIDs in sched_scan
Date: Fri,  2 Sep 2011 14:28:22 +0300
Message-Id: <1314962903-29574-3-git-send-email-coelho@ti.com> (sfid-20110902_132848_737457_EC5B0612)
In-Reply-To: <1314962903-29574-1-git-send-email-coelho@ti.com>
References: <1314962903-29574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest firmware supports up to 16 SSIDs in the scheduled scan
lists.  Increase the number we report to cfg80211 and increase the
min/max dwell time to 30 and 60 TUs respectively, because otherwise we
don't have the time to send the probes for all SSIDs.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..49da03d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -267,8 +267,8 @@ static struct conf_drv_settings default_conf = {
 	},
 	.sched_scan = {
 		/* sched_scan requires dwell times in TU instead of TU/1000 */
-		.min_dwell_time_active = 8,
-		.max_dwell_time_active = 30,
+		.min_dwell_time_active = 30,
+		.max_dwell_time_active = 60,
 		.dwell_time_passive    = 100,
 		.dwell_time_dfs        = 150,
 		.num_probe_reqs        = 2,
@@ -4491,7 +4491,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	wl->hw->wiphy->max_scan_ssids = 1;
-	wl->hw->wiphy->max_sched_scan_ssids = 8;
+	wl->hw->wiphy->max_sched_scan_ssids = 16;
+	wl->hw->wiphy->max_match_sets = 16;
 	/*
 	 * Maximum length of elements in scanning probe request templates
 	 * should be the maximum length possible for a template, without
-- 
1.7.1

