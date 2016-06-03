Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16427 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbcFCVbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:23 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wrightf <wright.feng@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: revise SDIO error message in brcmf_sdio_drivestrengthinit
Date: Fri,  3 Jun 2016 23:31:08 +0200
Message-Id: <1464989472-29684-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233126_762769_BB1895AF)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: wrightf <wright.feng@broadcom.com>

The error message is given for something that is not an error here as
the drive strength configuration may not be applicable for specific
devices. Therefor the error message is rephrased and changed to a
debug message.

Signed-off-by: Wright Feng <wright.feng@broadcom.com>
[arend@broadcom.com: rephrase commit message]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 67e69bf..22b7dc0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3666,7 +3666,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		str_shift = 11;
 		break;
 	default:
-		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+		brcmf_dbg(INFO, "No SDIO driver strength init needed for chip %s rev %d pmurev %d\n",
 			  ci->name, ci->chiprev, ci->pmurev);
 		break;
 	}
-- 
1.9.1

