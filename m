Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:35088 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932350AbdHVL0Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:26:16 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 05/30] brcmfmac: Remove dead IO code
Date: Tue, 22 Aug 2017 12:25:25 +0100
Message-Id: <20170822112550.60311-6-ian@mnementh.co.uk> (sfid-20170822_132620_427541_8045D5C4)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	The value passed to brcmf_sdiod_addrprep() is *always* 4
remove this parameter and the unused code to handle it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 7b2184d1e365..609a934c1658 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -425,7 +425,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 }
 
 static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -439,9 +439,7 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 	}
 
 	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
-	if (width == 4)
-		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return 0;
 }
@@ -467,7 +465,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -500,7 +498,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -736,7 +734,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -757,7 +755,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
 		  addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -801,7 +799,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
@@ -821,7 +819,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		return err;
 
-- 
2.11.0
