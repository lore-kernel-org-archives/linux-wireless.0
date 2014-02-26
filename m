Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38353 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaBZMcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 07:32:41 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 10/14] brcmfmac: Use atomic functions for intstatus update.
Date: Wed, 26 Feb 2014 13:32:32 +0100
Message-ID: <1393417952-7594-1-git-send-email-arend@broadcom.com> (sfid-20140226_133246_063290_77833673)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The intstatus in sdio code can be updated from different
threads. To protect intstatus access, atomic functions are
used. The loop was replaced using atomic_set_mask().

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ac61419..0ccb7af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2449,7 +2449,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	struct brcmf_core *buscore;
 	u32 addr;
 	unsigned long val;
-	int n, ret;
+	int ret;
 
 	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
@@ -2457,7 +2457,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
-		val = 0;
+		return ret;
 
 	val &= bus->hostintmask;
 	atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
@@ -2466,13 +2466,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	if (val) {
 		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
-	}
-
-	if (ret) {
-		atomic_set(&bus->intstatus, 0);
-	} else if (val) {
-		for_each_set_bit(n, &val, 32)
-			set_bit(n, (unsigned long *)&bus->intstatus.counter);
+		atomic_set_mask(val, &bus->intstatus);
 	}
 
 	return ret;
@@ -2484,7 +2478,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt;			/* Temporary counter of tx/rx frames */
-	int err = 0, n;
+	int err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2588,10 +2582,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Keep still-pending events for next scheduling */
-	if (intstatus) {
-		for_each_set_bit(n, &intstatus, 32)
-			set_bit(n, (unsigned long *)&bus->intstatus.counter);
-	}
+	if (intstatus)
+		atomic_set_mask(intstatus, &bus->intstatus);
 
 	brcmf_sdio_clrintr(bus);
 
-- 
1.7.10.4

