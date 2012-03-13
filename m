Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56522 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758329Ab2CMCic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:38:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 12/15] mwifiex: fix checkpatch --strict warnings/errors  Part 6
Date: Mon, 12 Mar 2012 19:38:08 -0700
Message-Id: <1331606291-322-3-git-send-email-bzhao@marvell.com> (sfid-20120313_033834_979772_4760EF2F)
In-Reply-To: <1331606291-322-1-git-send-email-bzhao@marvell.com>
References: <1331606291-322-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For file sdio.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |  159 +++++++++++++++++------------------
 1 files changed, 79 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index fe6fbc1..07ef3a7 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -67,7 +67,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	struct sdio_mmc_card *card = NULL;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
-	       func->vendor, func->device, func->class, func->num);
+		 func->vendor, func->device, func->class, func->num);
 
 	card = kzalloc(sizeof(struct sdio_mmc_card), GFP_KERNEL);
 	if (!card) {
@@ -112,6 +112,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
+	struct mwifiex_private *priv;
 	int i;
 
 	pr_debug("info: SDIO func num=%d\n", func->num);
@@ -131,15 +132,12 @@ mwifiex_sdio_remove(struct sdio_func *func)
 		for (i = 0; i < adapter->priv_num; i++)
 			if ((GET_BSS_ROLE(adapter->priv[i]) ==
 						MWIFIEX_BSS_ROLE_STA) &&
-					adapter->priv[i]->media_connected)
+			    adapter->priv[i]->media_connected)
 				mwifiex_deauthenticate(adapter->priv[i], NULL);
 
-		mwifiex_disable_auto_ds(mwifiex_get_priv(adapter,
-							 MWIFIEX_BSS_ROLE_ANY));
-
-		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-						MWIFIEX_BSS_ROLE_ANY),
-					 MWIFIEX_FUNC_SHUTDOWN);
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+		mwifiex_disable_auto_ds(priv);
+		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
@@ -169,7 +167,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	if (func) {
 		pm_flag = sdio_get_host_pm_caps(func);
 		pr_debug("cmd: %s: suspend: PM flag = 0x%x\n",
-		       sdio_func_id(func), pm_flag);
+			 sdio_func_id(func), pm_flag);
 		if (!(pm_flag & MMC_PM_KEEP_POWER)) {
 			pr_err("%s: cannot remain alive while host is"
 				" suspended\n", sdio_func_id(func));
@@ -363,12 +361,11 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = -1;
-	u8 blk_mode =
-		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
+	u8 blk_mode = (port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE
+		       : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
-	u32 blk_cnt =
-		(blk_mode ==
-		 BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE) : len;
+	u32 blk_cnt = (blk_mode == BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE)
+			: len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
 	if (claim)
@@ -472,8 +469,7 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 			i++;
 			dev_err(adapter->dev, "host_to_card, write iomem"
 					" (%d) failed: %d\n", i, ret);
-			if (mwifiex_write_reg(adapter,
-					CONFIGURATION_REG, 0x04))
+			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
 				dev_err(adapter->dev, "write CFG reg failed\n");
 
 			ret = -1;
@@ -507,11 +503,11 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 		card->mp_rd_bitmap &= (u16) (~CTRL_PORT_MASK);
 		*port = CTRL_PORT;
 		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%04x\n",
-		       *port, card->mp_rd_bitmap);
+			*port, card->mp_rd_bitmap);
 	} else {
 		if (card->mp_rd_bitmap & (1 << card->curr_rd_port)) {
-			card->mp_rd_bitmap &=
-				(u16) (~(1 << card->curr_rd_port));
+			card->mp_rd_bitmap &= (u16)
+						(~(1 << card->curr_rd_port));
 			*port = card->curr_rd_port;
 
 			if (++card->curr_rd_port == MAX_PORT)
@@ -522,7 +518,7 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 
 		dev_dbg(adapter->dev,
 			"data: port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
-		       *port, rd_bitmap, card->mp_rd_bitmap);
+			*port, rd_bitmap, card->mp_rd_bitmap);
 	}
 	return 0;
 }
@@ -556,14 +552,14 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 
 	if (*port == CTRL_PORT) {
 		dev_err(adapter->dev, "invalid data port=%d cur port=%d"
-				" mp_wr_bitmap=0x%04x -> 0x%04x\n",
-				*port, card->curr_wr_port, wr_bitmap,
-				card->mp_wr_bitmap);
+			" mp_wr_bitmap=0x%04x -> 0x%04x\n",
+			*port, card->curr_wr_port, wr_bitmap,
+			card->mp_wr_bitmap);
 		return -1;
 	}
 
 	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
-	       *port, wr_bitmap, card->mp_wr_bitmap);
+		*port, wr_bitmap, card->mp_wr_bitmap);
 
 	return 0;
 }
@@ -586,8 +582,8 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 		usleep_range(10, 20);
 	}
 
-	dev_err(adapter->dev, "poll card status failed, tries = %d\n",
-	       tries);
+	dev_err(adapter->dev, "poll card status failed, tries = %d\n", tries);
+
 	return -1;
 }
 
@@ -670,14 +666,14 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 
 	if (ret) {
 		dev_err(adapter->dev, "%s: read iomem failed: %d\n", __func__,
-				ret);
+			ret);
 		return -1;
 	}
 
 	nb = le16_to_cpu(*(__le16 *) (buffer));
 	if (nb > npayload) {
 		dev_err(adapter->dev, "%s: invalid packet, nb=%d, npayload=%d\n",
-				__func__, nb, npayload);
+			__func__, nb, npayload);
 		return -1;
 	}
 
@@ -708,18 +704,18 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	if (!firmware_len) {
 		dev_err(adapter->dev, "firmware image not found!"
-				" Terminating download\n");
+			" Terminating download\n");
 		return -1;
 	}
 
 	dev_dbg(adapter->dev, "info: downloading FW image (%d bytes)\n",
-			firmware_len);
+		firmware_len);
 
 	/* Assume that the allocated buffer is 8-byte aligned */
 	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_KERNEL);
 	if (!fwbuf) {
 		dev_err(adapter->dev, "unable to alloc buffer for firmware."
-				" Terminating download\n");
+			" Terminating download\n");
 		return -ENOMEM;
 	}
 
@@ -731,7 +727,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 						    DN_LD_CARD_RDY);
 		if (ret) {
 			dev_err(adapter->dev, "FW download with helper:"
-					" poll status timeout @ %d\n", offset);
+				" poll status timeout @ %d\n", offset);
 			goto done;
 		}
 
@@ -745,7 +741,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (ret) {
 				dev_err(adapter->dev, "dev BASE0 register read"
 					" failed: base0=0x%04X(%d). Terminating "
-				       "download\n", base0, base0);
+					"download\n", base0, base0);
 				goto done;
 			}
 			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_1,
@@ -753,7 +749,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (ret) {
 				dev_err(adapter->dev, "dev BASE1 register read"
 					" failed: base1=0x%04X(%d). Terminating "
-				       "download\n", base1, base1);
+					"download\n", base1, base1);
 				goto done;
 			}
 			len = (u16) (((base1 & 0xff) << 8) | (base0 & 0xff));
@@ -784,7 +780,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				goto done;
 			}
 			dev_err(adapter->dev, "CRC indicated by the helper:"
-			       " len = 0x%04X, txlen = %d\n", len, txlen);
+				" len = 0x%04X, txlen = %d\n", len, txlen);
 			len &= ~BIT(0);
 			/* Setting this to 0 to resend from same offset */
 			txlen = 0;
@@ -796,8 +792,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (firmware_len - offset < txlen)
 				txlen = firmware_len - offset;
 
-			tx_blocks = (txlen + MWIFIEX_SDIO_BLOCK_SIZE -
-					1) / MWIFIEX_SDIO_BLOCK_SIZE;
+			tx_blocks = (txlen + MWIFIEX_SDIO_BLOCK_SIZE - 1)
+				    / MWIFIEX_SDIO_BLOCK_SIZE;
 
 			/* Copy payload to buffer */
 			memmove(fwbuf, &firmware[offset], txlen);
@@ -808,7 +804,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 					      adapter->ioport);
 		if (ret) {
 			dev_err(adapter->dev, "FW download, write iomem (%d)"
-					" failed @ %d\n", i, offset);
+				" failed @ %d\n", i, offset);
 			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
 				dev_err(adapter->dev, "write CFG reg failed\n");
 
@@ -820,7 +816,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	} while (true);
 
 	dev_dbg(adapter->dev, "info: FW download over, size %d bytes\n",
-						offset);
+		offset);
 
 	ret = 0;
 done:
@@ -912,7 +908,7 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	card = sdio_get_drvdata(func);
 	if (!card || !card->adapter) {
 		pr_debug("int: func=%p card=%p adapter=%p\n",
-		       func, card, card ? card->adapter : NULL);
+			 func, card, card ? card->adapter : NULL);
 		return;
 	}
 	adapter = card->adapter;
@@ -955,10 +951,12 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 
 			if (adapter->ps_state == PS_STATE_SLEEP_CFM)
 				mwifiex_process_sleep_confirm_resp(adapter,
-							skb->data, skb->len);
+								   skb->data,
+								   skb->len);
 
-			memcpy(cmd_buf, skb->data, min_t(u32,
-				       MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
+			memcpy(cmd_buf, skb->data,
+			       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER,
+				     skb->len));
 
 			dev_kfree_skb_any(skb);
 		} else {
@@ -1016,7 +1014,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	if (port == CTRL_PORT) {
 		/* Read the command Resp without aggr */
 		dev_dbg(adapter->dev, "info: %s: no aggregation for cmd "
-				"response\n", __func__);
+			"response\n", __func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
@@ -1024,7 +1022,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (!card->mpa_rx.enabled) {
 		dev_dbg(adapter->dev, "info: %s: rx aggregation disabled\n",
-						__func__);
+			__func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
@@ -1071,7 +1069,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    MP_RX_AGGR_PORT_LIMIT_REACHED(card)) {
 			dev_dbg(adapter->dev, "info: %s: aggregated packet "
-					"limit reached\n", __func__);
+				"limit reached\n", __func__);
 			/* No more pkts allowed in Aggr buf, rx it */
 			f_do_rx_aggr = 1;
 		}
@@ -1080,7 +1078,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	if (f_do_rx_aggr) {
 		/* do aggr RX now */
 		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
-		       card->mpa_rx.pkt_cnt);
+			card->mpa_rx.pkt_cnt);
 
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
 					   card->mpa_rx.buf_len,
@@ -1194,7 +1192,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		card->mp_wr_bitmap = ((u16) card->mp_regs[WR_BITMAP_U]) << 8;
 		card->mp_wr_bitmap |= (u16) card->mp_regs[WR_BITMAP_L];
 		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%04x\n",
-				card->mp_wr_bitmap);
+			card->mp_wr_bitmap);
 		if (adapter->data_sent &&
 		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
 			dev_dbg(adapter->dev,
@@ -1216,12 +1214,12 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	}
 
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
-	       adapter->cmd_sent, adapter->data_sent);
+		adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
 		card->mp_rd_bitmap = ((u16) card->mp_regs[RD_BITMAP_U]) << 8;
 		card->mp_rd_bitmap |= (u16) card->mp_regs[RD_BITMAP_L];
 		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%04x\n",
-				card->mp_rd_bitmap);
+			card->mp_rd_bitmap);
 
 		while (true) {
 			ret = mwifiex_get_rd_port(adapter, &port);
@@ -1235,15 +1233,15 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			rx_len = ((u16) card->mp_regs[len_reg_u]) << 8;
 			rx_len |= (u16) card->mp_regs[len_reg_l];
 			dev_dbg(adapter->dev, "info: RX: port=%d rx_len=%u\n",
-					port, rx_len);
+				port, rx_len);
 			rx_blocks =
 				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
-			if (rx_len <= INTF_HEADER_LEN
-			    || (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
-			    MWIFIEX_RX_DATA_BUF_SIZE) {
+			if (rx_len <= INTF_HEADER_LEN ||
+			    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
+			     MWIFIEX_RX_DATA_BUF_SIZE) {
 				dev_err(adapter->dev, "invalid rx_len=%d\n",
-						rx_len);
+					rx_len);
 				return -1;
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
@@ -1252,42 +1250,42 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 			if (!skb) {
 				dev_err(adapter->dev, "%s: failed to alloc skb",
-								__func__);
+					__func__);
 				return -1;
 			}
 
 			skb_put(skb, rx_len);
 
 			dev_dbg(adapter->dev, "info: rx_len = %d skb->len = %d\n",
-					rx_len, skb->len);
+				rx_len, skb->len);
 
 			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
 							      port)) {
 				u32 cr = 0;
 
 				dev_err(adapter->dev, "card_to_host_mpa failed:"
-						" int status=%#x\n", sdio_ireg);
+					" int status=%#x\n", sdio_ireg);
 				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
 					dev_err(adapter->dev,
-							"read CFG reg failed\n");
+						"read CFG reg failed\n");
 
 				dev_dbg(adapter->dev,
-						"info: CFG reg val = %d\n", cr);
+					"info: CFG reg val = %d\n", cr);
 				if (mwifiex_write_reg(adapter,
 						      CONFIGURATION_REG,
 						      (cr | 0x04)))
 					dev_err(adapter->dev,
-							"write CFG reg failed\n");
+						"write CFG reg failed\n");
 
 				dev_dbg(adapter->dev, "info: write success\n");
 				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
 					dev_err(adapter->dev,
-							"read CFG reg failed\n");
+						"read CFG reg failed\n");
 
 				dev_dbg(adapter->dev,
-						"info: CFG reg val =%x\n", cr);
+					"info: CFG reg val =%x\n", cr);
 				return -1;
 			}
 		}
@@ -1323,7 +1321,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if ((!card->mpa_tx.enabled) || (port == CTRL_PORT)) {
 		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
-						__func__);
+			__func__);
 
 		f_send_cur_buf = 1;
 		goto tx_curr_single;
@@ -1332,7 +1330,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	if (next_pkt_len) {
 		/* More pkt in TX queue */
 		dev_dbg(adapter->dev, "info: %s: more packets in queue.\n",
-						__func__);
+			__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			if (!MP_TX_AGGR_PORT_LIMIT_REACHED(card) &&
@@ -1340,9 +1338,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				f_precopy_cur_buf = 1;
 
 				if (!(card->mp_wr_bitmap &
-						(1 << card->curr_wr_port))
-						|| !MP_TX_AGGR_BUF_HAS_ROOM(
-						card, pkt_len + next_pkt_len))
+				      (1 << card->curr_wr_port)) ||
+				    !MP_TX_AGGR_BUF_HAS_ROOM(
+					    card, pkt_len + next_pkt_len))
 					f_send_aggr_buf = 1;
 			} else {
 				/* No room in Aggr buf, send it */
@@ -1356,8 +1354,8 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 					f_postcopy_cur_buf = 1;
 			}
 		} else {
-			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)
-			    && (card->mp_wr_bitmap & (1 << card->curr_wr_port)))
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len) &&
+			    (card->mp_wr_bitmap & (1 << card->curr_wr_port)))
 				f_precopy_cur_buf = 1;
 			else
 				f_send_cur_buf = 1;
@@ -1365,7 +1363,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	} else {
 		/* Last pkt in TX queue */
 		dev_dbg(adapter->dev, "info: %s: Last packet in Tx Queue.\n",
-						__func__);
+			__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			/* some packs in Aggr buf already */
@@ -1383,7 +1381,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (f_precopy_cur_buf) {
 		dev_dbg(adapter->dev, "data: %s: precopy current buffer\n",
-						__func__);
+			__func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 
 		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
@@ -1394,7 +1392,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (f_send_aggr_buf) {
 		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
-				__func__,
+			__func__,
 				card->mpa_tx.start_port, card->mpa_tx.ports);
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len,
@@ -1408,14 +1406,14 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 tx_curr_single:
 	if (f_send_cur_buf) {
 		dev_dbg(adapter->dev, "data: %s: send current buffer %d\n",
-						__func__, port);
+			__func__, port);
 		ret = mwifiex_write_data_to_card(adapter, payload, pkt_len,
 						 adapter->ioport + port);
 	}
 
 	if (f_postcopy_cur_buf) {
 		dev_dbg(adapter->dev, "data: %s: postcopy current buffer\n",
-						__func__);
+			__func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 	}
 
@@ -1460,7 +1458,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		ret = mwifiex_get_wr_port_data(adapter, &port);
 		if (ret) {
 			dev_err(adapter->dev, "%s: no wr_port available\n",
-						__func__);
+				__func__);
 			return ret;
 		}
 	} else {
@@ -1470,7 +1468,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		if (pkt_len <= INTF_HEADER_LEN ||
 		    pkt_len > MWIFIEX_UPLD_SIZE)
 			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
-					__func__, payload, pkt_len);
+				__func__, payload, pkt_len);
 	}
 
 	/* Transfer data to card */
@@ -1478,10 +1476,11 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 
 	if (tx_param)
 		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
-				port, tx_param->next_pkt_len);
+						   port, tx_param->next_pkt_len
+						   );
 	else
 		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
-				port, 0);
+						   port, 0);
 
 	if (ret) {
 		if (type == MWIFIEX_TYPE_CMD)
@@ -1734,7 +1733,7 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 	card->curr_wr_port = 1;
 
 	dev_dbg(adapter->dev, "cmd: mp_end_port %d, data port mask 0x%x\n",
-	       port, card->mp_data_port_mask);
+		port, card->mp_data_port_mask);
 }
 
 static struct mwifiex_if_ops sdio_ops = {
-- 
1.7.0.2

