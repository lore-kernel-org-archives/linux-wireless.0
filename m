Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43768 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752951AbdLHMKn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:43 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 03/10] brcmfmac: Clarify if using braces.
Date: Fri,  8 Dec 2017 13:10:28 +0100
Message-Id: <1512735035-342-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131058_837465_5AF624CE)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Whilst this if () statement is technically correct, it lacks clarity.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index bff4610..17cdc13 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -746,16 +746,17 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 	if (err)
 		return err;
 
-	if (pktq->qlen == 1 || !sdiodev->sg_support)
+	if (pktq->qlen == 1 || !sdiodev->sg_support) {
 		skb_queue_walk(pktq, skb) {
 			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
 						     addr, skb);
 			if (err)
 				break;
 		}
-	else
+	} else {
 		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, true, addr,
 					    pktq);
+	}
 
 	return err;
 }
-- 
1.9.1
