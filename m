Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484AbcHBM0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:26:51 -0400
From: Baole Ni <baolex.ni@intel.com>
To: chunkeey@googlemail.com, kvalo@codeaurora.org,
	luciano.coelho@intel.com, linuxwifi@intel.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, a@unstable.cc, fw@strlen.de,
	Jes.Sorensen@redhat.com
Subject: [PATCH 0783/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:45:56 +0800
Message-Id: <20160802114556.1945-1-baolex.ni@intel.com> (sfid-20160802_173329_382144_1E3B15C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/net/wireless/intersil/p54/p54spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index 7ab2f43..07c77f8 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -48,11 +48,11 @@ MODULE_FIRMWARE("3826.arm");
  */
 
 static int p54spi_gpio_power = 97;
-module_param(p54spi_gpio_power, int, 0444);
+module_param(p54spi_gpio_power, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(p54spi_gpio_power, "gpio number for power line");
 
 static int p54spi_gpio_irq = 87;
-module_param(p54spi_gpio_irq, int, 0444);
+module_param(p54spi_gpio_irq, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(p54spi_gpio_irq, "gpio number for irq line");
 
 static void p54spi_spi_read(struct p54s_priv *priv, u8 address,
-- 
2.9.2

