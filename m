Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59323 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/16] brcmfmac: rename nvram.[ch] for upcoming firmware handling functions
Date: Tue, 27 May 2014 12:56:17 +0200
Message-ID: <1401188188-16492-6-git-send-email-arend@broadcom.com> (sfid-20140527_125649_796142_D12F156D)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware processing will be modified to use asynchronous request
firmware api. In preparation this patch is simple rename of source
and header file to which the functionality will be added.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 +++---
 .../brcm80211/brcmfmac/{nvram.c => firmware.c}     |    6 +++---
 .../brcm80211/brcmfmac/{nvram.h => firmware.h}     |   10 +++++-----
 4 files changed, 12 insertions(+), 12 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{nvram.c => firmware.c} (97%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{nvram.h => firmware.h} (79%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 1d2ceac..98e67c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -33,7 +33,7 @@ brcmfmac-objs += \
 		bcdc.o \
 		dhd_common.o \
 		dhd_linux.o \
-		nvram.o \
+		firmware.o \
 		btcoex.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 494371c..010e1bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -42,7 +42,7 @@
 #include <soc.h>
 #include "sdio_host.h"
 #include "chip.h"
-#include "nvram.h"
+#include "firmware.h"
 
 #define DCMD_RESP_TIMEOUT  2000	/* In milli second */
 
@@ -3287,7 +3287,7 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	vars = brcmf_nvram_strip(nv, &varsz);
+	vars = brcmf_fw_nvram_strip(nv, &varsz);
 
 	if (vars == NULL)
 		return -EINVAL;
@@ -3300,7 +3300,7 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 	else if (!brcmf_sdio_verifymemory(bus->sdiodev, address, vars, varsz))
 		err = -EIO;
 
-	brcmf_nvram_free(vars);
+	brcmf_fw_nvram_free(vars);
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/nvram.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
similarity index 97%
rename from drivers/net/wireless/brcm80211/brcmfmac/nvram.c
rename to drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 5c450d1..ff5b867 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/nvram.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -19,7 +19,7 @@
 #include <linux/firmware.h>
 
 #include "dhd_dbg.h"
-#include "nvram.h"
+#include "firmware.h"
 
 enum nvram_parser_state {
 	IDLE,
@@ -187,7 +187,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
  * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
  * End of buffer is completed with token identifying length of buffer.
  */
-void *brcmf_nvram_strip(const struct firmware *nv, u32 *new_length)
+void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length)
 {
 	struct nvram_parser nvp;
 	u32 pad;
@@ -219,7 +219,7 @@ void *brcmf_nvram_strip(const struct firmware *nv, u32 *new_length)
 	return nvp.nvram;
 }
 
-void brcmf_nvram_free(void *nvram)
+void brcmf_fw_nvram_free(void *nvram)
 {
 	kfree(nvram);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/nvram.h b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
similarity index 79%
rename from drivers/net/wireless/brcm80211/brcmfmac/nvram.h
rename to drivers/net/wireless/brcm80211/brcmfmac/firmware.h
index d454580..127633b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/nvram.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
@@ -13,12 +13,12 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#ifndef BRCMFMAC_NVRAM_H
-#define BRCMFMAC_NVRAM_H
+#ifndef BRCMFMAC_FIRMWARE_H
+#define BRCMFMAC_FIRMWARE_H
 
 
-void *brcmf_nvram_strip(const struct firmware *nv, u32 *new_length);
-void brcmf_nvram_free(void *nvram);
+void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length);
+void brcmf_fw_nvram_free(void *nvram);
 
 
-#endif /* BRCMFMAC_NVRAM_H */
+#endif /* BRCMFMAC_FIRMWARE_H */
-- 
1.7.9.5

