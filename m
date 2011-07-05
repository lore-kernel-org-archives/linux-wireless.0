Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2954 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/31] staging: brcm80211: removed asserts from two
 fullmac files
Date: Wed, 6 Jul 2011 00:02:32 +0200
Message-ID: <1309903378-29021-6-git-send-email-arend@broadcom.com> (sfid-20110706_000321_874548_C889A4A7)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

ASSERTs are non desirable, replaced by error handling where applicable.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   37 +++++++-------------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 -
 2 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 3f3f0ee..76a2c8b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -279,12 +279,16 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 	bool bool_val;
 	u32 actionid;
 
-	ASSERT(name);
-	ASSERT(len >= 0);
+	if (name == NULL || len <= 0)
+		return -EINVAL;
 
-	/* Get must have return space; Set does not take qualifiers */
-	ASSERT(set || (arg && len));
-	ASSERT(!set || (!params && !plen));
+	/* Set does not take qualifiers */
+	if (set && (params || plen))
+		return -EINVAL;
+
+	/* Get must have return space;*/
+	if (!set && !(arg && len))
+		return -EINVAL;
 
 	sd_trace(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
 		  name));
@@ -676,7 +680,6 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 
 	sd_trace(("%s: Enter\n", __func__));
 
-	ASSERT(pkt);
 	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 
@@ -687,14 +690,6 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 		pkt_len += 3;
 		pkt_len &= 0xFFFFFFFC;
 
-		/* Make sure the packet is aligned properly.
-		 * If it isn't, then this
-		 * is the fault of brcmf_sdioh_request_buffer() which
-		 * is supposed to give
-		 * us something we can work with.
-		 */
-		ASSERT(((ulong) (pkt->data) & DMA_ALIGN_MASK) == 0);
-
 		if ((write) && (!fifo)) {
 			err_ret = sdio_memcpy_toio(gInstance->func[func], addr,
 						   ((u8 *) (pnext->data)),
@@ -789,11 +784,10 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 
 		brcmu_pkt_buf_free_skb(mypkt);
 	} else if (((ulong) (pkt->data) & DMA_ALIGN_MASK) != 0) {
-		/* Case 2: We have a packet, but it is unaligned. */
-
-		/* In this case, we cannot have a chain. */
-		ASSERT(pkt->next == NULL);
-
+		/*
+		 * Case 2: We have a packet, but it is unaligned.
+		 * In this case, we cannot have a chain (pkt->next == NULL)
+		 */
 		sd_data(("%s: Creating aligned %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", pkt->len));
 		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
@@ -886,13 +880,10 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 	sd_trace(("brcmf: ***IRQHandler\n"));
 	sd = gInstance->sd;
 
-	ASSERT(sd != NULL);
 	sdio_release_host(gInstance->func[0]);
 
 	if (sd->use_client_ints) {
 		sd->intrcount++;
-		ASSERT(sd->intr_handler);
-		ASSERT(sd->intr_handler_arg);
 		(sd->intr_handler) (sd->intr_handler_arg);
 	} else {
 		sd_err(("brcmf: ***IRQHandler\n"));
@@ -912,6 +903,4 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 	sd_trace(("brcmf: ***IRQHandlerF2\n"));
 
 	sd = gInstance->sd;
-
-	ASSERT(sd != NULL);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index e229bcb..7d4b2e3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -194,7 +194,6 @@ int brcmf_sdioh_osinit(struct sdioh_info *sd)
 void brcmf_sdioh_osfree(struct sdioh_info *sd)
 {
 	struct sdos_info *sdos;
-	ASSERT(sd && sd->sdos_info);
 
 	sdos = (struct sdos_info *)sd->sdos_info;
 	kfree(sdos);
@@ -209,7 +208,6 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 	sd_trace(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
 
 	sdos = (struct sdos_info *)sd->sdos_info;
-	ASSERT(sdos);
 
 	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
 		sd_err(("%s: no handler registered, will not enable\n",
-- 
1.7.4.1


