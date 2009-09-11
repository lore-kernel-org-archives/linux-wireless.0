Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp111.mail.ukl.yahoo.com ([77.238.184.49]:38139 "HELO
	smtp111.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752382AbZIKJyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 05:54:11 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: akpm@linux-foundation.org, pierre@ossman.eu,
	linux-mmc@vger.kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH v2] sdio: recognize io card without powercycle
Date: Fri, 11 Sep 2009 11:54:11 +0200
Message-Id: <1252662852-20548-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO Simplified Specification V2.00 states that it is strongly recommended
that the host executes either a power reset or issues a CMD52 (I/O Reset) to
re-initialize an I/O only card or the I/O portion of a combo card.
Additionally, the CMD52 must be issued first because it cannot be issued
after a CMD0.

With this patch the Nintendo Wii SDIO-based WLAN card is detected after a
system reset, without requiring a complete system powercycle.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
v1
- reworded commit message
- CC'd akpm as suggested by mb

v2
- renamed sdio_go_idle to sdio_reset as suggested by Pierre Ossman

 drivers/mmc/core/core.c     |    1 +
 drivers/mmc/core/sdio_ops.c |   36 ++++++++++++++++++++++++++++++------
 drivers/mmc/core/sdio_ops.h |    1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 2649117..dd746d9 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -868,6 +868,7 @@ void mmc_rescan(struct work_struct *work)
 		mmc_claim_host(host);
 
 		mmc_power_up(host);
+		sdio_reset(host);
 		mmc_go_idle(host);
 
 		mmc_send_if_cond(host, host->ocr_avail);
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 4eb7825..dea36d9 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -67,13 +67,13 @@ int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 	return err;
 }
 
-int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, u8 in, u8* out)
+static int mmc_io_rw_direct_host(struct mmc_host *host, int write, unsigned fn,
+	unsigned addr, u8 in, u8 *out)
 {
 	struct mmc_command cmd;
 	int err;
 
-	BUG_ON(!card);
+	BUG_ON(!host);
 	BUG_ON(fn > 7);
 
 	/* sanity check */
@@ -90,11 +90,11 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	cmd.arg |= in;
 	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
 
-	err = mmc_wait_for_cmd(card->host, &cmd, 0);
+	err = mmc_wait_for_cmd(host, &cmd, 0);
 	if (err)
 		return err;
 
-	if (mmc_host_is_spi(card->host)) {
+	if (mmc_host_is_spi(host)) {
 		/* host driver already reported errors */
 	} else {
 		if (cmd.resp[0] & R5_ERROR)
@@ -106,7 +106,7 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	}
 
 	if (out) {
-		if (mmc_host_is_spi(card->host))
+		if (mmc_host_is_spi(host))
 			*out = (cmd.resp[0] >> 8) & 0xFF;
 		else
 			*out = cmd.resp[0] & 0xFF;
@@ -115,6 +115,13 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	return 0;
 }
 
+int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, u8 in, u8 *out)
+{
+	BUG_ON(!card);
+	return mmc_io_rw_direct_host(card->host, write, fn, addr, in, out);
+}
+
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
 {
@@ -182,3 +189,20 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	return 0;
 }
 
+int sdio_reset(struct mmc_host *host)
+{
+	int ret;
+	u8 abort;
+
+	/* SDIO Simplified Specification V2.0, 4.4 Reset for SDIO */
+
+	ret = mmc_io_rw_direct_host(host, 0, 0, SDIO_CCCR_ABORT, 0, &abort);
+	if (ret)
+		abort = 0x08;
+	else
+		abort |= 0x08;
+
+	ret = mmc_io_rw_direct_host(host, 1, 0, SDIO_CCCR_ABORT, abort, NULL);
+	return ret;
+}
+
diff --git a/drivers/mmc/core/sdio_ops.h b/drivers/mmc/core/sdio_ops.h
index e2e74b0..12a4d3a 100644
--- a/drivers/mmc/core/sdio_ops.h
+++ b/drivers/mmc/core/sdio_ops.h
@@ -17,6 +17,7 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
+int sdio_reset(struct mmc_host *host);
 
 #endif
 
-- 
1.6.0.4

