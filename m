Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15265 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbcFPJ0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 05:26:08 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	<linux-mmc@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v4 2/2] mmc: sdio support external scatter gather list
Date: Thu, 16 Jun 2016 14:53:26 +0530
Message-ID: <1466069006-10757-2-git-send-email-akarwar@marvell.com> (sfid-20160616_112615_897295_F85F659F)
In-Reply-To: <1466069006-10757-1-git-send-email-akarwar@marvell.com>
References: <1466069006-10757-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Currently sdio device drivers need to prepare a big continuous
physical memory for large data transfer. mmc stack will construct
scatter/gather buffer list to make use of ADMA2.

According to the sdio host controller specification version 4.00
chapter 1.13.2, sdio device drivers have the ability to construct
scatter/gather DMA buffer list. In this way, they do not need to allocate
big memory.

This patch refactors current sdio command 53 wrapper mmc_io_rw_extended,
so that it can accept external scatter/gather buffer list from its caller,
such as the sdio device driver. This patch is very useful on some embedded
systems where large memory allocation fails sometimes. It gives 10 to 15%
better throughput performance compared to a case in which small single
data transfers are done.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/mmc/core/sdio_io.c    | 22 ++++++++++++++++--
 drivers/mmc/core/sdio_ops.c   | 53 +++++++++++++++++++++++++++++++++++++++----
 drivers/mmc/core/sdio_ops.h   |  3 ++-
 include/linux/mmc/sdio_func.h |  6 +++++
 4 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index b1ecacc..1433204 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -322,7 +322,7 @@ static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
 			size = blocks * func->cur_blksize;
 
 			ret = mmc_io_rw_extended(func->card, write,
-				func->num, addr, incr_addr, buf,
+				func->num, addr, incr_addr, false, buf,
 				blocks, func->cur_blksize);
 			if (ret)
 				return ret;
@@ -340,7 +340,7 @@ static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
 
 		/* Indicate byte mode by setting "blocks" = 0 */
 		ret = mmc_io_rw_extended(func->card, write, func->num, addr,
-			 incr_addr, buf, 0, size);
+			 incr_addr, false, buf, 0, size);
 		if (ret)
 			return ret;
 
@@ -504,6 +504,24 @@ int sdio_writesb(struct sdio_func *func, unsigned int addr, void *src,
 }
 EXPORT_SYMBOL_GPL(sdio_writesb);
 
+int sdio_readsb_sg_enh(struct sdio_func *func, unsigned int addr,
+		       struct sg_table *dst)
+{
+	return mmc_io_rw_extended(func->card, 0, func->num,
+				  addr, 0, true,
+				  dst, 0, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_readsb_sg_enh);
+
+int sdio_writesb_sg_enh(struct sdio_func *func, unsigned int addr,
+			struct sg_table *src)
+{
+	return mmc_io_rw_extended(func->card, 1, func->num,
+				  addr, 0, true,
+				  src, 0, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_writesb_sg_enh);
+
 /**
  *	sdio_readw - read a 16 bit integer from a SDIO function
  *	@func: SDIO function to access
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 34f6e80..bec3069 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -118,16 +118,39 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	return mmc_io_rw_direct_host(card->host, write, fn, addr, in, out);
 }
 
+/**
+ *     mmc_io_rw_extended - wrapper for sdio command 53 read/write operation
+ *     @card: destination device for read/write
+ *     @write: zero indcate read, non-zero indicate write.
+ *     @fn: SDIO function to access
+ *     @addr: address of (single byte) FIFO
+ *     @incr_addr: set to 1 indicate read or write multiple bytes
+		of data to/from an IO register address that
+		increment by 1 after each operation.
+ *     @sg_enhance: if set true, the caller of this function will
+		prepare scatter gather dma buffer list.
+ *     @buf: buffer that contains the data to write. if sg_enhance
+		is set, it point to SG dma buffer list.
+ *     @blocks: number of blocks of data transfer.
+		if set zero, indicate byte mode
+		if set non-zero, indicate block mode
+		if sg_enhance is set, this parameter will not be used.
+ *     @blksz: block size for block mode data transfer.
+ *
+ */
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
+		       unsigned int addr, int incr_addr, bool sg_enhance,
+		       void *buf, unsigned int blocks, unsigned int blksz)
 {
 	struct mmc_request mrq = {NULL};
 	struct mmc_command cmd = {0};
 	struct mmc_data data = {0};
 	struct scatterlist sg, *sg_ptr;
 	struct sg_table sgtable;
+	struct sg_table *sgtable_external;
 	unsigned int nents, left_size, i;
 	unsigned int seg_size = card->host->max_seg_size;
+	unsigned int sg_blocks = 0;
 
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
@@ -145,16 +168,35 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	cmd.arg |= fn << 28;
 	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
 	cmd.arg |= addr << 9;
+	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
+
+	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+	data.blksz = blksz;
+
+	if (sg_enhance) {
+		sgtable_external = buf;
+
+		for_each_sg(sgtable_external->sgl, sg_ptr,
+			    sgtable_external->nents, i) {
+			if (sg_ptr->length > card->host->max_seg_size)
+				return -EINVAL;
+			sg_blocks += DIV_ROUND_UP(sg_ptr->length, blksz);
+		}
+
+		cmd.arg |= 0x08000000 | sg_blocks;
+		data.blocks = sg_blocks;
+		data.sg = sgtable_external->sgl;
+		data.sg_len = sgtable_external->nents;
+		goto mmc_data_req;
+	}
+
 	if (blocks == 0)
 		cmd.arg |= (blksz == 512) ? 0 : blksz;	/* byte mode */
 	else
 		cmd.arg |= 0x08000000 | blocks;		/* block mode */
-	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
 
-	data.blksz = blksz;
 	/* Code in host drivers/fwk assumes that "blocks" always is >=1 */
 	data.blocks = blocks ? blocks : 1;
-	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
 
 	left_size = data.blksz * data.blocks;
 	nents = (left_size - 1) / seg_size + 1;
@@ -178,11 +220,12 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 		sg_init_one(&sg, buf, left_size);
 	}
 
+mmc_data_req:
 	mmc_set_data_timeout(&data, card);
 
 	mmc_wait_for_req(card->host, &mrq);
 
-	if (nents > 1)
+	if (!sg_enhance && nents > 1)
 		sg_free_table(&sgtable);
 
 	if (cmd.error)
diff --git a/drivers/mmc/core/sdio_ops.h b/drivers/mmc/core/sdio_ops.h
index 5660c7f..a8b8e0c 100644
--- a/drivers/mmc/core/sdio_ops.h
+++ b/drivers/mmc/core/sdio_ops.h
@@ -18,7 +18,8 @@ int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
+		       unsigned int addr, int incr_addr, bool sg_enhance,
+		       void *buf, unsigned int blocks, unsigned int blksz);
 int sdio_reset(struct mmc_host *host);
 
 static inline bool mmc_is_io_op(u32 opcode)
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index b2b91df..ba8f392 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -14,6 +14,7 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/pm.h>
 
@@ -136,6 +137,11 @@ extern int sdio_memcpy_fromio(struct sdio_func *func, void *dst,
 extern int sdio_readsb(struct sdio_func *func, void *dst,
 	unsigned int addr, int count);
 
+int sdio_readsb_sg_enh(struct sdio_func *func, unsigned int addr,
+		       struct sg_table *dst);
+int sdio_writesb_sg_enh(struct sdio_func *func, unsigned int addr,
+			struct sg_table *src);
+
 extern void sdio_writeb(struct sdio_func *func, u8 b,
 	unsigned int addr, int *err_ret);
 extern void sdio_writew(struct sdio_func *func, u16 b,
-- 
1.9.1

