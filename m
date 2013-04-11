Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4975 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/15] brcmfmac: setup SDIO reset behavior
Date: Thu, 11 Apr 2013 13:28:52 +0200
Message-ID: <1365679740-25679-8-git-send-email-arend@broadcom.com> (sfid-20130411_133048_887742_7CA280F3)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Set device in a manner that SDIO I/O card reset
will lead to WLAN backplane and PMU state reset.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   38 ++++++++++++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 ++
 include/linux/bcma/bcma_driver_chipcommon.h        |    3 ++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d24eb66..c06bb08 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3635,7 +3635,6 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	int err = 0;
 	int reg_addr;
 	u32 reg_val;
-	u8 idx;
 
 	bus->alp_only = true;
 
@@ -3686,12 +3685,37 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		goto fail;
 	}
 
-	/* Set core control so an SDIO reset does a backplane reset */
-	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
-	reg_addr = bus->ci->c_inf[idx].base +
-		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdio_regrl(bus->sdiodev, reg_addr, NULL);
-	brcmf_sdio_regwl(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN, NULL);
+	/* Set card control so an SDIO card reset does a WLAN backplane reset */
+	reg_val = brcmf_sdio_regrb(bus->sdiodev,
+				   SDIO_CCCR_BRCM_CARDCTRL, &err);
+	if (err)
+		goto fail;
+
+	reg_val |= SDIO_CCCR_BRCM_CARDCTRL_WLANRESET;
+
+	brcmf_sdio_regwb(bus->sdiodev,
+			 SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
+	if (err)
+		goto fail;
+
+	/* set PMUControl so a backplane reset does PMU state reload */
+	reg_addr = CORE_CC_REG(bus->ci->c_inf[0].base,
+			       pmucontrol);
+	reg_val = brcmf_sdio_regrl(bus->sdiodev,
+				   reg_addr,
+				   &err);
+	if (err)
+		goto fail;
+
+	reg_val |= (BCMA_CC_PMU_CTL_RES_RELOAD << BCMA_CC_PMU_CTL_RES_SHIFT);
+
+	brcmf_sdio_regwl(bus->sdiodev,
+			 reg_addr,
+			 reg_val,
+			 &err);
+	if (err)
+		goto fail;
+
 
 	sdio_release_host(bus->sdiodev->func[1]);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index b9b397b..28ed3cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -52,6 +52,8 @@
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
 #define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
+#define SDIO_CCCR_BRCM_CARDCTRL		0xf1
+#define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
 #define SDIO_CCCR_BRCM_SEPINT			0xf2
 
 #define  SDIO_SEPINT_MASK		0x01
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 453fcc9..b8b09ea 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -316,6 +316,9 @@
 #define BCMA_CC_PMU_CTL			0x0600 /* PMU control */
 #define  BCMA_CC_PMU_CTL_ILP_DIV	0xFFFF0000 /* ILP div mask */
 #define  BCMA_CC_PMU_CTL_ILP_DIV_SHIFT	16
+#define  BCMA_CC_PMU_CTL_RES		0x00006000 /* reset control mask */
+#define  BCMA_CC_PMU_CTL_RES_SHIFT	13
+#define  BCMA_CC_PMU_CTL_RES_RELOAD	0x2	/* reload POR values */
 #define  BCMA_CC_PMU_CTL_PLL_UPD	0x00000400
 #define  BCMA_CC_PMU_CTL_NOILPONW	0x00000200 /* No ILP on wait */
 #define  BCMA_CC_PMU_CTL_HTREQEN	0x00000100 /* HT req enable */
-- 
1.7.10.4


