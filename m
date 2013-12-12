Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32343 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3LLK7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:14 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/18] brcmfmac: remove unused struct brcmf_sdio_dev::func_cis_ptr attribute
Date: Thu, 12 Dec 2013 11:58:52 +0100
Message-ID: <1386845946-9859-5-git-send-email-arend@broadcom.com> (sfid-20131212_115921_801518_443EFB75)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the SDIO probe the func_cis_ptr attribute in struct brcmf_sdio_dev
is being determined, but it is never used after that. Removing it also
obsoletes two functions in bcmsdh.c.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   61 ++------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 -
 2 files changed, 6 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index f22c798..1975054 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -920,60 +920,6 @@ int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	return 0;
 }
 
-static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
-{
-	/* read 24 bits and return valid 17 bit addr */
-	int i, ret;
-	u32 scratch, regdata;
-	__le32 scratch_le;
-	u8 *ptr = (u8 *)&scratch_le;
-
-	for (i = 0; i < 3; i++) {
-		regdata = brcmf_sdio_regrl(sdiodev, regaddr, &ret);
-		if (ret != 0)
-			brcmf_err("Can't read!\n");
-
-		*ptr++ = (u8) regdata;
-		regaddr++;
-	}
-
-	/* Only the lower 17-bits are valid */
-	scratch = le32_to_cpu(scratch_le);
-	scratch &= 0x0001FFFF;
-	return scratch;
-}
-
-static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
-{
-	int err_ret;
-	u32 fbraddr;
-	u8 func;
-
-	brcmf_dbg(SDIO, "\n");
-
-	/* Get the Card's common CIS address */
-	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
-							   SDIO_CCCR_CIS);
-	brcmf_dbg(SDIO, "Card's Common CIS Ptr = 0x%x\n",
-		  sdiodev->func_cis_ptr[0]);
-
-	/* Get the Card's function CIS (for each function) */
-	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
-	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
-		sdiodev->func_cis_ptr[func] =
-		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
-		brcmf_dbg(SDIO, "Function %d CIS Ptr = 0x%x\n",
-			  func, sdiodev->func_cis_ptr[func]);
-	}
-
-	/* Enable Function 1 */
-	err_ret = sdio_enable_func(sdiodev->func[1]);
-	if (err_ret)
-		brcmf_err("Failed to enable F1 Err: 0x%08x\n", err_ret);
-
-	return false;
-}
-
 static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret = 0;
@@ -999,7 +945,12 @@ static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 		goto out;
 	}
 
-	brcmf_sdioh_enablefuncs(sdiodev);
+	/* Enable Function 1 */
+	err_ret = sdio_enable_func(sdiodev->func[1]);
+	if (err_ret) {
+		brcmf_err("Failed to enable F1 Err: 0x%08x\n", err_ret);
+		goto out;
+	}
 
 	/*
 	 * determine host related variables after brcmf_sdio_probe()
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index c1dfa97..8b8f2a9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -164,7 +164,6 @@ struct brcmf_sdio;
 struct brcmf_sdio_dev {
 	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
-	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
 	u32 sbwad;			/* Save backplane window address */
 	void *bus;
 	atomic_t suspend;		/* suspend flag */
-- 
1.7.10.4

