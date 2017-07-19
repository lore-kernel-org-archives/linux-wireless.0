Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33778 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933051AbdGSTPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:15:44 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 31/34] brcmfmac: Remove func0 from function array
Date: Wed, 19 Jul 2017 20:08:19 +0100
Message-Id: <20170719190822.10857-32-ian@mnementh.co.uk> (sfid-20170719_211549_323359_3F71D3D6)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux doesnt pass you func0 as a function when probing - instead
providing specific access functions to read/write it.

This prepares for a patch to remove the actual array entry itself.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  5 +----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |  4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 13 ++++++-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 42b09a301f5f..89cf71d98cee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1021,8 +1021,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	/* store refs to functions used. mmc_card does
 	 * not hold the F0 function pointer.
 	 */
-	sdiodev->func[0] = kmemdup(func, sizeof(*func), GFP_KERNEL);
-	sdiodev->func[0]->num = 0;
+	sdiodev->func[0] = NULL;
 	sdiodev->func[1] = func->card->sdio_func[0];
 	sdiodev->func[2] = func;
 
@@ -1048,7 +1047,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 fail:
 	dev_set_drvdata(&func->dev, NULL);
 	dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
-	kfree(sdiodev->func[0]);
 	kfree(sdiodev);
 	kfree(bus_if);
 	return err;
@@ -1081,7 +1079,6 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
 
 		kfree(bus_if);
-		kfree(sdiodev->func[0]);
 		kfree(sdiodev);
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 2a52f48bdddc..9b8bd870c1fc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3751,8 +3751,8 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	/* Force 4339 chips over rev2 to use the same ID */
 	/* This is borderline tolerable whilst there is only two exceptions */
 	/* But could be handled better */
-	if ((sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-		sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
+	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
+		sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
 		addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index d0dd69454bbd..cae21d14042d 100644
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
 /* Functions for accessing SDIO Function 0 */
 #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
-	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
+	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
 
 #define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
-	sdio_f0_writeb((sdiodev)->func[0], (v), (addr), (ret))
+	sdio_f0_writeb((sdiodev)->func[1], (v), (addr), (ret))
 
 /* Functions for accessing SDIO Function 1 */
 #define brcmf_sdiod_readb(sdiodev, addr, r) \
-- 
2.11.0
