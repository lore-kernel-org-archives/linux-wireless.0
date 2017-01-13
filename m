Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36159 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdAMFWY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 00:22:24 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so25195557pfu.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 21:22:24 -0800 (PST)
From: Matt Ranostay <matt@ranostay.consulting>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Cc: tony@atomide.com, Matt Ranostay <matt@ranostay.consulting>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v2 2/2] mmc: pwrseq: add support for Marvell SD8787 chip
Date: Thu, 12 Jan 2017 21:22:18 -0800
Message-Id: <20170113052218.10534-3-matt@ranostay.consulting> (sfid-20170113_062239_069451_EE4ECF62)
In-Reply-To: <20170113052218.10534-1-matt@ranostay.consulting>
References: <20170113052218.10534-1-matt@ranostay.consulting>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
This can be abstracted to other chipsets if needed in the future.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
---
 drivers/mmc/core/Kconfig  | 10 ++++++++++
 drivers/mmc/core/Makefile |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index cdfa8520a4b1..fc1ecdaaa9ca 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -12,6 +12,16 @@ config PWRSEQ_EMMC
 	  This driver can also be built as a module. If so, the module
 	  will be called pwrseq_emmc.
 
+config PWRSEQ_SD8787
+	tristate "HW reset support for SD8787 BT + Wifi module"
+	depends on OF && (MWIFIEX || BT_MRVL_SDIO)
+	help
+	  This selects hardware reset support for the SD8787 BT + Wifi
+	  module. By default this option is set to n.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called pwrseq_sd8787.
+
 config PWRSEQ_SIMPLE
 	tristate "Simple HW reset support for MMC"
 	default y
diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index b2a257dc644f..0f81464fa824 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -10,6 +10,7 @@ mmc_core-y			:= core.o bus.o host.o \
 				   quirks.o slot-gpio.o
 mmc_core-$(CONFIG_OF)		+= pwrseq.o
 obj-$(CONFIG_PWRSEQ_SIMPLE)	+= pwrseq_simple.o
+obj-$(CONFIG_PWRSEQ_SD8787)	+= pwrseq_sd8787.o
 obj-$(CONFIG_PWRSEQ_EMMC)	+= pwrseq_emmc.o
 mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
-- 
2.10.2
