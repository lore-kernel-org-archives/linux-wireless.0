Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1562 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab2BIUJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/15] brcm80211: fmac: make sdio firmware filename
 specific
Date: Thu, 9 Feb 2012 21:09:09 +0100
Message-ID: <1328818149-4826-16-git-send-email-arend@broadcom.com> (sfid-20120209_211017_651335_52BBF119)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio driver part uses firmware name brcmfmac.bin. With addition
of usb this name is too generic. This patch renames the filename
to brcmfmac-sdio.bin.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 253fc20..0b467b0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -309,10 +309,10 @@ struct rte_console {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
-#define BRCMFMAC_FW_NAME	"brcm/brcmfmac.bin"
-#define BRCMFMAC_NV_NAME	"brcm/brcmfmac.txt"
-MODULE_FIRMWARE(BRCMFMAC_FW_NAME);
-MODULE_FIRMWARE(BRCMFMAC_NV_NAME);
+#define BRCMF_SDIO_FW_NAME	"brcm/brcmfmac-sdio.bin"
+#define BRCMF_SDIO_NV_NAME	"brcm/brcmfmac-sdio.txt"
+MODULE_FIRMWARE(BRCMF_SDIO_FW_NAME);
+MODULE_FIRMWARE(BRCMF_SDIO_NV_NAME);
 
 #define BRCMF_IDLE_IMMEDIATE	(-1)	/* Enter idle immediately */
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
@@ -3202,7 +3202,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 
 	brcmf_dbg(INFO, "Enter\n");
 
-	ret = request_firmware(&bus->firmware, BRCMFMAC_FW_NAME,
+	ret = request_firmware(&bus->firmware, BRCMF_SDIO_FW_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
@@ -3299,7 +3299,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 	char *bufp;
 	int ret;
 
-	ret = request_firmware(&bus->firmware, BRCMFMAC_NV_NAME,
+	ret = request_firmware(&bus->firmware, BRCMF_SDIO_NV_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
-- 
1.7.5.4


