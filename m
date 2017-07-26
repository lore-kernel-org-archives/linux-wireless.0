Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:47104 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751529AbdGZMJi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 08:09:38 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.13] brcmfmac: fix memleak due to calling brcmf_sdiod_sgtable_alloc() twice
Date: Wed, 26 Jul 2017 13:09:24 +0100
Message-Id: <1501070969-15984-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170726_140942_393349_9E9D60D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to a bugfix in wireless tree and the commit mentioned below a merge
was needed which went haywire. So the submitted change resulted in the
function brcmf_sdiod_sgtable_alloc() being called twice during the probe
thus leaking the memory of the first call.

Cc: stable@vger.kernel.org # 4.6.x
Fixes: 4d7928959832 ("brcmfmac: switch to new platform data")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c3ecec6..f355612 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4175,11 +4175,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
-	/* allocate scatter-gather table. sg support
-	 * will be disabled upon allocation failure.
-	 */
-	brcmf_sdiod_sgtable_alloc(bus->sdiodev);
-
 	/* Query the F2 block size, set roundup accordingly */
 	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
-- 
1.9.1
