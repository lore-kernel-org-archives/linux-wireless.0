Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60142 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbdHVLpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:32 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 13/30] brcmfmac: Clarify if using braces.
Date: Tue, 22 Aug 2017 12:25:33 +0100
Message-Id: <20170822112550.60311-14-ian@mnementh.co.uk> (sfid-20170822_134539_651440_108F4D9C)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whilst this if () statement is technically correct, it lacks clarity.


Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d5d2b2222cc1..257655d7fce4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -745,16 +745,17 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
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
2.11.0
