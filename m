Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46682 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3JDXfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 19:35:04 -0400
Received: by mail-pa0-f52.google.com with SMTP id kl14so4774771pab.39
        for <linux-wireless@vger.kernel.org>; Fri, 04 Oct 2013 16:35:03 -0700 (PDT)
Date: Fri, 4 Oct 2013 16:45:18 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, wcn36xx@qca.qualcomm.com
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
 hardware
Message-ID: <20131004234514.GA11128@garbanzo.do-not-panic.com> (sfid-20131005_013509_992900_728570EE)
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 26, 2013 at 11:28:28PM +0100, Eugene Krasnikov wrote:
> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
> far WCN3660/WCN3680 is available only on MSM platform.
> 
> Firmware can be found here:
> https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS
> 
> Wiki page is available here:
> http://wireless.kernel.org/en/users/Drivers/wcn36xx
> 
> A lot people made a contribution to this driver. Here is the list in
> alphabetical order:
> 
> Eugene Krasnikov <k.eugene.e@gmail.com>
> Kalle Valo <kvalo@qca.qualcomm.com>
> Olof Johansson <dev@skyshaper.net>
> Pontus Fuchs <pontus.fuchs@gmail.com>
> Yanbo Li <yanbol@qti.qualcomm.com>
> 
> Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>

Nice! I test compiled with sparse enabled and got this:

mcgrof@chalten ~/wireless-testing (git::master)$ make C=1
M=drivers/net/wireless/ath/wcn36xx/
CHECK   drivers/net/wireless/ath/wcn36xx/main.c
CC [M]  drivers/net/wireless/ath/wcn36xx/main.o
CHECK   drivers/net/wireless/ath/wcn36xx/dxe.c
CC [M]  drivers/net/wireless/ath/wcn36xx/dxe.o
CHECK   drivers/net/wireless/ath/wcn36xx/txrx.c
CC [M]  drivers/net/wireless/ath/wcn36xx/txrx.o
CHECK   drivers/net/wireless/ath/wcn36xx/smd.c
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (4096 8)
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (512 8)
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (128 8)
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (8 8)
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (256 8)
/home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (4096 8)
CC [M]  drivers/net/wireless/ath/wcn36xx/smd.o
CHECK   drivers/net/wireless/ath/wcn36xx/pmc.c
CC [M]  drivers/net/wireless/ath/wcn36xx/pmc.o
CHECK   drivers/net/wireless/ath/wcn36xx/debug.c
CC [M]  drivers/net/wireless/ath/wcn36xx/debug.o
LD [M]
drivers/net/wireless/ath/wcn36xx/wcn36xx.o
Building modules, stage 2.
MODPOST 1 modules
LD [M]
drivers/net/wireless/ath/wcn36xx/wcn36xx.ko

Can you merge this in prior to integration as well? I've only test
compiled it so would appreciate a run time test.

  Luis

>From 4558cfc69270ad3ed1a480a8c846b11910af7357 Mon Sep 17 00:00:00 2001
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 4 Oct 2013 16:19:17 -0700
Subject: [PATCH] wcn36xx: add initial regulatory support

The NVRAM still needs to be processed and other requirements
addressed but this should at least get this going with the
default 0x64 regulatory domain on the ath module.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/wcn36xx/Kconfig   |    1 +
 drivers/net/wireless/ath/wcn36xx/main.c    |   34 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |    2 ++
 3 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
index 591ebae..5011fea 100644
--- a/drivers/net/wireless/ath/wcn36xx/Kconfig
+++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
@@ -1,6 +1,7 @@
 config WCN36XX
 	tristate "Qualcomm Atheros WCN3660/3680 support"
 	depends on MAC80211 && HAS_DMA
+	select ATH_COMMON
 	---help---
 	  This module adds support for wireless adapters based on
 	  Qualcomm Atheros WCN3660 and WCN3680 mobile chipsets.
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 7839b31..ab8ecaa 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -24,6 +24,12 @@ unsigned int wcn36xx_dbg_mask;
 module_param_named(debug_mask, wcn36xx_dbg_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
+/* XXX: parse NVRAM */
+static struct ath_regulatory ath_reg_default = {
+	.current_rd = 0x64,
+	.power_limit = 63,
+};
+
 #define CHAN2G(_freq, _idx) { \
 	.band = IEEE80211_BAND_2GHZ, \
 	.center_freq = (_freq), \
@@ -939,12 +945,27 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 	return 0;
 }
 
+static void wcn_reg_notifier(struct wiphy *wiphy,
+			     struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct wcn36xx *wcn = hw->priv;
+	struct ath_regulatory *reg = wcn->reg;
+
+	ath_reg_notifier_apply(wiphy, request, reg);
+
+	/* XXX: Set tx power, and DFS domain */
+
+	return;
+}
+
 static int wcn36xx_probe(struct platform_device *pdev)
 {
 	struct ieee80211_hw *hw;
 	struct wcn36xx *wcn;
 	int ret;
 	u8 addr[ETH_ALEN];
+	struct ath_regulatory *reg;
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "platform probe\n");
 
@@ -971,11 +992,24 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_wq;
 
+	wcn->reg = &ath_reg_default;
+	reg = wcn->reg;
+	ret = ath_regd_init(reg, wcn->hw->wiphy,
+			    wcn_reg_notifier);
+	if (ret)
+		goto out_wq;
+
 	wcn36xx_init_ieee80211(wcn);
 	ret = ieee80211_register_hw(wcn->hw);
 	if (ret)
 		goto out_unmap;
 
+	if (!ath_is_world_regd(wcn->reg)) {
+		ret = regulatory_hint(wcn->hw->wiphy, reg->alpha2);
+		if (ret)
+			goto out_unmap;
+	}
+
 	return 0;
 
 out_unmap:
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 58b6383..d7eeeae 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -28,6 +28,7 @@
 #include "dxe.h"
 #include "pmc.h"
 #include "debug.h"
+#include "../regd.h"
 
 #define WLAN_NV_FILE               "wlan/prima/WCNSS_qcom_wlan_nv.bin"
 #define WCN36XX_AGGR_BUFFER_SIZE 64
@@ -214,6 +215,7 @@ struct wcn36xx {
 	struct wcn36xx_dxe_mem_pool data_mem_pool;
 
 	struct sk_buff		*tx_ack_skb;
+	struct ath_regulatory *reg;
 
 #ifdef CONFIG_WCN36XX_DEBUGFS
 	/* Debug file system entry */
-- 
1.7.10.4

