Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48786 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2APUbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 15:31:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] b43: add default option to avoid duplicating device support with brcmsmac
Date: Mon, 16 Jan 2012 15:22:12 -0500
Message-Id: <1326745332-28769-1-git-send-email-linville@tuxdriver.com> (sfid-20120116_213118_666005_1F8D107D)
In-Reply-To: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The dual default lines were the only combination I could find that
actually defaulted to "N" if brcmsmac was already enabled and to "Y"
otherwise.  If anyone knows better magic for this, then please speak-up!

 drivers/net/wireless/b43/Kconfig |    6 ++++++
 drivers/net/wireless/b43/main.c  |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index b97a40e..edb4ab2 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -31,6 +31,12 @@ config B43_BCMA
 	depends on B43 && BCMA
 	default y
 
+config B43_BCMA_EXTRA
+	bool "Hardware support that overlaps with Broadcom-supported brcmsmac driver"
+	depends on B43_BCMA
+	default n if BRCMSMAC || BRCMSMAC_MODULE
+	default	y
+
 config B43_SSB
 	bool
 	depends on B43 && SSB
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 41c83d9..b1ae675 100644
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

