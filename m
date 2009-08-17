Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v5 23/33] wireless: downgrade TI driver from menuconfig to config
Date: Mon, 17 Aug 2009 13:27:22 -0400
Message-Id: <1250530052-14783-24-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few options here so let this expand upon
selection. To give it the same effect of a menuconfig
though we ifdef the options based on the base config
menu selection. Because of this new check we can simplify
the kconfig entries to not depend on WL12XX anymore as that
is now implied.

Cc: Kalle Valo <kalle.valo@nokia.com>
Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/wl12xx/Kconfig |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 1818e45..ef250e9 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,13 +1,15 @@
-menuconfig WL12XX
+config WL12XX
 	boolean "TI wl12xx driver support"
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make
 	  use of the mac80211 stack.
 
+if WL12XX
+
 config WL1251
 	tristate "TI wl1251 support"
-	depends on WL12XX && GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
@@ -41,7 +43,7 @@ config WL1251_SDIO
 
 config WL1271
 	tristate "TI wl1271 support"
-	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
+	depends on SPI_MASTER && GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
@@ -50,3 +52,5 @@ config WL1271
 
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
+
+endif # WL12XX
-- 
1.6.2.5

