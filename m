Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53580 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbbETMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: remove pci shared structure rev4 support
Date: Wed, 20 May 2015 14:09:49 +0200
Message-ID: <1432123792-4155-4-git-send-email-arend@broadcom.com> (sfid-20150520_141001_286525_3F2F23A3)
In-Reply-To: <1432123792-4155-1-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

All pcie full dongle chips supported by fmac are using rev 5+ shared
structure. This patch removes the rev4 related code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 79ca24e..6ca3037 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -112,10 +112,9 @@ enum brcmf_pcie_state {
 						 BRCMF_PCIE_MB_INT_D2H3_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H3_DB1)
 
-#define BRCMF_PCIE_MIN_SHARED_VERSION		4
+#define BRCMF_PCIE_MIN_SHARED_VERSION		5
 #define BRCMF_PCIE_MAX_SHARED_VERSION		5
 #define BRCMF_PCIE_SHARED_VERSION_MASK		0x00FF
-#define BRCMF_PCIE_SHARED_TXPUSH_SUPPORT	0x4000
 
 #define BRCMF_PCIE_FLAGS_HTOD_SPLIT		0x4000
 #define BRCMF_PCIE_FLAGS_DTOH_SPLIT		0x8000
@@ -1280,11 +1279,6 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 		brcmf_err("Unsupported PCIE version %d\n", version);
 		return -EINVAL;
 	}
-	if (shared->flags & BRCMF_PCIE_SHARED_TXPUSH_SUPPORT) {
-		brcmf_err("Unsupported legacy TX mode 0x%x\n",
-			  shared->flags & BRCMF_PCIE_SHARED_TXPUSH_SUPPORT);
-		return -EINVAL;
-	}
 
 	addr = sharedram_addr + BRCMF_SHARED_MAX_RXBUFPOST_OFFSET;
 	shared->max_rxbufpost = brcmf_pcie_read_tcm16(devinfo, addr);
-- 
1.9.1

