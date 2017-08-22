Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:58072 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932615AbdHVLnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:43:13 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 25/30] brcmfmac: Remove func0 from function array
Date: Tue, 22 Aug 2017 12:25:45 +0100
Message-Id: <20170822112550.60311-26-ian@mnementh.co.uk> (sfid-20170822_134334_362392_3027302E)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux doesnt pass you func0 as a function when probing - instead
providing specific access functions to read/write it.

This prepares for a patch to remove the actual array entry itself.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  5 +----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 10 +++++++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 13 ++++++-------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 5fa77f8c0abb..69a6699126fd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1019,8 +1019,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	/* store refs to functions used. mmc_card does
 	 * not hold the F0 function pointer.
 	 */
-	sdiodev->func[0] = kmemdup(func, sizeof(*func), GFP_KERNEL);
-	sdiodev->func[0]->num = 0;
+	sdiodev->func[0] = NULL;
 	sdiodev->func[1] = func->card->sdio_func[0];
 	sdiodev->func[2] = func;
 
@@ -1046,7 +1045,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 fail:
 	dev_set_drvdata(&func->dev, NULL);
 	dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
-	kfree(sdiodev->func[0]);
 	kfree(sdiodev);
 	kfree(bus_if);
 	return err;
@@ -1079,7 +1077,6 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
 
 		kfree(bus_if);
-		kfree(sdiodev->func[0]);
 		kfree(sdiodev);
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 62561782ab90..7ebe6460cb5c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3762,9 +3762,13 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	u32 val, rev;
 
 	val = brcmf_sdiod_readl(sdiodev, addr, NULL);
-	if ((sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-	     sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
-	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+
+	/* Force 4339 chips over rev2 to use the same ID */
+	/* This is borderline tolerable whilst there is only two exceptions */
+	/* But could be handled better */
+	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
+	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
+	     addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 		if (rev >= 2) {
 			val &= ~CID_ID_MASK;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index d113c7d814b6..6e2fc065b8a7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -21,7 +21,9 @@
 #include <linux/firmware.h>
 #include "firmware.h"
 
-#define SDIO_FUNC_0		0
+/* Maximum number of I/O funcs */
+#define NUM_SDIO_FUNCS	3
+
 #define SDIO_FUNC_1		1
 #define SDIO_FUNC_2		2
 
@@ -39,9 +41,6 @@
 #define INTR_STATUS_FUNC1	0x2
 #define INTR_STATUS_FUNC2	0x4
 
-/* Maximum number of I/O funcs */
-#define SDIOD_MAX_IOFUNCS	7
-
 /* mask of register map */
 #define REG_F0_REG_MASK		0x7FF
 #define REG_F1_MISC_MASK	0x1FFFF
@@ -175,7 +174,7 @@ struct brcmf_sdio;
 struct brcmf_sdiod_freezer;
 
 struct brcmf_sdio_dev {
-	struct sdio_func *func[SDIO_MAX_FUNCS];
+	struct sdio_func *func[NUM_SDIO_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_core *cc_core;	/* chipcommon core info struct */
@@ -297,10 +296,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 /* SDIO device register access interface */
 /* Accessors for SDIO Function 0 */
 #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
-	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
+	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
 
 #define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
-	sdio_f0_writeb((sdiodev)->func[0], (v), (addr), (ret))
+	sdio_f0_writeb((sdiodev)->func[1], (v), (addr), (ret))
 
 /* Accessors for SDIO Function 1 */
 #define brcmf_sdiod_readb(sdiodev, addr, r) \
-- 
2.11.0
