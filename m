Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0118.outbound.protection.outlook.com ([104.47.32.118]:5507
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932857AbdLSG4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 01:56:44 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Double Lo <double.lo@cypress.com>
Subject: [PATCH v2] brcmfmac: Support 43455 save-restore (SR) feature if FW include -sr
Date: Tue, 19 Dec 2017 14:56:44 +0800
Message-Id: <1513666604-24592-1-git-send-email-wright.feng@cypress.com> (sfid-20171219_075648_969359_B26FD195)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Double Lo <double.lo@cypress.com>

This patch will add 43455 into the save-restore(SR) capable chip list, so
the SR engine will be enabled with 43455 FW which built-in the -sr
function.

Signed-off-by: Double Lo <double.lo@cypress.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: Add Wright's signed-off-by
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index c5d1a1c..f7b30ce 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1338,6 +1338,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 	switch (pub->chip) {
 	case BRCM_CC_4354_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
+	case BRCM_CC_4345_CHIP_ID:
 		/* explicitly check SR engine enable bit */
 		pmu_cc3_mask = BIT(2);
 		/* fall-through */
-- 
1.9.1
