Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46312 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaINTcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 15:32:08 -0400
Received: by mail-lb0-f177.google.com with SMTP id l4so3367300lbv.22
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 12:32:07 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [RFC 17/18] ath5k: update dependency
Date: Sun, 14 Sep 2014 23:33:32 +0400
Message-Id: <1410723213-22440-18-git-send-email-ryazanov.s.a@gmail.com> (sfid-20140914_213218_220258_336659B6)
In-Reply-To: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
References: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the ATHEROS_AR231X config symbol to AR231X.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
---
 drivers/net/wireless/ath/ath5k/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index c9f81a3..027c11c 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,13 +1,13 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
-	depends on (PCI || ATHEROS_AR231X) && MAC80211
+	depends on (PCI || AR231X) && MAC80211
 	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
 	select AVERAGE
-	select ATH5K_AHB if (ATHEROS_AR231X && !PCI)
-	select ATH5K_PCI if (!ATHEROS_AR231X && PCI)
+	select ATH5K_AHB if (AR231X && !PCI)
+	select ATH5K_PCI if (!AR231X && PCI)
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
@@ -54,14 +54,14 @@ config ATH5K_TRACER
 
 config ATH5K_AHB
 	bool "Atheros 5xxx AHB bus support"
-	depends on (ATHEROS_AR231X && !PCI)
+	depends on (AR231X && !PCI)
 	---help---
 	  This adds support for WiSoC type chipsets of the 5xxx Atheros
 	  family.
 
 config ATH5K_PCI
 	bool "Atheros 5xxx PCI bus support"
-	depends on (!ATHEROS_AR231X && PCI)
+	depends on (!AR231X && PCI)
 	---help---
 	  This adds support for PCI type chipsets of the 5xxx Atheros
 	  family.
-- 
1.8.1.5

