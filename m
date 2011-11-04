Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3697 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/16] brcm80211: fmac: move bus core prep code to
 sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:29 +0100
Message-ID: <1320441822-4615-4-git-send-email-arend@broadcom.com> (sfid-20111104_222425_935760_7A06CA4B)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of abstracting chip backplane handle code
series.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   73 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   52 ++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   24 +++++++
 3 files changed, 77 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e12e99b..9a78cc3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -135,33 +135,6 @@ struct rte_console {
 /*   Force no backplane reset */
 #define SBSDIO_DEVCTL_RST_NOBPRESET	0x20
 
-/* SBSDIO_FUNC1_CHIPCLKCSR */
-
-/* Force ALP request to backplane */
-#define SBSDIO_FORCE_ALP		0x01
-/* Force HT request to backplane */
-#define SBSDIO_FORCE_HT			0x02
-/* Force ILP request to backplane */
-#define SBSDIO_FORCE_ILP		0x04
-/* Make ALP ready (power up xtal) */
-#define SBSDIO_ALP_AVAIL_REQ		0x08
-/* Make HT ready (power up PLL) */
-#define SBSDIO_HT_AVAIL_REQ		0x10
-/* Squelch clock requests from HW */
-#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20
-/* Status: ALP is ready */
-#define SBSDIO_ALP_AVAIL		0x40
-/* Status: HT is ready */
-#define SBSDIO_HT_AVAIL			0x80
-
-#define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
-#define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
-#define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
-#define SBSDIO_ALPONLY(regval)	(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
-
-#define SBSDIO_CLKAV(regval, alponly) \
-	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
-
 /* direct(mapped) cis space */
 
 /* MAPPED common CIS address */
@@ -4010,7 +3983,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 {
 	struct chip_info *ci;
 	int err;
-	u8 clkval, clkset;
+	u8 clkval;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -4019,50 +3992,6 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	if (NULL == ci)
 		return -ENOMEM;
 
-	/* bus/core/clk setup for register access */
-	/* Try forcing SDIO core to do ALPAvail request only */
-	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR,	clkset, &err);
-	if (err) {
-		brcmf_dbg(ERROR, "error writing for HT off\n");
-		goto fail;
-	}
-
-	/* If register supported, wait for ALPAvail and then force ALP */
-	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-			SBSDIO_FUNC1_CHIPCLKCSR, NULL);
-	if ((clkval & ~SBSDIO_AVBITS) == clkset) {
-		SPINWAIT(((clkval =
-				brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-						SBSDIO_FUNC1_CHIPCLKCSR,
-						NULL)),
-				!SBSDIO_ALPAV(clkval)),
-				PMU_MAX_TRANSITION_DLY);
-		if (!SBSDIO_ALPAV(clkval)) {
-			brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval 0x%02x\n",
-				  clkval);
-			err = -EBUSY;
-			goto fail;
-		}
-		clkset = SBSDIO_FORCE_HW_CLKREQ_OFF |
-				SBSDIO_FORCE_ALP;
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_FUNC1_CHIPCLKCSR,
-				clkset, &err);
-		udelay(65);
-	} else {
-		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
-			  clkset, clkval);
-		err = -EACCES;
-		goto fail;
-	}
-
-	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
-
 	err = brcmf_sdio_chip_attach(bus->sdiodev, ci, regs);
 	if (err)
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 7f01a9b..7bf9778 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -106,11 +106,63 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	return 0;
 }
 
+static int
+brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
+{
+	int err = 0;
+	u8 clkval, clkset;
+
+	/* Try forcing SDIO core to do ALPAvail request only */
+	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR,	clkset, &err);
+	if (err) {
+		brcmf_dbg(ERROR, "error writing for HT off\n");
+		return err;
+	}
+
+	/* If register supported, wait for ALPAvail and then force ALP */
+	/* This may take up to 15 milliseconds */
+	clkval = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+
+	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
+		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+			  clkset, clkval);
+		return -EACCES;
+	}
+
+	SPINWAIT(((clkval = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_1,
+				SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
+			!SBSDIO_ALPAV(clkval)),
+			PMU_MAX_TRANSITION_DLY);
+	if (!SBSDIO_ALPAV(clkval)) {
+		brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval 0x%02x\n",
+			  clkval);
+		return -EBUSY;
+	}
+
+	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	udelay(65);
+
+	/* Also, disable the extra SDIO pull-ups */
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+
+	return 0;
+}
+
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 			   struct chip_info *ci, u32 regs)
 {
 	int ret = 0;
 
+	ret = brcmf_sdio_chip_buscoreprep(sdiodev);
+	if (ret != 0)
+		return ret;
+
 	ret = brcmf_sdio_chip_recognition(sdiodev, ci, regs);
 	if (ret != 0)
 		return ret;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 9595186..2d75b8c5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -28,6 +28,30 @@
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
 
+/* SDIO function 1 register CHIPCLKCSR */
+/* Force ALP request to backplane */
+#define SBSDIO_FORCE_ALP		0x01
+/* Force HT request to backplane */
+#define SBSDIO_FORCE_HT			0x02
+/* Force ILP request to backplane */
+#define SBSDIO_FORCE_ILP		0x04
+/* Make ALP ready (power up xtal) */
+#define SBSDIO_ALP_AVAIL_REQ		0x08
+/* Make HT ready (power up PLL) */
+#define SBSDIO_HT_AVAIL_REQ		0x10
+/* Squelch clock requests from HW */
+#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20
+/* Status: ALP is ready */
+#define SBSDIO_ALP_AVAIL		0x40
+/* Status: HT is ready */
+#define SBSDIO_HT_AVAIL			0x80
+#define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
+#define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
+#define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
+#define SBSDIO_ALPONLY(regval)	(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
+#define SBSDIO_CLKAV(regval, alponly) \
+	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
+
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
-- 
1.7.4.1


