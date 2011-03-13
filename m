Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60053 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1CMJU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2011 05:20:59 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p2D9KxXn010813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 13 Mar 2011 04:20:59 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Add support for 11n Rx STBC one spatial stream
Date: Sun, 13 Mar 2011 11:24:40 +0200
Message-Id: <1300008280-6904-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx support Rx STBC one spatial stream

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8b3c8d1..57f63ca 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3003,7 +3003,8 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
 
 #ifdef CONFIG_WL12XX_HT
 #define WL12XX_HT_CAP { \
-	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20, \
+	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | \
+	       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT), \
 	.ht_supported = true, \
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K, \
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, \
-- 
1.7.0.4

