Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2344 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 21/30] brcm80211: fmac: move sdio related macros to
 sdio_host.h
Date: Fri, 16 Dec 2011 18:37:11 -0800
Message-ID: <1324089440-8957-22-git-send-email-frankyl@broadcom.com> (sfid-20111217_033746_385477_574E1618)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dhd_bus.h will be used as the shared header file for common layer
and bus layer. It should not contain any sdio specific macros.
This patch moves them to sdio_host.h as part of the fullmac bus
interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    6 ------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    7 ++++---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 ++++++
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b895f19..0b0eb4f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -488,6 +488,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev->bus_if = bus_if;
 		bus_if->bus_priv = sdiodev;
 		bus_if->type = SDIO_BUS;
+		bus_if->align = BRCMF_SDALIGN;
 		dev_set_drvdata(&func->card->dev, sdiodev);
 
 		atomic_set(&sdiodev->suspend, false);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 5d0be12..30cc417 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -580,6 +580,7 @@ struct brcmf_bus {
 	bool drvr_up;		/* Status flag of driver up/down */
 	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
 	struct dngl_stats dstats;	/* Stats for dongle-based data */
+	u8 align;		/* bus alignment requirement */
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 1b34877..413ba21 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -17,12 +17,6 @@
 #ifndef _BRCMF_BUS_H_
 #define _BRCMF_BUS_H_
 
-/* Packet alignment for most efficient SDIO (can change based on platform) */
-#define BRCMF_SDALIGN	(1 << 6)
-
-/* watchdog polling interval in ms */
-#define BRCMF_WD_POLL_MS	10
-
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 8b4dba3..65c948e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -82,13 +82,14 @@ struct brcmf_proto_bdc_header {
 
 
 #define RETRIES 2 /* # of retries to retrieve matching dcmd response */
-#define BUS_HEADER_LEN	(16+BRCMF_SDALIGN) /* Must be atleast SDPCM_RESERVE
+#define BUS_HEADER_LEN	(16+64)		/* Must be atleast SDPCM_RESERVE
 					 * (amount of header tha might be added)
 					 * plus any space that might be needed
-					 * for alignment padding.
+					 * for bus alignment padding.
 					 */
-#define ROUND_UP_MARGIN	2048	/* Biggest SDIO block size possible for
+#define ROUND_UP_MARGIN	2048	/* Biggest bus block size possible for
 				 * round off at the end of buffer
+				 * Currently is SDIO
 				 */
 
 struct brcmf_proto {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 279ae76..a51d8f5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -798,7 +798,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 				 "event_msgs" + '\0' + bitvec  */
 	uint up = 0;
 	char buf[128], *ptr;
-	u32 dongle_align = BRCMF_SDALIGN;
+	u32 dongle_align = drvr->bus_if->align;
 	u32 glom = 0;
 	u32 roaming = 1;
 	uint bcn_timeout = 3;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index a63490e..0281d20 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -116,6 +116,12 @@
 #define SUCCESS	0
 #define ERROR	1
 
+/* Packet alignment for most efficient SDIO (can change based on platform) */
+#define BRCMF_SDALIGN	(1 << 6)
+
+/* watchdog polling interval in ms */
+#define BRCMF_WD_POLL_MS	10
+
 struct brcmf_sdreg {
 	int func;
 	int offset;
-- 
1.7.5.4


