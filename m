Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4378 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756Ab3JONpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:08 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: rework scatter-gather code in
 brcmf_sdio_buffrw()
Date: Tue, 15 Oct 2013 15:44:50 +0200
Message-ID: <1381844697-24881-6-git-send-email-arend@broadcom.com> (sfid-20131015_154650_891416_E7823FC7)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving a number of assignments outside of the loop as they are
the same for each request.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   34 ++++++++++++----------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8c4b506..ea716a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -409,12 +409,26 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		goto exit;
 	}
 
+	memset(&mmc_req, 0, sizeof(struct mmc_request));
+	memset(&mmc_cmd, 0, sizeof(struct mmc_command));
+	memset(&mmc_dat, 0, sizeof(struct mmc_data));
+
+	mmc_dat.sg = st.sgl;
+	mmc_dat.blksz = func_blk_sz;
+	mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+	mmc_cmd.opcode = SD_IO_RW_EXTENDED;
+	mmc_cmd.arg = write ? 1<<31 : 0;	/* write flag  */
+	mmc_cmd.arg |= (fn & 0x7) << 28;	/* SDIO func num */
+	mmc_cmd.arg |= 1<<27;			/* block mode */
+	/* for function 1 the addr will be incremented */
+	mmc_cmd.arg |= (fn == 1) ? 1<<26 : 0;
+	mmc_cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
+	mmc_req.cmd = &mmc_cmd;
+	mmc_req.data = &mmc_dat;
+
 	while (seg_sz) {
 		req_sz = 0;
 		sg_cnt = 0;
-		memset(&mmc_req, 0, sizeof(struct mmc_request));
-		memset(&mmc_cmd, 0, sizeof(struct mmc_command));
-		memset(&mmc_dat, 0, sizeof(struct mmc_data));
 		sgl = st.sgl;
 		/* prep sg table */
 		while (pkt_next != (struct sk_buff *)target_list) {
@@ -447,22 +461,12 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			ret = -ENOTBLK;
 			goto exit;
 		}
-		mmc_dat.sg = st.sgl;
+
 		mmc_dat.sg_len = sg_cnt;
-		mmc_dat.blksz = func_blk_sz;
 		mmc_dat.blocks = req_sz / func_blk_sz;
-		mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
-		mmc_cmd.opcode = SD_IO_RW_EXTENDED;
-		mmc_cmd.arg = write ? 1<<31 : 0;	/* write flag  */
-		mmc_cmd.arg |= (fn & 0x7) << 28;	/* SDIO func num */
-		mmc_cmd.arg |= 1<<27;			/* block mode */
-		/* incrementing addr for function 1 */
-		mmc_cmd.arg |= (fn == 1) ? 1<<26 : 0;
 		mmc_cmd.arg |= (addr & 0x1FFFF) << 9;	/* address */
 		mmc_cmd.arg |= mmc_dat.blocks & 0x1FF;	/* block count */
-		mmc_cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
-		mmc_req.cmd = &mmc_cmd;
-		mmc_req.data = &mmc_dat;
+		/* incrementing addr for function 1 */
 		if (fn == 1)
 			addr += req_sz;
 
-- 
1.7.10.4


