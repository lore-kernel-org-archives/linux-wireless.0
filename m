Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2AKVBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 16:01:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: add default option to avoid duplicating device support with brcmsmac
Date: Wed, 11 Jan 2012 15:53:00 -0500
Message-Id: <1326315180-29398-1-git-send-email-linville@tuxdriver.com> (sfid-20120111_220112_206553_13E934A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/Kconfig |    5 +++++
 drivers/net/wireless/b43/main.c  |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index b97a40e..8139fc7 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -31,6 +31,11 @@ config B43_BCMA
 	depends on B43 && BCMA
 	default y
 
+config B43_BCMA_EXTRA
+	bool "Support for devices also supported by brcmsmac"
+	depends on B43_BCMA
+	default n
+
 config B43_SSB
 	bool
 	depends on B43 && SSB
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 989f654..e2e2d11 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -116,8 +116,10 @@ MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 #ifdef CONFIG_B43_BCMA
 static const struct bcma_device_id b43_bcma_tbl[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x11, BCMA_ANY_CLASS),
+#ifdef CONFIG_B43_BCMA_EXTRA
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
+#endif
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1D, BCMA_ANY_CLASS),
 	BCMA_CORETABLE_END
 };
-- 
1.7.4.4

