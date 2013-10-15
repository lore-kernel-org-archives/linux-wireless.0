Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4378 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252Ab3JONpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/12] brcmfmac: verify result of brcmf_sdio_addrprep()
 calls
Date: Tue, 15 Oct 2013 15:44:53 +0200
Message-ID: <1381844697-24881-9-git-send-email-arend@broadcom.com> (sfid-20131015_154526_828370_3B44EA94)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all calls to the function brcmf_sdio_addrprep() check
the return value, but it may fail so better verify it.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index da02816..c88e267 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -238,7 +238,9 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		func_num = SDIO_FUNC_1;
 		reg_size = 4;
 
-		brcmf_sdio_addrprep(sdiodev, reg_size, &addr);
+		ret = brcmf_sdio_addrprep(sdiodev, reg_size, &addr);
+		if (ret)
+			goto done;
 	}
 
 	do {
@@ -254,6 +256,7 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 						       func_num, addr, data, 4);
 	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
+done:
 	if (ret != 0)
 		brcmf_err("failed with %d\n", ret);
 
@@ -605,9 +608,10 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	memcpy(mypkt->data, buf, nbytes);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
 
-	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, mypkt);
+	if (!err)
+		err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 	return err;
@@ -619,12 +623,15 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff_head *pktq)
 {
 	uint width;
+	int err;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
+	if (err)
+		return err;
 
 	if (pktq->qlen == 1)
 		return brcmf_sdio_buffrw(sdiodev, fn, true, addr, pktq->next);
-- 
1.7.10.4


