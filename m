Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43540 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934948AbeEJLQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:16:00 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB = y
Date: Thu, 10 May 2018 13:14:01 +0200
Message-Id: <20180510111401.1161-2-zajec5@gmail.com> (sfid-20180510_131619_055462_2B733E35)
In-Reply-To: <20180510111401.1161-1-zajec5@gmail.com>
References: <20180510111401.1161-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not exported
symbols pcibios_enable_device and register_pci_controller. This code is
supposed to be compiled only with ssb builtin.

This fixes:
ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index b3f5cae98ea6..c574dd210500 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
 
 config SSB_PCICORE_HOSTMODE
 	bool "Hostmode support for SSB PCI core"
-	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
+	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && SSB = y
 	help
 	  PCIcore hostmode operation (external PCI bus).
 
-- 
2.13.6
