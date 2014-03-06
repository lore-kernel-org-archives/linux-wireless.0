Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54111 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCFJQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 04:16:21 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: Use atomic functions for intstatus update.
Date: Thu, 6 Mar 2014 10:16:12 +0100
Message-ID: <1394097372-4643-3-git-send-email-arend@broadcom.com> (sfid-20140306_101633_653542_096A8AEE)
In-Reply-To: <1394097372-4643-1-git-send-email-arend@broadcom.com>
References: <1394097372-4643-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The intstatus in sdio code can be updated from different
threads. To protect intstatus access, atomic functions are
used. One of them is set_bit, but this function is not
guaranteed atomic on all platforms. The loop was replaced
with local created OR function.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++++++++++----------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 70bab5e..a111b6f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2439,12 +2439,21 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 	}
 }
 
+static void atomic_orr(int val, atomic_t *v)
+{
+	int old_val;
+
+	old_val = atomic_read(v);
+	while (atomic_cmpxchg(v, old_val, val | old_val) != old_val)
+		old_val = atomic_read(v);
+}
+
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
 	struct brcmf_core *buscore;
 	u32 addr;
 	unsigned long val;
-	int n, ret;
+	int ret;
 
 	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
@@ -2452,7 +2461,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
-		val = 0;
+		return ret;
 
 	val &= bus->hostintmask;
 	atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
@@ -2461,13 +2470,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
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
+		atomic_orr(val, &bus->intstatus);
 	}
 
 	return ret;
@@ -2479,7 +2482,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt;			/* Temporary counter of tx/rx frames */
-	int err = 0, n;
+	int err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2583,10 +2586,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Keep still-pending events for next scheduling */
-	if (intstatus) {
-		for_each_set_bit(n, &intstatus, 32)
-			set_bit(n, (unsigned long *)&bus->intstatus.counter);
-	}
+	if (intstatus)
+		atomic_orr(intstatus, &bus->intstatus);
 
 	brcmf_sdio_clrintr(bus);
 
-- 
1.7.10.4

