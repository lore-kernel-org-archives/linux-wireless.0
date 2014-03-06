Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34840 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCFJQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 04:16:21 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/2] Revert "brcmfmac: Use atomic functions for intstatus update."
Date: Thu, 6 Mar 2014 10:16:11 +0100
Message-ID: <1394097372-4643-2-git-send-email-arend@broadcom.com> (sfid-20140306_101631_096965_651939AF)
In-Reply-To: <1394097372-4643-1-git-send-email-arend@broadcom.com>
References: <1394097372-4643-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit c98db0bec72ac7ef127119c1ed962d6f56802b12.

The function atomic_set_mask() is not architecture independent
so it can not be used in the driver as is.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5c2706e..70bab5e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2444,7 +2444,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	struct brcmf_core *buscore;
 	u32 addr;
 	unsigned long val;
-	int ret;
+	int n, ret;
 
 	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
@@ -2452,7 +2452,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
-		return ret;
+		val = 0;
 
 	val &= bus->hostintmask;
 	atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
@@ -2461,7 +2461,13 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	if (val) {
 		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
-		atomic_set_mask(val, &bus->intstatus);
+	}
+
+	if (ret) {
+		atomic_set(&bus->intstatus, 0);
+	} else if (val) {
+		for_each_set_bit(n, &val, 32)
+			set_bit(n, (unsigned long *)&bus->intstatus.counter);
 	}
 
 	return ret;
@@ -2473,7 +2479,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt;			/* Temporary counter of tx/rx frames */
-	int err = 0;
+	int err = 0, n;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2577,8 +2583,10 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Keep still-pending events for next scheduling */
-	if (intstatus)
-		atomic_set_mask(intstatus, &bus->intstatus);
+	if (intstatus) {
+		for_each_set_bit(n, &intstatus, 32)
+			set_bit(n, (unsigned long *)&bus->intstatus.counter);
+	}
 
 	brcmf_sdio_clrintr(bus);
 
-- 
1.7.10.4

