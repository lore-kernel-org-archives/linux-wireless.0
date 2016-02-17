Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:17453
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161116AbcBQK12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:28 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/21] brcmfmac: move module init and exit to common
Date: Wed, 17 Feb 2016 11:27:02 +0100
Message-Id: <1455704830-10088-14-git-send-email-arend@broadcom.com> (sfid-20160217_112834_952154_23FB13CC)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In preparation of module parameters for all devices the module init
and exit routines are moved to the common file.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 36 +++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  1 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 15 ++-------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 52b355a..07eff43 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -27,6 +27,10 @@
 #include "tracepoint.h"
 #include "common.h"
 
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
+MODULE_LICENSE("Dual BSD/GPL");
+
 const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
@@ -220,7 +224,7 @@ void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
 }
 #endif
 
-void brcmf_mp_attach(void)
+static void brcmf_mp_attach(void)
 {
 	strlcpy(brcmf_mp_global.firmware_path, brcmf_firmware_path,
 		BRCMF_FW_ALTPATH_LEN);
@@ -248,3 +252,33 @@ void brcmf_mp_device_detach(struct brcmf_pub *drvr)
 	kfree(drvr->settings);
 }
 
+static int __init brcmfmac_module_init(void)
+{
+	int err;
+
+	/* Initialize debug system first */
+	brcmf_debugfs_init();
+
+#ifdef CONFIG_BRCMFMAC_SDIO
+	brcmf_sdio_init();
+#endif
+	/* Initialize global module paramaters */
+	brcmf_mp_attach();
+
+	/* Continue the initialization by registering the different busses */
+	err = brcmf_core_init();
+	if (err)
+		brcmf_debugfs_exit();
+
+	return err;
+}
+
+static void __exit brcmfmac_module_exit(void)
+{
+	brcmf_core_exit();
+	brcmf_debugfs_exit();
+}
+
+module_init(brcmfmac_module_init);
+module_exit(brcmfmac_module_exit);
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index b678b2d..256be1b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -89,7 +89,6 @@ struct brcmf_mp_device {
 	struct cc_translate *country_codes;
 };
 
-void brcmf_mp_attach(void);
 int brcmf_mp_device_attach(struct brcmf_pub *drvr);
 void brcmf_mp_device_detach(struct brcmf_pub *drvr);
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 3087d10..7b24e2b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,10 +38,6 @@
 #include "pcie.h"
 #include "common.h"
 
-MODULE_AUTHOR("Broadcom Corporation");
-MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
-MODULE_LICENSE("Dual BSD/GPL");
-
 #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
 
 /* AMPDU rx reordering definitions */
@@ -1422,19 +1418,15 @@ static void brcmf_driver_register(struct work_struct *work)
 }
 static DECLARE_WORK(brcmf_driver_work, brcmf_driver_register);
 
-static int __init brcmfmac_module_init(void)
+int __init brcmf_core_init(void)
 {
-	brcmf_debugfs_init();
-#ifdef CONFIG_BRCMFMAC_SDIO
-	brcmf_sdio_init();
-#endif
 	if (!schedule_work(&brcmf_driver_work))
 		return -EBUSY;
 
 	return 0;
 }
 
-static void __exit brcmfmac_module_exit(void)
+void __exit brcmf_core_exit(void)
 {
 	cancel_work_sync(&brcmf_driver_work);
 
@@ -1447,8 +1439,5 @@ static void __exit brcmfmac_module_exit(void)
 #ifdef CONFIG_BRCMFMAC_PCIE
 	brcmf_pcie_exit();
 #endif
-	brcmf_debugfs_exit();
 }
 
-module_init(brcmfmac_module_init);
-module_exit(brcmfmac_module_exit);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 500dac6..7bdb6fef 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -227,5 +227,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
+int __init brcmf_core_init(void);
+void __exit brcmf_core_exit(void);
 
 #endif /* BRCMFMAC_CORE_H */
-- 
1.9.1

