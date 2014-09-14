Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:38615 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaINTcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 15:32:10 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so3519431lab.34
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 12:32:08 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [RFC 18/18] ath5k: correct dependency
Date: Sun, 14 Sep 2014 23:33:33 +0400
Message-Id: <1410723213-22440-19-git-send-email-ryazanov.s.a@gmail.com> (sfid-20140914_213218_943547_55D2A66C)
In-Reply-To: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
References: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of AR231x SoCs (e.g. AR2315) have PCI bus support, so remove !PCI
dependency, which block AHB support build.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
---
 drivers/net/wireless/ath/ath5k/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 027c11c..2b2a399 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -6,8 +6,8 @@ config ATH5K
 	select LEDS_CLASS
 	select NEW_LEDS
 	select AVERAGE
-	select ATH5K_AHB if (AR231X && !PCI)
-	select ATH5K_PCI if (!AR231X && PCI)
+	select ATH5K_AHB if AR231X
+	select ATH5K_PCI if !AR231X
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
@@ -54,7 +54,7 @@ config ATH5K_TRACER
 
 config ATH5K_AHB
 	bool "Atheros 5xxx AHB bus support"
-	depends on (AR231X && !PCI)
+	depends on AR231X
 	---help---
 	  This adds support for WiSoC type chipsets of the 5xxx Atheros
 	  family.
-- 
1.8.1.5

