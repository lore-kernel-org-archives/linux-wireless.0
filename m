Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1DSN7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:17 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:58:51 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 03/22] ath9k_hw: Get AHB clock information from ath9k_platform_data
Date: Tue, 19 Apr 2011 19:29:01 +0530
Message-ID: <1303221560-25139-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a bool in ath9k_platform_data to pass AHB clock speed information.
Driver needs this to configure PLL on some SOCs.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h   |    2 ++
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 include/linux/ath9k_platform.h        |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8da6619..8e3618a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -845,6 +845,8 @@ struct ath_hw {
 
 	/* Enterprise mode cap */
 	u32 ent_mode;
+
+	bool is_clk_25mhz;
 };
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1ac8318..e78b6ae 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -574,6 +574,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		sc->sc_ah->gpio_mask = pdata->gpio_mask;
 		sc->sc_ah->gpio_val = pdata->gpio_val;
 		sc->sc_ah->led_pin = pdata->led_pin;
+		ah->is_clk_25mhz = pdata->is_clk_25mhz;
 	}
 
 	common = ath9k_hw_common(ah);
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 020387a..60a7c49 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -28,6 +28,8 @@ struct ath9k_platform_data {
 	int led_pin;
 	u32 gpio_mask;
 	u32 gpio_val;
+
+	bool is_clk_25mhz;
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.7.0.4

