Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4155 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab1IAJRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:44 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/30] staging: brcm80211: remove static function
 declaration in bcmsdh_sdmmc
Date: Thu, 1 Sep 2011 11:17:08 +0200
Message-ID: <1314868640-9425-19-git-send-email-rvossen@broadcom.com> (sfid-20110901_111819_434855_2C8AE4B7)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Reshuffle function order in bcmsdh_sdmmc of fullmac to get rid of
static function declaration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  332 ++++++++++-----------
 1 files changed, 157 insertions(+), 175 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index ef09a63..fd34dd4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -40,16 +40,6 @@
 
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 
-static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr);
-static int brcmf_ops_sdio_probe(struct sdio_func *func,
-				const struct sdio_device_id *id);
-static void brcmf_ops_sdio_remove(struct sdio_func *func);
-
-#ifdef CONFIG_PM
-static int brcmf_sdio_suspend(struct device *dev);
-static int brcmf_sdio_resume(struct device *dev);
-#endif /* CONFIG_PM */
-
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 /* devices we support, null terminated */
@@ -57,26 +47,6 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{ /* end: all zeroes */ },
 };
-
-#ifdef CONFIG_PM_SLEEP
-static const struct dev_pm_ops brcmf_sdio_pm_ops = {
-	.suspend	= brcmf_sdio_suspend,
-	.resume		= brcmf_sdio_resume,
-};
-#endif	/* CONFIG_PM_SLEEP */
-
-static struct sdio_driver brcmf_sdmmc_driver = {
-	.probe = brcmf_ops_sdio_probe,
-	.remove = brcmf_ops_sdio_remove,
-	.name = "brcmfmac",
-	.id_table = brcmf_sdmmc_ids,
-#ifdef CONFIG_PM_SLEEP
-	.drv = {
-		.pm = &brcmf_sdio_pm_ops,
-	},
-#endif	/* CONFIG_PM_SLEEP */
-};
-
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
 #ifdef CONFIG_PM_SLEEP
@@ -86,10 +56,6 @@ DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
 #endif		/* CONFIG_PM_SLEEP */
 
-static int
-brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
-			 int regsize, u32 *data);
-
 static bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 {
@@ -110,145 +76,6 @@ brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t wq)
 #endif
 }
 
-static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
-{
-	int err_ret;
-	u32 fbraddr;
-	u8 func;
-
-	brcmf_dbg(TRACE, "\n");
-
-	/* Get the Card's common CIS address */
-	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
-							   SDIO_CCCR_CIS);
-	brcmf_dbg(INFO, "Card's Common CIS Ptr = 0x%x\n",
-		  sdiodev->func_cis_ptr[0]);
-
-	/* Get the Card's function CIS (for each function) */
-	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
-	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
-		sdiodev->func_cis_ptr[func] =
-		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
-		brcmf_dbg(INFO, "Function %d CIS Ptr = 0x%x\n",
-			  func, sdiodev->func_cis_ptr[func]);
-	}
-
-	/* Enable Function 1 */
-	sdio_claim_host(sdiodev->func[1]);
-	err_ret = sdio_enable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
-	if (err_ret)
-		brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
-
-	return false;
-}
-
-/*
- *	Public entry points & extern's
- */
-int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
-{
-	int err_ret = 0;
-
-	brcmf_dbg(TRACE, "\n");
-
-	sdiodev->num_funcs = 2;
-
-	sdio_claim_host(sdiodev->func[1]);
-	err_ret = sdio_set_block_size(sdiodev->func[1], 64);
-	sdio_release_host(sdiodev->func[1]);
-	if (err_ret) {
-		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
-		goto out;
-	}
-
-	sdio_claim_host(sdiodev->func[2]);
-	err_ret = sdio_set_block_size(sdiodev->func[2], sd_f2_blocksize);
-	sdio_release_host(sdiodev->func[2]);
-	if (err_ret) {
-		brcmf_dbg(ERROR, "Failed to set F2 blocksize to %d\n",
-			  sd_f2_blocksize);
-		goto out;
-	}
-
-	brcmf_sdioh_enablefuncs(sdiodev);
-
-out:
-	brcmf_dbg(TRACE, "Done\n");
-	return err_ret;
-}
-
-void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
-{
-	brcmf_dbg(TRACE, "\n");
-
-	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func[2]);
-	sdio_disable_func(sdiodev->func[2]);
-	sdio_release_host(sdiodev->func[2]);
-
-	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func[1]);
-	sdio_disable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
-
-}
-
-static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
-{
-	/* read 24 bits and return valid 17 bit addr */
-	int i;
-	u32 scratch, regdata;
-	u8 *ptr = (u8 *)&scratch;
-	for (i = 0; i < 3; i++) {
-		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
-				&regdata)) != SUCCESS)
-			brcmf_dbg(ERROR, "Can't read!\n");
-
-		*ptr++ = (u8) regdata;
-		regaddr++;
-	}
-
-	/* Only the lower 17-bits are valid */
-	scratch = le32_to_cpu(scratch);
-	scratch &= 0x0001FFFF;
-	return scratch;
-}
-
-extern int
-brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
-		     u8 *cisd, u32 length)
-{
-	u32 count;
-	int offset;
-	u32 foo;
-	u8 *cis = cisd;
-
-	brcmf_dbg(TRACE, "Func = %d\n", func);
-
-	if (!sdiodev->func_cis_ptr[func]) {
-		memset(cis, 0, length);
-		brcmf_dbg(ERROR, "no func_cis_ptr[%d]\n", func);
-		return -ENOTSUPP;
-	}
-
-	brcmf_dbg(ERROR, "func_cis_ptr[%d]=0x%04x\n",
-		  func, sdiodev->func_cis_ptr[func]);
-
-	for (count = 0; count < length; count++) {
-		offset = sdiodev->func_cis_ptr[func] + count;
-		if (brcmf_sdioh_card_regread(sdiodev, 0, offset, 1, &foo) < 0) {
-			brcmf_dbg(ERROR, "regread failed: Can't read CIS\n");
-			return -EIO;
-		}
-
-		*cis = (u8) (foo & 0xff);
-		cis++;
-	}
-
-	return 0;
-}
-
 extern int
 brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			 uint regaddr, u8 *byte)
@@ -577,6 +404,145 @@ brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 	return SUCCESS;
 }
 
+static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
+{
+	/* read 24 bits and return valid 17 bit addr */
+	int i;
+	u32 scratch, regdata;
+	u8 *ptr = (u8 *)&scratch;
+	for (i = 0; i < 3; i++) {
+		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
+				&regdata)) != SUCCESS)
+			brcmf_dbg(ERROR, "Can't read!\n");
+
+		*ptr++ = (u8) regdata;
+		regaddr++;
+	}
+
+	/* Only the lower 17-bits are valid */
+	scratch = le32_to_cpu(scratch);
+	scratch &= 0x0001FFFF;
+	return scratch;
+}
+
+extern int
+brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
+		     u8 *cisd, u32 length)
+{
+	u32 count;
+	int offset;
+	u32 foo;
+	u8 *cis = cisd;
+
+	brcmf_dbg(TRACE, "Func = %d\n", func);
+
+	if (!sdiodev->func_cis_ptr[func]) {
+		memset(cis, 0, length);
+		brcmf_dbg(ERROR, "no func_cis_ptr[%d]\n", func);
+		return -ENOTSUPP;
+	}
+
+	brcmf_dbg(ERROR, "func_cis_ptr[%d]=0x%04x\n",
+		  func, sdiodev->func_cis_ptr[func]);
+
+	for (count = 0; count < length; count++) {
+		offset = sdiodev->func_cis_ptr[func] + count;
+		if (brcmf_sdioh_card_regread(sdiodev, 0, offset, 1, &foo) < 0) {
+			brcmf_dbg(ERROR, "regread failed: Can't read CIS\n");
+			return -EIO;
+		}
+
+		*cis = (u8) (foo & 0xff);
+		cis++;
+	}
+
+	return 0;
+}
+
+static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
+{
+	int err_ret;
+	u32 fbraddr;
+	u8 func;
+
+	brcmf_dbg(TRACE, "\n");
+
+	/* Get the Card's common CIS address */
+	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
+							   SDIO_CCCR_CIS);
+	brcmf_dbg(INFO, "Card's Common CIS Ptr = 0x%x\n",
+		  sdiodev->func_cis_ptr[0]);
+
+	/* Get the Card's function CIS (for each function) */
+	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
+	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
+		sdiodev->func_cis_ptr[func] =
+		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
+		brcmf_dbg(INFO, "Function %d CIS Ptr = 0x%x\n",
+			  func, sdiodev->func_cis_ptr[func]);
+	}
+
+	/* Enable Function 1 */
+	sdio_claim_host(sdiodev->func[1]);
+	err_ret = sdio_enable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
+	if (err_ret)
+		brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
+
+	return false;
+}
+
+/*
+ *	Public entry points & extern's
+ */
+int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
+{
+	int err_ret = 0;
+
+	brcmf_dbg(TRACE, "\n");
+
+	sdiodev->num_funcs = 2;
+
+	sdio_claim_host(sdiodev->func[1]);
+	err_ret = sdio_set_block_size(sdiodev->func[1], 64);
+	sdio_release_host(sdiodev->func[1]);
+	if (err_ret) {
+		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
+		goto out;
+	}
+
+	sdio_claim_host(sdiodev->func[2]);
+	err_ret = sdio_set_block_size(sdiodev->func[2], sd_f2_blocksize);
+	sdio_release_host(sdiodev->func[2]);
+	if (err_ret) {
+		brcmf_dbg(ERROR, "Failed to set F2 blocksize to %d\n",
+			  sd_f2_blocksize);
+		goto out;
+	}
+
+	brcmf_sdioh_enablefuncs(sdiodev);
+
+out:
+	brcmf_dbg(TRACE, "Done\n");
+	return err_ret;
+}
+
+void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
+{
+	brcmf_dbg(TRACE, "\n");
+
+	/* Disable Function 2 */
+	sdio_claim_host(sdiodev->func[2]);
+	sdio_disable_func(sdiodev->func[2]);
+	sdio_release_host(sdiodev->func[2]);
+
+	/* Disable Function 1 */
+	sdio_claim_host(sdiodev->func[1]);
+	sdio_disable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
+
+}
+
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			      const struct sdio_device_id *id)
 {
@@ -635,7 +601,6 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	}
 }
 
-
 #ifdef CONFIG_PM_SLEEP
 static int brcmf_sdio_suspend(struct device *dev)
 {
@@ -677,7 +642,24 @@ static int brcmf_sdio_resume(struct device *dev)
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
 }
-#endif		/* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops brcmf_sdio_pm_ops = {
+	.suspend	= brcmf_sdio_suspend,
+	.resume		= brcmf_sdio_resume,
+};
+#endif	/* CONFIG_PM_SLEEP */
+
+static struct sdio_driver brcmf_sdmmc_driver = {
+	.probe = brcmf_ops_sdio_probe,
+	.remove = brcmf_ops_sdio_remove,
+	.name = "brcmfmac",
+	.id_table = brcmf_sdmmc_ids,
+#ifdef CONFIG_PM_SLEEP
+	.drv = {
+		.pm = &brcmf_sdio_pm_ops,
+	},
+#endif	/* CONFIG_PM_SLEEP */
+};
 
 /*
  * module init
-- 
1.7.4.1


