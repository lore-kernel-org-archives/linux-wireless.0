Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2EJJRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:08 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:07 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 71/78] wl18xx: add power limit reference value to mac_and_phy settings
Date: Thu, 10 May 2012 12:14:16 +0300
Message-Id: <1336641263-5761-72-git-send-email-arik@wizery.com> (sfid-20120510_111742_573346_261EBA4F)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

With more recent PHY firmware versions (>8.1.0.0.116), we need to use
the correct value for the pwr_limit_reference_11_abg parameter when
setting the mac_and_phy options.

For now we use a hardcoded 0xc8 as the value.  This will be moved to
the configuration binary when it gets implemented.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |    1 +
 drivers/net/wireless/ti/wl18xx/main.c |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index a6058fb..ffad302 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -43,6 +43,7 @@ struct wl18xx_conf_phy {
 	u8 primary_clock_setting_time;
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
+	u8 pwr_limit_reference_11_abg;
 };
 
 struct wl18xx_priv_conf {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0795598..ab3dd11 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -501,6 +501,7 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.enable_clpc			= 0x00,
 		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
 		.rx_profile			= 0x00,
+		.pwr_limit_reference_11_abg	= 0xc8,
 	},
 };
 
@@ -726,6 +727,8 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 		phy->clock_valid_on_wake_up;
 	params.secondary_clock_setting_time =
 		phy->secondary_clock_setting_time;
+	params.pwr_limit_reference_11_abg =
+		phy->pwr_limit_reference_11_abg;
 
 	params.board_type = priv->board_type;
 
-- 
1.7.9.5

