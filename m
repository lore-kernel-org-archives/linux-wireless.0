Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0EQGbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:31:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:31:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.58041.788800.187965@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:01:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] ath9k_htc: Enable RX STBC for AR9271
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8b202e0..ff6c080 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -407,6 +407,8 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 
+	ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
-- 
1.7.1

