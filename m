Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59018 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaEJROU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 13:14:20 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so3497430eek.13
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 10:14:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: drop SSB dependency
Date: Sat, 10 May 2014 19:14:09 +0200
Message-Id: <1399742049-31810-1-git-send-email-zajec5@gmail.com> (sfid-20140510_191424_405005_0CAF59E8)
In-Reply-To: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds choice submenu "Supported bus types" as two simple bool
configs would allow user to compile b43 without any bus support
(prety useless).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Drop "depends" from B43_BCMA and B43_SSB, as Michael noticed - it didn't
    make much sense.
    Auto-select BCMA/SSB in B43 config. This keeps user-friendly behavior that
    existed up to now (it's extended to hover BCMA as well). It also assures
    B43 won't be "y" with BCMA/SSB being "m".
---
 drivers/net/wireless/b43/Kconfig | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index ce937a9..8d1c3ab 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -1,7 +1,8 @@
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && HAS_DMA
-	select SSB
+	depends on (BCMA_POSSIBLE || SSB_POSSIBLE) && MAC80211 && HAS_DMA
+	select BCMA if B43_BCMA
+	select SSB if B43_SSB
 	select FW_LOADER
 	---help---
 	  b43 is a driver for the Broadcom 43xx series wireless devices.
@@ -27,14 +28,33 @@ config B43
 	  If unsure, say M.
 
 config B43_BCMA
-	bool "Support for BCMA bus"
-	depends on B43 && (BCMA = y || BCMA = B43)
-	default y
+	bool
 
 config B43_SSB
 	bool
-	depends on B43 && (SSB = y || SSB = B43)
-	default y
+
+choice
+	prompt "Supported bus types"
+	depends on B43
+	default B43_BCMA_AND_SSB
+
+config B43_BUSES_BCMA_AND_SSB
+	bool "BCMA and SSB"
+	depends on BCMA_POSSIBLE && SSB_POSSIBLE
+	select B43_BCMA
+	select B43_SSB
+
+config B43_BUSES_BCMA
+	bool "BCMA only"
+	depends on BCMA_POSSIBLE
+	select B43_BCMA
+
+config B43_BUSES_SSB
+	bool "SSB only"
+	depends on SSB_POSSIBLE
+	select B43_SSB
+
+endchoice
 
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT
@@ -98,7 +118,7 @@ config B43_BCMA_PIO
 
 config B43_PIO
 	bool
-	depends on B43
+	depends on B43 && B43_SSB
 	select SSB_BLOCKIO
 	default y
 
-- 
1.8.4.5

