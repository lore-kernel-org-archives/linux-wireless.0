Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50227 "EHLO
        mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932337AbcIEKmT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 06:42:19 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: sdio: shorten retry loop in brcmf_sdio_kso_control()
Date: Mon,  5 Sep 2016 11:42:13 +0100
Message-Id: <1473072133-4266-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160905_124226_842337_93F4ABAC)
In-Reply-To: <1473072133-4266-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1473072133-4266-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_sdio_kso_control() there is a retry loop as hardware may take
time to settle. However, when the call to brcmf_sdiod_regrb() returns
an error it is due to SDIO access failure and it makes no sense to wait
for hardware to settle. This patch aborts the loop after a number of
subsequent access errors.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 589a49c..b892dac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -313,6 +313,7 @@ struct rte_console {
 
 #define KSO_WAIT_US 50
 #define MAX_KSO_ATTEMPTS (PMU_MAX_TRANSITION_DLY/KSO_WAIT_US)
+#define BRCMF_SDIO_MAX_ACCESS_ERRORS	5
 
 /*
  * Conversion of 802.1D priority to precedence level
@@ -677,6 +678,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 {
 	u8 wr_val = 0, rd_val, cmp_val, bmask;
 	int err = 0;
+	int err_cnt = 0;
 	int try_cnt = 0;
 
 	brcmf_dbg(TRACE, "Enter: on=%d\n", on);
@@ -712,9 +714,14 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		 */
 		rd_val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 					   &err);
-		if (((rd_val & bmask) == cmp_val) && !err)
+		if (!err) {
+			if ((rd_val & bmask) == cmp_val)
+				break;
+			err_cnt = 0;
+		}
+		/* bail out upon subsequent access errors */
+		if (err && (err_cnt++ > BRCMF_SDIO_MAX_ACCESS_ERRORS))
 			break;
-
 		udelay(KSO_WAIT_US);
 		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 				  wr_val, &err);
-- 
1.9.1
