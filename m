Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:47692 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1AXGB7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 01:01:59 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv4] wl12xx: Increase scan channel dwell time for passive scans
Date: Mon, 24 Jan 2011 08:01:54 +0200
Message-Id: <1295848914-3765-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Below, mTU is milli-TU (TU/1000).

The passive scan channel dwell time currently used is 30-60mTU. A typical
beacon interval for AP's is 100TU. This leads to a ~30% worst-case probability
of finding an AP via passive scanning.

For 5GHz bands for DFS frequencies passive scanning is the only scanning
option. Hence for these, the probability of finding an AP is very low.

To fix this, increase the passive channel scan dwell times (also the early
leave value, as 5GHz channels are still typically very silent.) Use a value
of 100TU, because that covers most typical AP configurations.

Based on testing the probability of finding an AP (100TU beacon interval) on
a single scan round are as follows (based on 100 iterations):

dwell min/max (TU)   | probability
---------------------+------------
30/60                | 35%
60/60                | 56%
80/80                | 77%
100/100              | 100%

Total scan times now and after the change:

Region | Before (s) | After (s)
-------+------------+----------
00     | 0.77       | 1.48
FI     | 0.95       | 2.01
US     | 0.91       | 1.76

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
v4: Whoops, wrong maintainer e-mail address :o
v3: In the commit log, changed references to "ms" to "TU"
v2: Minor comment change "maximum" => "minimum"

 drivers/net/wireless/wl12xx/conf.h |   18 +++++++++---------
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index f5c048c..7aecbb5 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1084,30 +1084,30 @@ struct conf_scan_settings {
 	/*
 	 * The minimum time to wait on each channel for active scans
 	 *
-	 * Range: 0 - 65536 tu
+	 * Range: u32 tu/1000
 	 */
-	u16 min_dwell_time_active;
+	u32 min_dwell_time_active;
 
 	/*
 	 * The maximum time to wait on each channel for active scans
 	 *
-	 * Range: 0 - 65536 tu
+	 * Range: u32 tu/1000
 	 */
-	u16 max_dwell_time_active;
+	u32 max_dwell_time_active;
 
 	/*
-	 * The maximum time to wait on each channel for passive scans
+	 * The minimum time to wait on each channel for passive scans
 	 *
-	 * Range: 0 - 65536 tu
+	 * Range: u32 tu/1000
 	 */
-	u16 min_dwell_time_passive;
+	u32 min_dwell_time_passive;
 
 	/*
 	 * The maximum time to wait on each channel for passive scans
 	 *
-	 * Range: 0 - 65536 tu
+	 * Range: u32 tu/1000
 	 */
-	u16 max_dwell_time_passive;
+	u32 max_dwell_time_passive;
 
 	/*
 	 * Number of probe requests to transmit on each active scan channel
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 863e660..c1814f2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -279,8 +279,8 @@ static struct conf_drv_settings default_conf = {
 	.scan = {
 		.min_dwell_time_active        = 7500,
 		.max_dwell_time_active        = 30000,
-		.min_dwell_time_passive       = 30000,
-		.max_dwell_time_passive       = 60000,
+		.min_dwell_time_passive       = 100000,
+		.max_dwell_time_passive       = 100000,
 		.num_probe_reqs               = 2,
 	},
 	.rf = {
-- 
1.7.1

