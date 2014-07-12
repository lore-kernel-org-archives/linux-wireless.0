Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2887 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaGLGtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:46 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/9] brcmfmac: Make firmware path a module parameter
Date: Sat, 12 Jul 2014 08:49:37 +0200
Message-ID: <1405147782-12768-5-git-send-email-arend@broadcom.com> (sfid-20140712_085002_359741_A1087D4F)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

This patch makes firmware path a module parameter so that firmware and
nvram files can be loaded from the specified path.

Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 47 +++++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  5 +++
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h |  5 +++
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |  4 ++
 4 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c048632..67d91d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -666,28 +666,34 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
-static const char *brcmf_sdio_get_fwname(struct brcmf_chip *ci,
-					 enum brcmf_firmware_type type)
+static int brcmf_sdio_get_fwnames(struct brcmf_chip *ci,
+				  struct brcmf_sdio_dev *sdiodev)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(brcmf_fwname_data); i++) {
 		if (brcmf_fwname_data[i].chipid == ci->chip &&
-		    brcmf_fwname_data[i].revmsk & BIT(ci->chiprev)) {
-			switch (type) {
-			case BRCMF_FIRMWARE_BIN:
-				return brcmf_fwname_data[i].bin;
-			case BRCMF_FIRMWARE_NVRAM:
-				return brcmf_fwname_data[i].nv;
-			default:
-				brcmf_err("invalid firmware type (%d)\n", type);
-				return NULL;
-			}
-		}
+		    brcmf_fwname_data[i].revmsk & BIT(ci->chiprev))
+			break;
 	}
-	brcmf_err("Unknown chipid %d [%d]\n",
-		  ci->chip, ci->chiprev);
-	return NULL;
+
+	if (i == ARRAY_SIZE(brcmf_fwname_data)) {
+		brcmf_err("Unknown chipid %d [%d]\n", ci->chip, ci->chiprev);
+		return -ENODEV;
+	}
+
+	/* check if firmware path is provided by module parameter */
+	if (brcmf_firmware_path[0] != '\0') {
+		if (brcmf_firmware_path[strlen(brcmf_firmware_path) - 1] != '/')
+			strcat(brcmf_firmware_path, "/");
+
+		strcpy(sdiodev->fw_name, brcmf_firmware_path);
+		strcpy(sdiodev->nvram_name, brcmf_firmware_path);
+	}
+	strcat(sdiodev->fw_name, brcmf_fwname_data[i].bin);
+	strcat(sdiodev->nvram_name, brcmf_fwname_data[i].nv);
+
+	return 0;
 }
 
 static void pkt_align(struct sk_buff *p, int len, int align)
@@ -4160,11 +4166,12 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
+	ret = brcmf_sdio_get_fwnames(bus->ci, sdiodev);
+	if (ret)
+		goto fail;
+
 	ret = brcmf_fw_get_firmwares(sdiodev->dev, BRCMF_FW_REQUEST_NVRAM,
-				     brcmf_sdio_get_fwname(bus->ci,
-							   BRCMF_FIRMWARE_BIN),
-				     brcmf_sdio_get_fwname(bus->ci,
-							   BRCMF_FIRMWARE_NVRAM),
+				     sdiodev->fw_name, sdiodev->nvram_name,
 				     brcmf_sdio_firmware_callback);
 	if (ret != 0) {
 		brcmf_err("async firmware request failed: %d\n", ret);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 7b7d237..8ea9f28 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -18,10 +18,15 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/module.h>
 
 #include "dhd_dbg.h"
 #include "firmware.h"
 
+char brcmf_firmware_path[BRCMF_FW_PATH_LEN];
+module_param_string(firmware_path, brcmf_firmware_path,
+		    BRCMF_FW_PATH_LEN, 0440);
+
 enum nvram_parser_state {
 	IDLE,
 	KEY,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
index 6431bfd..4d34823 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
@@ -21,6 +21,11 @@
 #define BRCMF_FW_REQ_FLAGS		0x00F0
 #define  BRCMF_FW_REQ_NV_OPTIONAL	0x0010
 
+#define	BRCMF_FW_PATH_LEN	256
+#define	BRCMF_FW_NAME_LEN	32
+
+extern char brcmf_firmware_path[];
+
 void brcmf_fw_nvram_free(void *nvram);
 /*
  * Request firmware(s) asynchronously. When the asynchronous request
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 3deab79..6c5e585 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -18,6 +18,8 @@
 #define	_BRCM_SDH_H_
 
 #include <linux/skbuff.h>
+#include <linux/firmware.h>
+#include "firmware.h"
 
 #define SDIO_FUNC_0		0
 #define SDIO_FUNC_1		1
@@ -182,6 +184,8 @@ struct brcmf_sdio_dev {
 	uint max_segment_size;
 	uint txglomsz;
 	struct sg_table sgtable;
+	char fw_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
+	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 };
 
 /* sdio core registers */
-- 
1.9.1

