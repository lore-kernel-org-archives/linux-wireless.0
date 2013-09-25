Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2566 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab3IYLF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:05:58 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: Use fw filename and nvram based of devid
 for sdio.
Date: Wed, 25 Sep 2013 13:05:45 +0200
Message-ID: <1380107146-24026-7-git-send-email-arend@broadcom.com> (sfid-20130925_130602_546372_D3131B96)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SDIO firmware download routines uses one name for firmware file
and nvram file for all sdio devices. This is not user friendly.
Use fw filename and nvram filename based upon chip id and revision.

Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  207 +++++++++++++-------
 1 file changed, 133 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f9ba4d0..6e72b73 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -275,11 +275,6 @@ struct rte_console {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
-#define BRCMF_SDIO_FW_NAME	"brcm/brcmfmac-sdio.bin"
-#define BRCMF_SDIO_NV_NAME	"brcm/brcmfmac-sdio.txt"
-MODULE_FIRMWARE(BRCMF_SDIO_FW_NAME);
-MODULE_FIRMWARE(BRCMF_SDIO_NV_NAME);
-
 #define BRCMF_IDLE_IMMEDIATE	(-1)	/* Enter idle immediately */
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 					 * when idle
@@ -454,9 +449,6 @@ struct brcmf_sdio {
 	struct work_struct datawork;
 	atomic_t dpc_tskcnt;
 
-	const struct firmware *firmware;
-	u32 fw_ptr;
-
 	bool txoff;		/* Transmit flow-controlled */
 	struct brcmf_sdio_count sdcnt;
 	bool sr_enabled; /* SaveRestore enabled */
@@ -493,6 +485,100 @@ enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_SUB,
 };
 
+#define BCM43143_FIRMWARE_NAME		"brcm/brcmfmac43143-sdio.bin"
+#define BCM43143_NVRAM_NAME		"brcm/brcmfmac43143-sdio.txt"
+#define BCM43241B0_FIRMWARE_NAME	"brcm/brcmfmac43241b0-sdio.bin"
+#define BCM43241B0_NVRAM_NAME		"brcm/brcmfmac43241b0-sdio.txt"
+#define BCM43241B4_FIRMWARE_NAME	"brcm/brcmfmac43241b4-sdio.bin"
+#define BCM43241B4_NVRAM_NAME		"brcm/brcmfmac43241b4-sdio.txt"
+#define BCM4329_FIRMWARE_NAME		"brcm/brcmfmac4329-sdio.bin"
+#define BCM4329_NVRAM_NAME		"brcm/brcmfmac4329-sdio.txt"
+#define BCM4330_FIRMWARE_NAME		"brcm/brcmfmac4330-sdio.bin"
+#define BCM4330_NVRAM_NAME		"brcm/brcmfmac4330-sdio.txt"
+#define BCM4334_FIRMWARE_NAME		"brcm/brcmfmac4334-sdio.bin"
+#define BCM4334_NVRAM_NAME		"brcm/brcmfmac4334-sdio.txt"
+#define BCM4335_FIRMWARE_NAME		"brcm/brcmfmac4335-sdio.bin"
+#define BCM4335_NVRAM_NAME		"brcm/brcmfmac4335-sdio.txt"
+
+MODULE_FIRMWARE(BCM43143_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43143_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43241B0_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43241B0_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43241B4_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43241B4_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4329_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4329_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4330_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4330_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4334_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4334_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4335_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4335_NVRAM_NAME);
+
+struct brcmf_firmware_names {
+	u32 chipid;
+	u32 revmsk;
+	const char *bin;
+	const char *nv;
+};
+
+enum brcmf_firmware_type {
+	BRCMF_FIRMWARE_BIN,
+	BRCMF_FIRMWARE_NVRAM
+};
+
+#define BRCMF_FIRMWARE_NVRAM(name) \
+	name ## _FIRMWARE_NAME, name ## _NVRAM_NAME
+
+static const struct brcmf_firmware_names brcmf_fwname_data[] = {
+	{ BCM43143_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43143) },
+	{ BCM43241_CHIP_ID, 0x0000001F, BRCMF_FIRMWARE_NVRAM(BCM43241B0) },
+	{ BCM43241_CHIP_ID, 0xFFFFFFE0, BRCMF_FIRMWARE_NVRAM(BCM43241B4) },
+	{ BCM4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
+	{ BCM4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
+	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
+	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) }
+};
+
+
+static const struct firmware *brcmf_sdbrcm_get_fw(struct brcmf_sdio *bus,
+						  enum brcmf_firmware_type type)
+{
+	const struct firmware *fw;
+	const char *name;
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_fwname_data); i++) {
+		if (brcmf_fwname_data[i].chipid == bus->ci->chip &&
+		    brcmf_fwname_data[i].revmsk & BIT(bus->ci->chiprev)) {
+			switch (type) {
+			case BRCMF_FIRMWARE_BIN:
+				name = brcmf_fwname_data[i].bin;
+				break;
+			case BRCMF_FIRMWARE_NVRAM:
+				name = brcmf_fwname_data[i].nv;
+				break;
+			default:
+				brcmf_err("invalid firmware type (%d)\n", type);
+				return NULL;
+			}
+			goto found;
+		}
+	}
+	brcmf_err("Unknown chipid %d [%d]\n",
+		  bus->ci->chip, bus->ci->chiprev);
+	return NULL;
+
+found:
+	err = request_firmware(&fw, name, &bus->sdiodev->func[2]->dev);
+	if ((err) || (!fw)) {
+		brcmf_err("fail to request firmware %s (%d)\n", name, err);
+		return NULL;
+	}
+
+	return fw;
+}
+
 static void pkt_align(struct sk_buff *p, int len, int align)
 {
 	uint datalign;
@@ -3042,69 +3128,43 @@ static bool brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 	return true;
 }
 
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_sdio *bus)
-{
-	if (bus->firmware->size < bus->fw_ptr + len)
-		len = bus->firmware->size - bus->fw_ptr;
-
-	memcpy(buf, &bus->firmware->data[bus->fw_ptr], len);
-	bus->fw_ptr += len;
-	return len;
-}
-
 static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 {
+	const struct firmware *fw;
+	int err;
 	int offset;
-	uint len;
-	u8 *memblock = NULL, *memptr;
-	int ret;
-	u8 idx;
-
-	brcmf_dbg(INFO, "Enter\n");
-
-	ret = request_firmware(&bus->firmware, BRCMF_SDIO_FW_NAME,
-			       &bus->sdiodev->func[2]->dev);
-	if (ret) {
-		brcmf_err("Fail to request firmware %d\n", ret);
-		return ret;
-	}
-	bus->fw_ptr = 0;
-
-	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
-	if (memblock == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
-		memptr += (BRCMF_SDALIGN -
-			   ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
-
-	offset = bus->ci->rambase;
-
-	/* Download image */
-	len = brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus);
-	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_ARM_CR4);
-	if (BRCMF_MAX_CORENUM != idx)
-		memcpy(&bus->ci->rst_vec, memptr, sizeof(bus->ci->rst_vec));
-	while (len) {
-		ret = brcmf_sdio_ramrw(bus->sdiodev, true, offset, memptr, len);
-		if (ret) {
+	int address;
+	int len;
+
+	fw = brcmf_sdbrcm_get_fw(bus, BRCMF_FIRMWARE_BIN);
+	if (fw == NULL)
+		return -ENOENT;
+
+	if (brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_ARM_CR4) !=
+	    BRCMF_MAX_CORENUM)
+		memcpy(&bus->ci->rst_vec, fw->data, sizeof(bus->ci->rst_vec));
+
+	err = 0;
+	offset = 0;
+	address = bus->ci->rambase;
+	while (offset < fw->size) {
+		len = ((offset + MEMBLOCK) < fw->size) ? MEMBLOCK :
+		      fw->size - offset;
+		err = brcmf_sdio_ramrw(bus->sdiodev, true, address,
+				       (u8 *)&fw->data[offset], len);
+		if (err) {
 			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
-				  ret, MEMBLOCK, offset);
-			goto err;
+				  err, len, address);
+			goto failure;
 		}
-
-		offset += MEMBLOCK;
-		len = brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus);
+		offset += len;
+		address += len;
 	}
 
-err:
-	kfree(memblock);
-
-	release_firmware(bus->firmware);
-	bus->fw_ptr = 0;
+failure:
+	release_firmware(fw);
 
-	return ret;
+	return err;
 }
 
 /*
@@ -3116,7 +3176,8 @@ err:
  * by two NULs.
 */
 
-static int brcmf_process_nvram_vars(struct brcmf_sdio *bus)
+static int brcmf_process_nvram_vars(struct brcmf_sdio *bus,
+				    const struct firmware *nv)
 {
 	char *varbuf;
 	char *dp;
@@ -3125,12 +3186,12 @@ static int brcmf_process_nvram_vars(struct brcmf_sdio *bus)
 	int ret = 0;
 	uint buf_len, n, len;
 
-	len = bus->firmware->size;
+	len = nv->size;
 	varbuf = vmalloc(len);
 	if (!varbuf)
 		return -ENOMEM;
 
-	memcpy(varbuf, bus->firmware->data, len);
+	memcpy(varbuf, nv->data, len);
 	dp = varbuf;
 
 	findNewline = false;
@@ -3182,18 +3243,16 @@ err:
 
 static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 {
+	const struct firmware *nv;
 	int ret;
 
-	ret = request_firmware(&bus->firmware, BRCMF_SDIO_NV_NAME,
-			       &bus->sdiodev->func[2]->dev);
-	if (ret) {
-		brcmf_err("Fail to request nvram %d\n", ret);
-		return ret;
-	}
+	nv = brcmf_sdbrcm_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
+	if (nv == NULL)
+		return -ENOENT;
 
-	ret = brcmf_process_nvram_vars(bus);
+	ret = brcmf_process_nvram_vars(bus, nv);
 
-	release_firmware(bus->firmware);
+	release_firmware(nv);
 
 	return ret;
 }
-- 
1.7.10.4


