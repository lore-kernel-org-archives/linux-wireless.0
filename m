Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55957 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0DRNgs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:36:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: Remove use of sdio quirks attribute
Date: Sun, 18 Apr 2010 15:36:23 +0200
Message-Id: <1271597784-4811-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
References: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/26-sdio-quirks.patch |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 patches/26-sdio-quirks.patch

diff --git a/patches/26-sdio-quirks.patch b/patches/26-sdio-quirks.patch
new file mode 100644
index 0000000..0b43be5
--- /dev/null
+++ b/patches/26-sdio-quirks.patch
@@ -0,0 +1,20 @@
+The quirks attribute is not available on older kernels.
+
+--- a/drivers/net/wireless/libertas/if_sdio.c
++++ b/drivers/net/wireless/libertas/if_sdio.c
+@@ -1026,6 +1026,7 @@ static int if_sdio_probe(struct sdio_fun
+ 	if (ret)
+ 		goto disable;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+ 	/* For 1-bit transfers to the 8686 model, we need to enable the
+ 	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
+ 	 * bit to allow access to non-vendor registers. */
+@@ -1044,6 +1045,7 @@ static int if_sdio_probe(struct sdio_fun
+ 		if (ret)
+ 			goto release_int;
+ 	}
++#endif
+ 
+ 	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
+ 	if (ret)
-- 
1.6.3.3

