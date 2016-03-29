Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46426 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbcC2ND6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 09:03:58 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	<linux-mmc@vger.kernel.org>, <bin9zha0@gmail.com>,
	Cathy Luo <cluo@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mmc: add API for data write using scatter gather DMA
Date: Tue, 29 Mar 2016 05:57:41 -0700
Message-ID: <1459256261-22492-1-git-send-email-akarwar@marvell.com> (sfid-20160329_150401_812037_158C9217)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bing Zhao <bzhao@marvell.com>

This patch adds new API for SDIO scatter gather.

Existing mmc_io_rw_extended() API expects caller to pass single contiguous
buffer. It will be split if it exceeds segment size, SG table is prepared
and used it for reading/writing the data.

Our intention for defining new API here is to facilitate caller to provide
ready SG table(scattered buffer list). It will be useful for the drivers
which intend to handle SDIO SG internally.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/mmc/core/sdio_ops.c   | 64 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |  5 ++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 62508b4..6875980 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -204,6 +204,70 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	return 0;
 }
 
+int mmc_io_rw_extended_sg(struct mmc_card *card, int write, unsigned fn,
+			  unsigned addr, int incr_addr,
+			  struct sg_table *sgt, unsigned blksz)
+{
+	struct mmc_request mrq = {NULL};
+	struct mmc_command cmd = {0};
+	struct mmc_data data = {0};
+	struct scatterlist *sg_ptr;
+	unsigned blocks = 0;
+	int i;
+
+	WARN_ON(!card || !card->host);
+	WARN_ON(fn > 7);
+	WARN_ON(blksz == 0);
+	for_each_sg(sgt->sgl, sg_ptr, sgt->nents, i) {
+		WARN_ON(sg_ptr->length > card->host->max_seg_size);
+		blocks += DIV_ROUND_UP(sg_ptr->length, blksz);
+	}
+
+	/* sanity check */
+	if (addr & ~0x1FFFF)
+		return -EINVAL;
+
+	mrq.cmd = &cmd;
+	mrq.data = &data;
+
+	cmd.opcode = SD_IO_RW_EXTENDED;
+	cmd.arg = write ? 0x80000000 : 0x00000000;
+	cmd.arg |= fn << 28;
+	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
+	cmd.arg |= addr << 9;
+	cmd.arg |= 0x08000000 | blocks;
+	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
+
+	data.blksz = blksz;
+	data.blocks = blocks;
+	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+
+	data.sg = sgt->sgl;
+	data.sg_len = sgt->nents;
+
+	mmc_set_data_timeout(&data, card);
+	mmc_wait_for_req(card->host, &mrq);
+
+	if (cmd.error)
+		return cmd.error;
+	if (data.error)
+		return data.error;
+
+	if (mmc_host_is_spi(card->host)) {
+		/* host driver already reported errors */
+	} else {
+		if (cmd.resp[0] & R5_ERROR)
+			return -EIO;
+		if (cmd.resp[0] & R5_FUNCTION_NUMBER)
+			return -EINVAL;
+		if (cmd.resp[0] & R5_OUT_OF_RANGE)
+			return -ERANGE;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mmc_io_rw_extended_sg);
+
 int sdio_reset(struct mmc_host *host)
 {
 	int ret;
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index aab032a..2107e91 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -14,6 +14,7 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/pm.h>
 
@@ -151,6 +152,10 @@ extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
 extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
 	void *src, int count);
 
+int mmc_io_rw_extended_sg(struct mmc_card *card, int write, unsigned fn,
+			  unsigned addr, int incr_addr,
+			  struct sg_table *sgt, unsigned blksz);
+
 extern unsigned char sdio_f0_readb(struct sdio_func *func,
 	unsigned int addr, int *err_ret);
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
-- 
1.8.1.4

