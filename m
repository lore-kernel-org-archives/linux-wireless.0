Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:42877 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507Ab3ERAyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:54:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 11/17] mwifiex: replace unnecessary u32 variables with u8 in sdio.c
Date: Fri, 17 May 2013 17:53:42 -0700
Message-ID: <1368838422-32670-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025414_883161_E02535A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Some u32 variables in sdio.c are used to store/pass u8 values.
Replace them with u8 variables.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 022e9fd..e4357a6 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -294,13 +294,13 @@ static struct sdio_driver mwifiex_sdio = {
  * This function writes data into SDIO card register.
  */
 static int
-mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u32 data)
+mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u8 data)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = -1;
 
 	sdio_claim_host(card->func);
-	sdio_writeb(card->func, (u8) data, reg, &ret);
+	sdio_writeb(card->func, data, reg, &ret);
 	sdio_release_host(card->func);
 
 	return ret;
@@ -310,7 +310,7 @@ mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u32 data)
  * This function reads data from SDIO card register.
  */
 static int
-mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
+mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u8 *data)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = -1;
@@ -421,7 +421,7 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 {
-	u32 reg;
+	u8 reg;
 	struct sdio_mmc_card *card = adapter->card;
 
 	adapter->ioport = 0;
@@ -580,7 +580,7 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	u32 tries;
-	u32 cs;
+	u8 cs;
 
 	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
 		if (mwifiex_read_reg(adapter, card->reg->poll_reg, &cs))
@@ -604,7 +604,7 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	const struct mwifiex_sdio_card_reg *reg = card->reg;
-	u32 fws0, fws1;
+	u8 fws0, fws1;
 
 	if (mwifiex_read_reg(adapter, reg->status_reg_0, &fws0))
 		return -1;
@@ -625,14 +625,14 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
  */
 static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 {
-	u32 host_int_mask;
+	u8 host_int_mask, host_int_disable = HOST_INT_DISABLE;
 
 	/* Read back the host_int_mask register */
 	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask))
 		return -1;
 
 	/* Update with the mask and write back to the register */
-	host_int_mask &= ~HOST_INT_DISABLE;
+	host_int_mask &= ~host_int_disable;
 
 	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
 		dev_err(adapter->dev, "disable host interrupt failed\n");
@@ -712,7 +712,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u8 *firmware = fw->fw_buf;
 	u32 firmware_len = fw->fw_len;
 	u32 offset = 0;
-	u32 base0, base1;
+	u8 base0, base1;
 	u8 *fwbuf;
 	u16 len = 0;
 	u32 txlen, tx_blocks = 0, tries;
@@ -854,7 +854,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	u16 firmware_stat;
 	u32 tries;
-	u32 winner_status;
+	u8 winner_status;
 
 	/* Wait for firmware initialization event */
 	for (tries = 0; tries < poll_num; tries++) {
@@ -889,7 +889,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	u32 sdio_ireg;
+	u8 sdio_ireg;
 	unsigned long flags;
 
 	if (mwifiex_read_data_sync(adapter, card->mp_regs,
@@ -1284,7 +1284,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
 							      port)) {
-				u32 cr = 0;
+				u8 cr = 0;
 
 				dev_err(adapter->dev, "card_to_host_mpa failed:"
 					" int status=%#x\n", sdio_ireg);
@@ -1644,7 +1644,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	int ret;
-	u32 sdio_ireg;
+	u8 sdio_ireg;
 
 	/*
 	 * Read the HOST_INT_STATUS_REG for ACK the first interrupt got
-- 
1.8.2.3

