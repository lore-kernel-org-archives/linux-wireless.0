Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:59273 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZCZVkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:40:20 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/6] rndis_wlan: change quality level scale
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Mar 2009 23:40:16 +0200
Message-ID: <20090326214016.19238.98275.stgit@fate.lan> (sfid-20090326_224025_166444_E78CFDBE)
In-Reply-To: <20090326213953.19238.59497.stgit@fate.lan>
References: <20090326213953.19238.59497.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change quality level scale to match cfg80211 CFG80211_SIGNAL_TYPE_UNSPEC.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 464f73e..6e482ab 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1269,7 +1269,7 @@ static int rndis_iw_get_range(struct net_device *dev,
 	range->max_frag = 2346;
 
 	range->max_qual.qual = 100;
-	range->max_qual.level = 154;
+	range->max_qual.level = 100;
 	range->max_qual.updated = IW_QUAL_QUAL_UPDATED
 				| IW_QUAL_LEVEL_UPDATED
 				| IW_QUAL_NOISE_INVALID;
@@ -1712,7 +1712,7 @@ static char *rndis_translate_scan(struct net_device *dev,
 	devdbg(usbdev, "QUAL %d", le32_to_cpu(bssid->rssi));
 	iwe.cmd = IWEVQUAL;
 	iwe.u.qual.qual  = level_to_qual(le32_to_cpu(bssid->rssi));
-	iwe.u.qual.level = le32_to_cpu(bssid->rssi);
+	iwe.u.qual.level = level_to_qual(le32_to_cpu(bssid->rssi));
 	iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED
 			| IW_QUAL_LEVEL_UPDATED
 			| IW_QUAL_NOISE_INVALID;
@@ -2400,7 +2400,7 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 	if (ret == 0) {
 		memset(&iwstats.qual, 0, sizeof(iwstats.qual));
 		iwstats.qual.qual  = level_to_qual(le32_to_cpu(rssi));
-		iwstats.qual.level = le32_to_cpu(rssi);
+		iwstats.qual.level = level_to_qual(le32_to_cpu(rssi));
 		iwstats.qual.updated = IW_QUAL_QUAL_UPDATED
 				| IW_QUAL_LEVEL_UPDATED
 				| IW_QUAL_NOISE_INVALID;

