Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16710 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbbCRMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: Remove unnecessary new-line in pcie console logging.
Date: Wed, 18 Mar 2015 13:25:24 +0100
Message-ID: <1426681528-15831-5-git-send-email-arend@broadcom.com> (sfid-20150318_132544_304889_6C1D8E16)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index aa7a4df..ec426f3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -651,10 +651,9 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
 			console->log_str[console->log_idx] = ch;
 			console->log_idx++;
 		}
-
 		if (ch == '\n') {
 			console->log_str[console->log_idx] = 0;
-			brcmf_dbg(PCIE, "CONSOLE: %s\n", console->log_str);
+			brcmf_dbg(PCIE, "CONSOLE: %s", console->log_str);
 			console->log_idx = 0;
 		}
 	}
-- 
1.9.1

