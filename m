Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42579 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbbHZUPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:18 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: add dedicated debug level for firmware console logging
Date: Wed, 26 Aug 2015 22:15:01 +0200
Message-ID: <1440620104-2715-10-git-send-email-arend@broadcom.com> (sfid-20150826_221536_292908_062EC9CB)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both PCIe and SDIO devices have the possibility to log the firmware
console output in kernel log. For PCIe it is logged when PCIE debug
level is enabled. For SDIO it is logged when user specifies a non-zero
console interval through debugfs. This patch tries to make it a
bit more consistent. The firmware console output is only logged when
FWCON debug level is enabled.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Pontus Fuchs <pontusf@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/debug.h | 3 +++
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c  | 7 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c  | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
index eb0b8c4..48648ca 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
@@ -37,6 +37,7 @@
 #define BRCMF_SDIO_VAL		0x00020000
 #define BRCMF_MSGBUF_VAL	0x00040000
 #define BRCMF_PCIE_VAL		0x00080000
+#define BRCMF_FWCON_VAL		0x00100000
 
 /* set default print format */
 #undef pr_fmt
@@ -78,6 +79,7 @@ do {								\
 #define BRCMF_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
 #define BRCMF_EVENT_ON()	(brcmf_msg_level & BRCMF_EVENT_VAL)
 #define BRCMF_FIL_ON()		(brcmf_msg_level & BRCMF_FIL_VAL)
+#define BRCMF_FWCON_ON()	(brcmf_msg_level & BRCMF_FWCON_VAL)
 
 #else /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
 
@@ -90,6 +92,7 @@ do {								\
 #define BRCMF_GLOM_ON()		0
 #define BRCMF_EVENT_ON()	0
 #define BRCMF_FIL_ON()		0
+#define BRCMF_FWCON_ON()	0
 
 #endif /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 3a98c43..e75d04e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -644,7 +644,7 @@ static void brcmf_pcie_bus_console_init(struct brcmf_pciedev_info *devinfo)
 	addr = console->base_addr + BRCMF_CONSOLE_BUFSIZE_OFFSET;
 	console->bufsize = brcmf_pcie_read_tcm32(devinfo, addr);
 
-	brcmf_dbg(PCIE, "Console: base %x, buf %x, size %d\n",
+	brcmf_dbg(FWCON, "Console: base %x, buf %x, size %d\n",
 		  console->base_addr, console->buf_addr, console->bufsize);
 }
 
@@ -656,6 +656,9 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
 	u8 ch;
 	u32 newidx;
 
+	if (!BRCMF_FWCON_ON())
+		return;
+
 	console = &devinfo->shared.console;
 	addr = console->base_addr + BRCMF_CONSOLE_WRITEIDX_OFFSET;
 	newidx = brcmf_pcie_read_tcm32(devinfo, addr);
@@ -677,7 +680,7 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
 		}
 		if (ch == '\n') {
 			console->log_str[console->log_idx] = 0;
-			brcmf_dbg(PCIE, "CONSOLE: %s", console->log_str);
+			pr_debug("CONSOLE: %s", console->log_str);
 			console->log_idx = 0;
 		}
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index f990e3d..e41bf44 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -123,6 +123,7 @@ struct rte_console {
 
 #define BRCMF_FIRSTREAD	(1 << 6)
 
+#define BRCMF_CONSOLE	10	/* watchdog interval to poll console */
 
 /* SBSDIO_DEVICE_CTL */
 
@@ -3204,6 +3205,8 @@ static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 	if (IS_ERR_OR_NULL(dentry))
 		return;
 
+	bus->console_interval = BRCMF_CONSOLE;
+
 	brcmf_debugfs_add_entry(drvr, "forensics", brcmf_sdio_forensic_read);
 	brcmf_debugfs_add_entry(drvr, "counters",
 				brcmf_debugfs_sdio_count_read);
@@ -3613,7 +3616,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
-	if (bus->sdiodev->state == BRCMF_SDIOD_DATA &&
+	if (bus->sdiodev->state == BRCMF_SDIOD_DATA && BRCMF_FWCON_ON() &&
 	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
-- 
1.9.1

