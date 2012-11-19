Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51450 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab2KSW6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:58:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/8] ssb: add ssb_chipco_gpio_pull{up,down}
Date: Mon, 19 Nov 2012 23:57:54 +0100
Message-Id: <1353365877-11131-6-git-send-email-hauke@hauke-m.de> (sfid-20121119_235854_018583_28F0DD20)
In-Reply-To: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add functions to access the GPIO registers for pullup and pulldown.
These are needed for handling gpio registration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon.c           |   16 ++++++++++++++++
 include/linux/ssb/ssb_driver_chipcommon.h |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index e9d2ca1..4df4926 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -442,6 +442,22 @@ u32 ssb_chipco_gpio_polarity(struct ssb_chipcommon *cc, u32 mask, u32 value)
 	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPOL, mask, value);
 }
 
+u32 ssb_chipco_gpio_pullup(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	if (cc->dev->id.revision < 20)
+		return 0xffffffff;
+
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLUP, mask, value);
+}
+
+u32 ssb_chipco_gpio_pulldown(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	if (cc->dev->id.revision < 20)
+		return 0xffffffff;
+
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLDOWN, mask, value);
+}
+
 #ifdef CONFIG_SSB_SERIAL
 int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 			   struct ssb_serial_port *ports)
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index c2b02a5..c8d07c9 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -644,6 +644,8 @@ u32 ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value);
 u32 ssb_chipco_gpio_control(struct ssb_chipcommon *cc, u32 mask, u32 value);
 u32 ssb_chipco_gpio_intmask(struct ssb_chipcommon *cc, u32 mask, u32 value);
 u32 ssb_chipco_gpio_polarity(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_pullup(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_pulldown(struct ssb_chipcommon *cc, u32 mask, u32 value);
 
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
-- 
1.7.10.4

