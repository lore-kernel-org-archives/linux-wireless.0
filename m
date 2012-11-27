Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2K0GpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:21 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:21 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/20] wl18xx: declare support for greenfield ht_cap
Date: Tue, 27 Nov 2012 08:44:49 +0200
Message-Id: <1353998701-18171-9-git-send-email-arik@wizery.com> (sfid-20121127_074529_595634_22B8051C)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The 18xx fw supports greenfield so add the
IEEE80211_HT_CAP_GRN_FLD flag to the supported
ht capabilities flags.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 635f8b7..4f3c142 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1424,7 +1424,8 @@ static struct wlcore_ops wl18xx_ops = {
 /* HT cap appropriate for wide channels in 2Ghz */
 static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_2ghz = {
 	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
-	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_DSSSCCK40,
+	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_DSSSCCK40 |
+	       IEEE80211_HT_CAP_GRN_FLD,
 	.ht_supported = true,
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
@@ -1438,7 +1439,8 @@ static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_2ghz = {
 /* HT cap appropriate for wide channels in 5Ghz */
 static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_5ghz = {
 	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
-	       IEEE80211_HT_CAP_SUP_WIDTH_20_40,
+	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+	       IEEE80211_HT_CAP_GRN_FLD,
 	.ht_supported = true,
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
@@ -1451,7 +1453,8 @@ static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_5ghz = {
 
 /* HT cap appropriate for SISO 20 */
 static struct ieee80211_sta_ht_cap wl18xx_siso20_ht_cap = {
-	.cap = IEEE80211_HT_CAP_SGI_20,
+	.cap = IEEE80211_HT_CAP_SGI_20 |
+	       IEEE80211_HT_CAP_GRN_FLD,
 	.ht_supported = true,
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
@@ -1464,7 +1467,8 @@ static struct ieee80211_sta_ht_cap wl18xx_siso20_ht_cap = {
 
 /* HT cap appropriate for MIMO rates in 20mhz channel */
 static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_2ghz = {
-	.cap = IEEE80211_HT_CAP_SGI_20,
+	.cap = IEEE80211_HT_CAP_SGI_20 |
+	       IEEE80211_HT_CAP_GRN_FLD,
 	.ht_supported = true,
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
-- 
1.7.9.5

