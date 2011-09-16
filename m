Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4650 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1IPT2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:21 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/19] staging: brcm80211: remove fullmac module_param
 sd_f2_blocksize
Date: Fri, 16 Sep 2011 12:27:51 -0700
Message-ID: <1316201288-29635-3-git-send-email-frankyl@broadcom.com> (sfid-20110916_212828_730192_717C614B)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replaced the global variable with macro.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    4 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   10 +++++-----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 --
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 26919f1..d9d1592 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -37,10 +37,6 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-/* Module parameters specific to each host-controller driver */
-
-module_param(sd_f2_blocksize, int, 0);
-
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7cb8f3f..65cd5d7 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -40,7 +40,8 @@
 
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 
-uint sd_f2_blocksize = 512;	/* Default blocksize */
+#define SDIO_FUNC1_BLOCKSIZE		64
+#define SDIO_FUNC2_BLOCKSIZE		512
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
@@ -466,7 +467,7 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->num_funcs = 2;
 
 	sdio_claim_host(sdiodev->func[1]);
-	err_ret = sdio_set_block_size(sdiodev->func[1], 64);
+	err_ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
 	sdio_release_host(sdiodev->func[1]);
 	if (err_ret) {
 		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
@@ -474,11 +475,10 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	sdio_claim_host(sdiodev->func[2]);
-	err_ret = sdio_set_block_size(sdiodev->func[2], sd_f2_blocksize);
+	err_ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
 	sdio_release_host(sdiodev->func[2]);
 	if (err_ret) {
-		brcmf_dbg(ERROR, "Failed to set F2 blocksize to %d\n",
-			  sd_f2_blocksize);
+		brcmf_dbg(ERROR, "Failed to set F2 blocksize\n");
 		goto out;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index c67e1c8..fb5f6b5 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -244,8 +244,6 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
 
-extern uint sd_f2_blocksize;
-
 extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 				u32 regsva, struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
-- 
1.7.1


