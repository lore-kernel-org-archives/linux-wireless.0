Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35573 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcFWO5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:39 -0400
Received: by mail-wm0-f68.google.com with SMTP id a66so11659159wme.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:38 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/6] ath9k: Allow configuration of LED polarity in platform data.
Date: Thu, 23 Jun 2016 16:57:09 +0200
Message-Id: <20160623145714.20576-2-martin.blumenstingl@googlemail.com> (sfid-20160623_165742_655756_32BF11CA)
In-Reply-To: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices running OpenWrt need this and it makes sense to add this
to ath9k_platform_data as the next patches will add a devicetree
(boolean) property for it as well.

Suggested-by: Vittorio Gambaletta <openwrt@vittgam.net>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 +++
 include/linux/ath9k_platform.h        | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2ee8624..384929d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -527,6 +527,9 @@ static int ath9k_init_soc_platform(struct ath_softc *sc)
 			return ret;
 	}
 
+	if (pdata->led_active_high)
+		ah->config.led_active_high = true;
+
 	if (pdata->tx_gain_buffalo)
 		ah->config.tx_gain_buffalo = true;
 
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index e66153d..76860a4 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -40,6 +40,7 @@ struct ath9k_platform_data {
 	bool tx_gain_buffalo;
 	bool disable_2ghz;
 	bool disable_5ghz;
+	bool led_active_high;
 
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
-- 
2.9.0

