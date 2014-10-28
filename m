Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38564 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaJ1OAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/16] brcmfmac: (clean) Rename sdio related files.
Date: Tue, 28 Oct 2014 14:56:17 +0100
Message-ID: <1414504579-12562-15-git-send-email-arend@broadcom.com> (sfid-20141028_150110_066577_491B8E63)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Rename sdio_host.h to sdio.h and dhd_sdio.c to sdio.c.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/of.c                    | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_sdio.c => sdio.c}  | 4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/{sdio_host.h => sdio.h} | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_sdio.c => sdio.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{sdio_host.h => sdio.h} (99%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 35b680550..40ba46b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -43,7 +43,7 @@ brcmfmac-$(CONFIG_BRCMFMAC_PROTO_MSGBUF) += \
 		flowring.o \
 		msgbuf.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
-		dhd_sdio.o \
+		sdio.o \
 		bcmsdh.o
 brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 		usb.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 969bdd6..f754ffc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -43,7 +43,7 @@
 #include "chip.h"
 #include "bus.h"
 #include "debug.h"
-#include "sdio_host.h"
+#include "sdio.h"
 #include "of.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
index 875060c..eb3fce82 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -22,7 +22,7 @@
 
 #include <defs.h>
 #include "debug.h"
-#include "sdio_host.h"
+#include "sdio.h"
 
 void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
rename to drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 224e922..73ac0c3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -40,7 +40,7 @@
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
 #include <soc.h>
-#include "sdio_host.h"
+#include "sdio.h"
 #include "chip.h"
 #include "firmware.h"
 
@@ -4076,7 +4076,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	/* platform specific configuration:
 	 *   alignments must be at least 4 bytes for ADMA
-         */
+	 */
 	bus->head_align = ALIGNMENT;
 	bus->sgentry_align = ALIGNMENT;
 	if (sdiodev->pdata) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
rename to drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index 262aedf..8eb4262 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_BRCM_SDH_H_
-#define	_BRCM_SDH_H_
+#ifndef	BRCMFMAC_SDIO_H
+#define	BRCMFMAC_SDIO_H
 
 #include <linux/skbuff.h>
 #include <linux/firmware.h>
@@ -337,4 +337,4 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus);
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
 
-#endif				/* _BRCM_SDH_H_ */
+#endif /* BRCMFMAC_SDIO_H */
-- 
1.9.1

