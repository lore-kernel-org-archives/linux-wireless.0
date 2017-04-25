Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45613 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1431394AbdDYSkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:40:47 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v4 9/9] NFC: trf7970a: Clean up coding style issues
Date: Tue, 25 Apr 2017 11:40:36 -0700
Message-Id: <20170425184036.1212-10-mgreer@animalcreek.com> (sfid-20170425_204115_485870_6A184891)
In-Reply-To: <20170425184036.1212-1-mgreer@animalcreek.com>
References: <20170425184036.1212-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up coding style issues according to scripts/Lindent.
Some scripts/Lindent changes were reverted when it appeared
to make the code less readable or when it made the line run
over 80 characters.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 291 +++++++++++++++++++++++++------------------------
 1 file changed, 147 insertions(+), 144 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index bb777f50b4fb..667aa6519657 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -122,11 +122,10 @@
 		 NFC_PROTO_ISO14443_B_MASK | NFC_PROTO_FELICA_MASK | \
 		 NFC_PROTO_ISO15693_MASK | NFC_PROTO_NFC_DEP_MASK)
 
-#define TRF7970A_AUTOSUSPEND_DELAY		30000 /* 30 seconds */
+#define TRF7970A_AUTOSUSPEND_DELAY		30000	/* 30 seconds */
 #define TRF7970A_13MHZ_CLOCK_FREQUENCY		13560000
 #define TRF7970A_27MHZ_CLOCK_FREQUENCY		27120000
 
-
 #define TRF7970A_RX_SKB_ALLOC_SIZE		256
 
 #define TRF7970A_FIFO_SIZE			127
@@ -294,7 +293,7 @@
 #define TRF7970A_REG_IO_CTRL_AUTO_REG		BIT(7)
 
 /* IRQ Status Register Bits */
-#define TRF7970A_IRQ_STATUS_NORESP		BIT(0) /* ISO15693 only */
+#define TRF7970A_IRQ_STATUS_NORESP		BIT(0)	/* ISO15693 only */
 #define TRF7970A_IRQ_STATUS_NFC_COL_ERROR	BIT(0)
 #define TRF7970A_IRQ_STATUS_COL			BIT(1)
 #define TRF7970A_IRQ_STATUS_FRAMING_EOF_ERROR	BIT(2)
@@ -459,7 +458,6 @@ struct trf7970a {
 	struct delayed_work		timeout_work;
 };
 
-
 static int trf7970a_cmd(struct trf7970a *trf, u8 opcode)
 {
 	u8 cmd = TRF7970A_CMD_BIT_CTRL | TRF7970A_CMD_BIT_OPCODE(opcode);
@@ -470,7 +468,7 @@ static int trf7970a_cmd(struct trf7970a *trf, u8 opcode)
 	ret = spi_write(trf->spi, &cmd, 1);
 	if (ret)
 		dev_err(trf->dev, "%s - cmd: 0x%x, ret: %d\n", __func__, cmd,
-				ret);
+			ret);
 	return ret;
 }
 
@@ -482,14 +480,15 @@ static int trf7970a_read(struct trf7970a *trf, u8 reg, u8 *val)
 	ret = spi_write_then_read(trf->spi, &addr, 1, val, 1);
 	if (ret)
 		dev_err(trf->dev, "%s - addr: 0x%x, ret: %d\n", __func__, addr,
-				ret);
+			ret);
 
 	dev_dbg(trf->dev, "read(0x%x): 0x%x\n", addr, *val);
 
 	return ret;
 }
 
-static int trf7970a_read_cont(struct trf7970a *trf, u8 reg, u8 *buf, size_t len)
+static int trf7970a_read_cont(struct trf7970a *trf, u8 reg, u8 *buf,
+			      size_t len)
 {
 	u8 addr = reg | TRF7970A_CMD_BIT_RW | TRF7970A_CMD_BIT_CONTINUOUS;
 	struct spi_transfer t[2];
@@ -513,7 +512,7 @@ static int trf7970a_read_cont(struct trf7970a *trf, u8 reg, u8 *buf, size_t len)
 	ret = spi_sync(trf->spi, &m);
 	if (ret)
 		dev_err(trf->dev, "%s - addr: 0x%x, ret: %d\n", __func__, addr,
-				ret);
+			ret);
 	return ret;
 }
 
@@ -527,7 +526,7 @@ static int trf7970a_write(struct trf7970a *trf, u8 reg, u8 val)
 	ret = spi_write(trf->spi, buf, 2);
 	if (ret)
 		dev_err(trf->dev, "%s - write: 0x%x 0x%x, ret: %d\n", __func__,
-				buf[0], buf[1], ret);
+			buf[0], buf[1], ret);
 
 	return ret;
 }
@@ -549,7 +548,7 @@ static int trf7970a_read_irqstatus(struct trf7970a *trf, u8 *status)
 
 	if (ret)
 		dev_err(trf->dev, "%s - irqstatus: Status read failed: %d\n",
-				__func__, ret);
+			__func__, ret);
 	else
 		*status = buf[0];
 
@@ -563,12 +562,12 @@ static int trf7970a_read_target_proto(struct trf7970a *trf, u8 *target_proto)
 	u8 addr;
 
 	addr = TRF79070A_NFC_TARGET_PROTOCOL | TRF7970A_CMD_BIT_RW |
-		TRF7970A_CMD_BIT_CONTINUOUS;
+	       TRF7970A_CMD_BIT_CONTINUOUS;
 
 	ret = spi_write_then_read(trf->spi, &addr, 1, buf, 2);
 	if (ret)
 		dev_err(trf->dev, "%s - target_proto: Read failed: %d\n",
-				__func__, ret);
+			__func__, ret);
 	else
 		*target_proto = buf[0];
 
@@ -599,7 +598,7 @@ static int trf7970a_mode_detect(struct trf7970a *trf, u8 *rf_tech)
 		break;
 	default:
 		dev_dbg(trf->dev, "%s - mode_detect: target_proto: 0x%x\n",
-				__func__, target_proto);
+			__func__, target_proto);
 		return -EIO;
 	}
 
@@ -615,8 +614,8 @@ static void trf7970a_send_upstream(struct trf7970a *trf)
 
 	if (trf->rx_skb && !IS_ERR(trf->rx_skb) && !trf->aborting)
 		print_hex_dump_debug("trf7970a rx data: ", DUMP_PREFIX_NONE,
-				16, 1, trf->rx_skb->data, trf->rx_skb->len,
-				false);
+				     16, 1, trf->rx_skb->data, trf->rx_skb->len,
+				     false);
 
 	trf->state = TRF7970A_ST_IDLE;
 
@@ -656,7 +655,8 @@ static void trf7970a_send_err_upstream(struct trf7970a *trf, int errno)
 }
 
 static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
-		unsigned int len, u8 *prefix, unsigned int prefix_len)
+			     unsigned int len, u8 *prefix,
+			     unsigned int prefix_len)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -664,7 +664,7 @@ static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
 	int ret;
 
 	print_hex_dump_debug("trf7970a tx data: ", DUMP_PREFIX_NONE,
-			16, 1, skb->data, len, false);
+			     16, 1, skb->data, len, false);
 
 	spi_message_init(&m);
 
@@ -681,7 +681,7 @@ static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
 	ret = spi_sync(trf->spi, &m);
 	if (ret) {
 		dev_err(trf->dev, "%s - Can't send tx data: %d\n", __func__,
-				ret);
+			ret);
 		return ret;
 	}
 
@@ -705,7 +705,7 @@ static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
 	}
 
 	dev_dbg(trf->dev, "Setting timeout for %d ms, state: %d\n", timeout,
-			trf->state);
+		trf->state);
 
 	schedule_delayed_work(&trf->timeout_work, msecs_to_jiffies(timeout));
 
@@ -773,9 +773,9 @@ static void trf7970a_drain_fifo(struct trf7970a *trf, u8 status)
 
 	if (fifo_bytes > skb_tailroom(skb)) {
 		skb = skb_copy_expand(skb, skb_headroom(skb),
-				max_t(int, fifo_bytes,
-					TRF7970A_RX_SKB_ALLOC_SIZE),
-				GFP_KERNEL);
+				      max_t(int, fifo_bytes,
+					    TRF7970A_RX_SKB_ALLOC_SIZE),
+				      GFP_KERNEL);
 		if (!skb) {
 			trf7970a_send_err_upstream(trf, -ENOMEM);
 			return;
@@ -786,7 +786,7 @@ static void trf7970a_drain_fifo(struct trf7970a *trf, u8 status)
 	}
 
 	ret = trf7970a_read_cont(trf, TRF7970A_FIFO_IO_REGISTER,
-			skb_put(skb, fifo_bytes), fifo_bytes);
+				 skb_put(skb, fifo_bytes), fifo_bytes);
 	if (ret) {
 		trf7970a_send_err_upstream(trf, ret);
 		return;
@@ -794,8 +794,7 @@ static void trf7970a_drain_fifo(struct trf7970a *trf, u8 status)
 
 	/* If received Type 2 ACK/NACK, shift right 4 bits and pass up */
 	if ((trf->framing == NFC_DIGITAL_FRAMING_NFCA_T2T) && (skb->len == 1) &&
-			(trf->special_fcn_reg1 ==
-				 TRF7970A_SPECIAL_FCN_REG1_4_BIT_RX)) {
+	    (trf->special_fcn_reg1 == TRF7970A_SPECIAL_FCN_REG1_4_BIT_RX)) {
 		skb->data[0] >>= 4;
 		status = TRF7970A_IRQ_STATUS_SRX;
 	} else {
@@ -818,16 +817,16 @@ static void trf7970a_drain_fifo(struct trf7970a *trf, u8 status)
 	}
 
 no_rx_data:
-	if (status == TRF7970A_IRQ_STATUS_SRX) { /* Receive complete */
+	if (status == TRF7970A_IRQ_STATUS_SRX) {	/* Receive complete */
 		trf7970a_send_upstream(trf);
 		return;
 	}
 
 	dev_dbg(trf->dev, "Setting timeout for %d ms\n",
-			TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT);
+		TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT);
 
 	schedule_delayed_work(&trf->timeout_work,
-			msecs_to_jiffies(TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT));
+			   msecs_to_jiffies(TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT));
 }
 
 static irqreturn_t trf7970a_irq(int irq, void *dev_id)
@@ -850,7 +849,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	}
 
 	dev_dbg(trf->dev, "IRQ - state: %d, status: 0x%x\n", trf->state,
-			status);
+		status);
 
 	if (!status) {
 		mutex_unlock(&trf->lock);
@@ -875,7 +874,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	case TRF7970A_ST_WAIT_FOR_TX_FIFO:
 		if (status & TRF7970A_IRQ_STATUS_TX) {
 			trf->ignore_timeout =
-				!cancel_delayed_work(&trf->timeout_work);
+			    !cancel_delayed_work(&trf->timeout_work);
 			trf7970a_fill_fifo(trf);
 		} else {
 			trf7970a_send_err_upstream(trf, -EIO);
@@ -885,11 +884,11 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	case TRF7970A_ST_WAIT_FOR_RX_DATA_CONT:
 		if (status & TRF7970A_IRQ_STATUS_SRX) {
 			trf->ignore_timeout =
-				!cancel_delayed_work(&trf->timeout_work);
+			    !cancel_delayed_work(&trf->timeout_work);
 			trf7970a_drain_fifo(trf, status);
 		} else if (status & TRF7970A_IRQ_STATUS_FIFO) {
 			ret = trf7970a_read(trf, TRF7970A_FIFO_STATUS,
-					&fifo_bytes);
+					    &fifo_bytes);
 
 			fifo_bytes &= ~TRF7970A_FIFO_STATUS_OVERFLOW;
 
@@ -898,14 +897,14 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 			else if (!fifo_bytes)
 				trf7970a_cmd(trf, TRF7970A_CMD_FIFO_RESET);
 		} else if ((status == TRF7970A_IRQ_STATUS_TX) ||
-				(!trf->is_initiator &&
-				 (status == (TRF7970A_IRQ_STATUS_TX |
-					     TRF7970A_IRQ_STATUS_NFC_RF)))) {
+			   (!trf->is_initiator &&
+			    (status == (TRF7970A_IRQ_STATUS_TX |
+					TRF7970A_IRQ_STATUS_NFC_RF)))) {
 			trf7970a_cmd(trf, TRF7970A_CMD_FIFO_RESET);
 
 			if (!trf->timeout) {
-				trf->ignore_timeout = !cancel_delayed_work(
-						&trf->timeout_work);
+				trf->ignore_timeout =
+				    !cancel_delayed_work(&trf->timeout_work);
 				trf->rx_skb = ERR_PTR(0);
 				trf7970a_send_upstream(trf);
 				break;
@@ -929,13 +928,13 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 				break;
 			case NFC_DIGITAL_FRAMING_NFCA_ANTICOL_COMPLETE:
 				ret = trf7970a_write(trf,
-					TRF7970A_SPECIAL_FCN_REG1,
-					TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL);
+					 TRF7970A_SPECIAL_FCN_REG1,
+				         TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL);
 				if (ret)
 					goto err_unlock_exit;
 
 				trf->special_fcn_reg1 =
-					TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL;
+				    TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL;
 				break;
 			default:
 				break;
@@ -943,7 +942,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 
 			if (iso_ctrl != trf->iso_ctrl) {
 				ret = trf7970a_write(trf, TRF7970A_ISO_CTRL,
-						iso_ctrl);
+						     iso_ctrl);
 				if (ret)
 					goto err_unlock_exit;
 
@@ -960,7 +959,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	case TRF7970A_ST_LISTENING:
 		if (status & TRF7970A_IRQ_STATUS_SRX) {
 			trf->ignore_timeout =
-				!cancel_delayed_work(&trf->timeout_work);
+			    !cancel_delayed_work(&trf->timeout_work);
 			trf7970a_drain_fifo(trf, status);
 		} else if (!(status & TRF7970A_IRQ_STATUS_NFC_RF)) {
 			trf7970a_send_err_upstream(trf, -EIO);
@@ -969,7 +968,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	case TRF7970A_ST_LISTENING_MD:
 		if (status & TRF7970A_IRQ_STATUS_SRX) {
 			trf->ignore_timeout =
-				!cancel_delayed_work(&trf->timeout_work);
+			    !cancel_delayed_work(&trf->timeout_work);
 
 			ret = trf7970a_mode_detect(trf, &trf->md_rf_tech);
 			if (ret) {
@@ -984,7 +983,7 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 		break;
 	default:
 		dev_err(trf->dev, "%s - Driver in invalid state: %d\n",
-				__func__, trf->state);
+			__func__, trf->state);
 	}
 
 err_unlock_exit:
@@ -1009,19 +1008,19 @@ static void trf7970a_issue_eof(struct trf7970a *trf)
 	trf->state = TRF7970A_ST_WAIT_FOR_RX_DATA;
 
 	dev_dbg(trf->dev, "Setting timeout for %d ms, state: %d\n",
-			trf->timeout, trf->state);
+		trf->timeout, trf->state);
 
 	schedule_delayed_work(&trf->timeout_work,
-			msecs_to_jiffies(trf->timeout));
+			      msecs_to_jiffies(trf->timeout));
 }
 
 static void trf7970a_timeout_work_handler(struct work_struct *work)
 {
 	struct trf7970a *trf = container_of(work, struct trf7970a,
-			timeout_work.work);
+					    timeout_work.work);
 
 	dev_dbg(trf->dev, "Timeout - state: %d, ignore_timeout: %d\n",
-			trf->state, trf->ignore_timeout);
+		trf->state, trf->ignore_timeout);
 
 	mutex_lock(&trf->lock);
 
@@ -1052,7 +1051,7 @@ static int trf7970a_init(struct trf7970a *trf)
 		goto err_out;
 
 	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
-			trf->io_ctrl | TRF7970A_REG_IO_CTRL_VRS(0x1));
+			     trf->io_ctrl | TRF7970A_REG_IO_CTRL_VRS(0x1));
 	if (ret)
 		goto err_out;
 
@@ -1065,13 +1064,13 @@ static int trf7970a_init(struct trf7970a *trf)
 	trf->chip_status_ctrl &= ~TRF7970A_CHIP_STATUS_RF_ON;
 
 	ret = trf7970a_write(trf, TRF7970A_MODULATOR_SYS_CLK_CTRL,
-			trf->modulator_sys_clk_ctrl);
+			     trf->modulator_sys_clk_ctrl);
 	if (ret)
 		goto err_out;
 
 	ret = trf7970a_write(trf, TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS,
-			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLH_96 |
-			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLL_32);
+			     TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLH_96 |
+			     TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLL_32);
 	if (ret)
 		goto err_out;
 
@@ -1092,7 +1091,7 @@ static int trf7970a_init(struct trf7970a *trf)
 static void trf7970a_switch_rf_off(struct trf7970a *trf)
 {
 	if ((trf->state == TRF7970A_ST_PWR_OFF) ||
-			(trf->state == TRF7970A_ST_RF_OFF))
+	    (trf->state == TRF7970A_ST_RF_OFF))
 		return;
 
 	dev_dbg(trf->dev, "Switching rf off\n");
@@ -1116,9 +1115,9 @@ static int trf7970a_switch_rf_on(struct trf7970a *trf)
 
 	pm_runtime_get_sync(trf->dev);
 
-	if (trf->state != TRF7970A_ST_RF_OFF) { /* Power on, RF off */
+	if (trf->state != TRF7970A_ST_RF_OFF) {	/* Power on, RF off */
 		dev_err(trf->dev, "%s - Incorrect state: %d\n", __func__,
-				trf->state);
+			trf->state);
 		return -EINVAL;
 	}
 
@@ -1153,7 +1152,7 @@ static int trf7970a_switch_rf(struct nfc_digital_dev *ddev, bool on)
 			break;
 		default:
 			dev_err(trf->dev, "%s - Invalid request: %d %d\n",
-					__func__, trf->state, on);
+				__func__, trf->state, on);
 			trf7970a_switch_rf_off(trf);
 			ret = -EINVAL;
 		}
@@ -1164,7 +1163,7 @@ static int trf7970a_switch_rf(struct nfc_digital_dev *ddev, bool on)
 			break;
 		default:
 			dev_err(trf->dev, "%s - Invalid request: %d %d\n",
-					__func__, trf->state, on);
+				__func__, trf->state, on);
 			ret = -EINVAL;
 			/* FALLTHROUGH */
 		case TRF7970A_ST_IDLE:
@@ -1189,36 +1188,36 @@ static int trf7970a_in_config_rf_tech(struct trf7970a *trf, int tech)
 	case NFC_DIGITAL_RF_TECH_106A:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_14443A_106;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_OOK;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_OOK;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCA;
 		break;
 	case NFC_DIGITAL_RF_TECH_106B:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_14443B_106;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_ASK10;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCB;
 		break;
 	case NFC_DIGITAL_RF_TECH_212F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_FELICA_212;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_ASK10;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCF;
 		break;
 	case NFC_DIGITAL_RF_TECH_424F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_FELICA_424;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_ASK10;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCF;
 		break;
 	case NFC_DIGITAL_RF_TECH_ISO15693:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_15693_SGL_1OF4_2648;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_OOK;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_OOK;
 		trf->guard_time = TRF7970A_GUARD_TIME_15693;
 		break;
 	default:
@@ -1245,7 +1244,8 @@ static int trf7970a_is_rf_field(struct trf7970a *trf, bool *is_rf_field)
 	u8 rssi;
 
 	ret = trf7970a_write(trf, TRF7970A_CHIP_STATUS_CTRL,
-			trf->chip_status_ctrl | TRF7970A_CHIP_STATUS_REC_ON);
+			     trf->chip_status_ctrl |
+			     TRF7970A_CHIP_STATUS_REC_ON);
 	if (ret)
 		return ret;
 
@@ -1260,7 +1260,7 @@ static int trf7970a_is_rf_field(struct trf7970a *trf, bool *is_rf_field)
 		return ret;
 
 	ret = trf7970a_write(trf, TRF7970A_CHIP_STATUS_CTRL,
-			trf->chip_status_ctrl);
+			     trf->chip_status_ctrl);
 	if (ret)
 		return ret;
 
@@ -1327,15 +1327,15 @@ static int trf7970a_in_config_framing(struct trf7970a *trf, int framing)
 		trf->iso_ctrl = iso_ctrl;
 
 		ret = trf7970a_write(trf, TRF7970A_MODULATOR_SYS_CLK_CTRL,
-				trf->modulator_sys_clk_ctrl);
+				     trf->modulator_sys_clk_ctrl);
 		if (ret)
 			return ret;
 	}
 
 	if (!(trf->chip_status_ctrl & TRF7970A_CHIP_STATUS_RF_ON)) {
 		ret = trf7970a_write(trf, TRF7970A_CHIP_STATUS_CTRL,
-				trf->chip_status_ctrl |
-					TRF7970A_CHIP_STATUS_RF_ON);
+				     trf->chip_status_ctrl |
+				     TRF7970A_CHIP_STATUS_RF_ON);
 		if (ret)
 			return ret;
 
@@ -1348,7 +1348,7 @@ static int trf7970a_in_config_framing(struct trf7970a *trf, int framing)
 }
 
 static int trf7970a_in_configure_hw(struct nfc_digital_dev *ddev, int type,
-		int param)
+				    int param)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	int ret;
@@ -1360,7 +1360,7 @@ static int trf7970a_in_configure_hw(struct nfc_digital_dev *ddev, int type,
 	trf->is_initiator = true;
 
 	if ((trf->state == TRF7970A_ST_PWR_OFF) ||
-			(trf->state == TRF7970A_ST_RF_OFF)) {
+	    (trf->state == TRF7970A_ST_RF_OFF)) {
 		ret = trf7970a_switch_rf_on(trf);
 		if (ret)
 			goto err_unlock;
@@ -1418,7 +1418,7 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 	 * has to send an EOF in order to get a response.
 	 */
 	if ((trf->technology == NFC_DIGITAL_RF_TECH_106A) &&
-			(trf->framing == NFC_DIGITAL_FRAMING_NFCA_T2T)) {
+	    (trf->framing == NFC_DIGITAL_FRAMING_NFCA_T2T)) {
 		if (req[0] == NFC_T2T_CMD_READ)
 			special_fcn_reg1 = 0;
 		else
@@ -1426,7 +1426,7 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 
 		if (special_fcn_reg1 != trf->special_fcn_reg1) {
 			ret = trf7970a_write(trf, TRF7970A_SPECIAL_FCN_REG1,
-					special_fcn_reg1);
+					     special_fcn_reg1);
 			if (ret)
 				return ret;
 
@@ -1446,7 +1446,7 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 			iso_ctrl |= TRF7970A_ISO_CTRL_15693_SGL_1OF4_2648;
 			break;
 		case (ISO15693_REQ_FLAG_SUB_CARRIER |
-				ISO15693_REQ_FLAG_DATA_RATE):
+		      ISO15693_REQ_FLAG_DATA_RATE):
 			iso_ctrl |= TRF7970A_ISO_CTRL_15693_DBL_1OF4_2669;
 			break;
 		}
@@ -1461,10 +1461,10 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 
 		if (trf->framing == NFC_DIGITAL_FRAMING_ISO15693_T5T) {
 			if (trf7970a_is_iso15693_write_or_lock(req[1]) &&
-					(req[0] & ISO15693_REQ_FLAG_OPTION))
+			    (req[0] & ISO15693_REQ_FLAG_OPTION))
 				trf->issue_eof = true;
 			else if ((trf->quirks &
-					TRF7970A_QUIRK_T5T_RMB_EXTRA_BYTE) &&
+				  TRF7970A_QUIRK_T5T_RMB_EXTRA_BYTE) &&
 				 (req[1] == ISO15693_CMD_READ_MULTIPLE_BLOCK))
 				trf->adjust_resp_len = true;
 		}
@@ -1474,8 +1474,8 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 }
 
 static int trf7970a_send_cmd(struct nfc_digital_dev *ddev,
-		struct sk_buff *skb, u16 timeout,
-		nfc_digital_cmd_complete_t cb, void *arg)
+			     struct sk_buff *skb, u16 timeout,
+			     nfc_digital_cmd_complete_t cb, void *arg)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	u8 prefix[5];
@@ -1484,7 +1484,7 @@ static int trf7970a_send_cmd(struct nfc_digital_dev *ddev,
 	u8 status;
 
 	dev_dbg(trf->dev, "New request - state: %d, timeout: %d ms, len: %d\n",
-			trf->state, timeout, skb->len);
+		trf->state, timeout, skb->len);
 
 	if (skb->len > TRF7970A_TX_MAX)
 		return -EINVAL;
@@ -1492,9 +1492,9 @@ static int trf7970a_send_cmd(struct nfc_digital_dev *ddev,
 	mutex_lock(&trf->lock);
 
 	if ((trf->state != TRF7970A_ST_IDLE) &&
-			(trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
+	    (trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
 		dev_err(trf->dev, "%s - Bogus state: %d\n", __func__,
-				trf->state);
+			trf->state);
 		ret = -EIO;
 		goto out_err;
 	}
@@ -1508,7 +1508,7 @@ static int trf7970a_send_cmd(struct nfc_digital_dev *ddev,
 
 	if (timeout) {
 		trf->rx_skb = nfc_alloc_recv_skb(TRF7970A_RX_SKB_ALLOC_SIZE,
-				GFP_KERNEL);
+						 GFP_KERNEL);
 		if (!trf->rx_skb) {
 			dev_dbg(trf->dev, "Can't alloc rx_skb\n");
 			ret = -ENOMEM;
@@ -1545,14 +1545,14 @@ static int trf7970a_send_cmd(struct nfc_digital_dev *ddev,
 	 * That totals 5 bytes.
 	 */
 	prefix[0] = TRF7970A_CMD_BIT_CTRL |
-			TRF7970A_CMD_BIT_OPCODE(TRF7970A_CMD_FIFO_RESET);
+	    TRF7970A_CMD_BIT_OPCODE(TRF7970A_CMD_FIFO_RESET);
 	prefix[1] = TRF7970A_CMD_BIT_CTRL |
-			TRF7970A_CMD_BIT_OPCODE(trf->tx_cmd);
+	    TRF7970A_CMD_BIT_OPCODE(trf->tx_cmd);
 	prefix[2] = TRF7970A_CMD_BIT_CONTINUOUS | TRF7970A_TX_LENGTH_BYTE1;
 
 	if (trf->framing == NFC_DIGITAL_FRAMING_NFCA_SHORT) {
 		prefix[3] = 0x00;
-		prefix[4] = 0x0f; /* 7 bits */
+		prefix[4] = 0x0f;	/* 7 bits */
 	} else {
 		prefix[3] = (len & 0xf00) >> 4;
 		prefix[3] |= ((len & 0xf0) >> 4);
@@ -1586,25 +1586,24 @@ static int trf7970a_tg_config_rf_tech(struct trf7970a *trf, int tech)
 	switch (tech) {
 	case NFC_DIGITAL_RF_TECH_106A:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
-			TRF7970A_ISO_CTRL_NFC_CE |
-			TRF7970A_ISO_CTRL_NFC_CE_14443A;
+		    TRF7970A_ISO_CTRL_NFC_CE | TRF7970A_ISO_CTRL_NFC_CE_14443A;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_OOK;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_OOK;
 		break;
 	case NFC_DIGITAL_RF_TECH_212F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
-			TRF7970A_ISO_CTRL_NFC_NFCF_212;
+		    TRF7970A_ISO_CTRL_NFC_NFCF_212;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_ASK10;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_ASK10;
 		break;
 	case NFC_DIGITAL_RF_TECH_424F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
-			TRF7970A_ISO_CTRL_NFC_NFCF_424;
+		    TRF7970A_ISO_CTRL_NFC_NFCF_424;
 		trf->modulator_sys_clk_ctrl =
-			(trf->modulator_sys_clk_ctrl & 0xf8) |
-			TRF7970A_MODULATOR_DEPTH_ASK10;
+		    (trf->modulator_sys_clk_ctrl & 0xf8) |
+		    TRF7970A_MODULATOR_DEPTH_ASK10;
 		break;
 	default:
 		dev_dbg(trf->dev, "Unsupported rf technology: %d\n", tech);
@@ -1621,9 +1620,9 @@ static int trf7970a_tg_config_rf_tech(struct trf7970a *trf, int tech)
 	 * here.
 	 */
 	if ((trf->framing == NFC_DIGITAL_FRAMING_NFC_DEP_ACTIVATED) &&
-			(trf->iso_ctrl_tech != trf->iso_ctrl)) {
+	    (trf->iso_ctrl_tech != trf->iso_ctrl)) {
 		ret = trf7970a_write(trf, TRF7970A_ISO_CTRL,
-				trf->iso_ctrl_tech);
+				     trf->iso_ctrl_tech);
 
 		trf->iso_ctrl = trf->iso_ctrl_tech;
 	}
@@ -1678,15 +1677,15 @@ static int trf7970a_tg_config_framing(struct trf7970a *trf, int framing)
 		trf->iso_ctrl = iso_ctrl;
 
 		ret = trf7970a_write(trf, TRF7970A_MODULATOR_SYS_CLK_CTRL,
-				trf->modulator_sys_clk_ctrl);
+				     trf->modulator_sys_clk_ctrl);
 		if (ret)
 			return ret;
 	}
 
 	if (!(trf->chip_status_ctrl & TRF7970A_CHIP_STATUS_RF_ON)) {
 		ret = trf7970a_write(trf, TRF7970A_CHIP_STATUS_CTRL,
-				trf->chip_status_ctrl |
-					TRF7970A_CHIP_STATUS_RF_ON);
+				     trf->chip_status_ctrl |
+				     TRF7970A_CHIP_STATUS_RF_ON);
 		if (ret)
 			return ret;
 
@@ -1697,7 +1696,7 @@ static int trf7970a_tg_config_framing(struct trf7970a *trf, int framing)
 }
 
 static int trf7970a_tg_configure_hw(struct nfc_digital_dev *ddev, int type,
-		int param)
+				    int param)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	int ret;
@@ -1709,7 +1708,7 @@ static int trf7970a_tg_configure_hw(struct nfc_digital_dev *ddev, int type,
 	trf->is_initiator = false;
 
 	if ((trf->state == TRF7970A_ST_PWR_OFF) ||
-			(trf->state == TRF7970A_ST_RF_OFF)) {
+	    (trf->state == TRF7970A_ST_RF_OFF)) {
 		ret = trf7970a_switch_rf_on(trf);
 		if (ret)
 			goto err_unlock;
@@ -1733,7 +1732,8 @@ static int trf7970a_tg_configure_hw(struct nfc_digital_dev *ddev, int type,
 }
 
 static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
-		nfc_digital_cmd_complete_t cb, void *arg, bool mode_detect)
+			       nfc_digital_cmd_complete_t cb, void *arg,
+			       bool mode_detect)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	int ret;
@@ -1741,9 +1741,9 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 	mutex_lock(&trf->lock);
 
 	if ((trf->state != TRF7970A_ST_IDLE) &&
-			(trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
+	    (trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
 		dev_err(trf->dev, "%s - Bogus state: %d\n", __func__,
-				trf->state);
+			trf->state);
 		ret = -EIO;
 		goto out_err;
 	}
@@ -1756,7 +1756,7 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 	}
 
 	trf->rx_skb = nfc_alloc_recv_skb(TRF7970A_RX_SKB_ALLOC_SIZE,
-			GFP_KERNEL);
+					 GFP_KERNEL);
 	if (!trf->rx_skb) {
 		dev_dbg(trf->dev, "Can't alloc rx_skb\n");
 		ret = -ENOMEM;
@@ -1764,25 +1764,25 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 	}
 
 	ret = trf7970a_write(trf, TRF7970A_RX_SPECIAL_SETTINGS,
-			TRF7970A_RX_SPECIAL_SETTINGS_HBT |
-			TRF7970A_RX_SPECIAL_SETTINGS_M848 |
-			TRF7970A_RX_SPECIAL_SETTINGS_C424 |
-			TRF7970A_RX_SPECIAL_SETTINGS_C212);
+			     TRF7970A_RX_SPECIAL_SETTINGS_HBT |
+			     TRF7970A_RX_SPECIAL_SETTINGS_M848 |
+			     TRF7970A_RX_SPECIAL_SETTINGS_C424 |
+			     TRF7970A_RX_SPECIAL_SETTINGS_C212);
 	if (ret)
 		goto out_err;
 
 	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
-			trf->io_ctrl | TRF7970A_REG_IO_CTRL_VRS(0x1));
+			     trf->io_ctrl | TRF7970A_REG_IO_CTRL_VRS(0x1));
 	if (ret)
 		goto out_err;
 
 	ret = trf7970a_write(trf, TRF7970A_NFC_LOW_FIELD_LEVEL,
-			TRF7970A_NFC_LOW_FIELD_LEVEL_RFDET(0x3));
+			     TRF7970A_NFC_LOW_FIELD_LEVEL_RFDET(0x3));
 	if (ret)
 		goto out_err;
 
 	ret = trf7970a_write(trf, TRF7970A_NFC_TARGET_LEVEL,
-			TRF7970A_NFC_TARGET_LEVEL_RFDET(0x7));
+			     TRF7970A_NFC_TARGET_LEVEL_RFDET(0x7));
 	if (ret)
 		goto out_err;
 
@@ -1807,32 +1807,33 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 }
 
 static int trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
-		nfc_digital_cmd_complete_t cb, void *arg)
+			      nfc_digital_cmd_complete_t cb, void *arg)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 
 	dev_dbg(trf->dev, "Listen - state: %d, timeout: %d ms\n",
-			trf->state, timeout);
+		trf->state, timeout);
 
 	return _trf7970a_tg_listen(ddev, timeout, cb, arg, false);
 }
 
 static int trf7970a_tg_listen_md(struct nfc_digital_dev *ddev,
-		u16 timeout, nfc_digital_cmd_complete_t cb, void *arg)
+				 u16 timeout, nfc_digital_cmd_complete_t cb,
+				 void *arg)
 {
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	int ret;
 
 	dev_dbg(trf->dev, "Listen MD - state: %d, timeout: %d ms\n",
-			trf->state, timeout);
+		trf->state, timeout);
 
 	ret = trf7970a_tg_configure_hw(ddev, NFC_DIGITAL_CONFIG_RF_TECH,
-			NFC_DIGITAL_RF_TECH_106A);
+				       NFC_DIGITAL_RF_TECH_106A);
 	if (ret)
 		return ret;
 
 	ret = trf7970a_tg_configure_hw(ddev, NFC_DIGITAL_CONFIG_FRAMING,
-			NFC_DIGITAL_FRAMING_NFCA_NFC_DEP);
+				       NFC_DIGITAL_FRAMING_NFCA_NFC_DEP);
 	if (ret)
 		return ret;
 
@@ -1844,7 +1845,7 @@ static int trf7970a_tg_get_rf_tech(struct nfc_digital_dev *ddev, u8 *rf_tech)
 	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 
 	dev_dbg(trf->dev, "Get RF Tech - state: %d, rf_tech: %d\n",
-			trf->state, trf->md_rf_tech);
+		trf->state, trf->md_rf_tech);
 
 	*rf_tech = trf->md_rf_tech;
 
@@ -1933,20 +1934,19 @@ static int trf7970a_power_down(struct trf7970a *trf)
 
 	if (trf->state != TRF7970A_ST_RF_OFF) {
 		dev_dbg(trf->dev, "Can't power down - not RF_OFF state (%d)\n",
-				trf->state);
+			trf->state);
 		return -EBUSY;
 	}
 
 	gpiod_set_value_cansleep(trf->en_gpiod, 0);
 
-	if (trf->en2_gpiod &&
-	    !(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
+	if (trf->en2_gpiod && !(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
 		gpiod_set_value_cansleep(trf->en2_gpiod, 0);
 
 	ret = regulator_disable(trf->regulator);
 	if (ret)
 		dev_err(trf->dev, "%s - Can't disable VIN: %d\n", __func__,
-				ret);
+			ret);
 
 	trf->state = TRF7970A_ST_PWR_OFF;
 
@@ -2060,16 +2060,16 @@ static int trf7970a_probe(struct spi_device *spi)
 
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
 	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
-		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
+	    (clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
 		dev_err(trf->dev,
-			"clock-frequency (%u Hz) unsupported\n",
-			clk_freq);
+			"clock-frequency (%u Hz) unsupported\n", clk_freq);
 		return -EINVAL;
 	}
 
 	ret = devm_request_threaded_irq(trf->dev, spi->irq, NULL,
-			trf7970a_irq, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-			"trf7970a", trf);
+					trf7970a_irq,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					"trf7970a", trf);
 	if (ret) {
 		dev_err(trf->dev, "Can't request IRQ#%d: %d\n", spi->irq, ret);
 		return ret;
@@ -2114,9 +2114,10 @@ static int trf7970a_probe(struct spi_device *spi)
 	}
 
 	trf->ddev = nfc_digital_allocate_device(&trf7970a_nfc_ops,
-			TRF7970A_SUPPORTED_PROTOCOLS,
-			NFC_DIGITAL_DRV_CAPS_IN_CRC |
-				NFC_DIGITAL_DRV_CAPS_TG_CRC, 0, 0);
+						TRF7970A_SUPPORTED_PROTOCOLS,
+						NFC_DIGITAL_DRV_CAPS_IN_CRC |
+						NFC_DIGITAL_DRV_CAPS_TG_CRC, 0,
+						0);
 	if (!trf->ddev) {
 		dev_err(trf->dev, "Can't allocate NFC digital device\n");
 		ret = -ENOMEM;
@@ -2139,7 +2140,7 @@ static int trf7970a_probe(struct spi_device *spi)
 	ret = nfc_digital_register_device(trf->ddev);
 	if (ret) {
 		dev_err(trf->dev, "Can't register NFC digital device: %d\n",
-				ret);
+			ret);
 		goto err_shutdown;
 	}
 
@@ -2248,29 +2249,31 @@ static int trf7970a_pm_runtime_resume(struct device *dev)
 static const struct dev_pm_ops trf7970a_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(trf7970a_suspend, trf7970a_resume)
 	SET_RUNTIME_PM_OPS(trf7970a_pm_runtime_suspend,
-			trf7970a_pm_runtime_resume, NULL)
+			   trf7970a_pm_runtime_resume, NULL)
 };
 
 static const struct of_device_id trf7970a_of_match[] = {
-	{ .compatible = "ti,trf7970a", },
+	{.compatible = "ti,trf7970a",},
 	{},
 };
+
 MODULE_DEVICE_TABLE(of, trf7970a_of_match);
 
 static const struct spi_device_id trf7970a_id_table[] = {
-	{ "trf7970a", 0 },
-	{ }
+	{"trf7970a", 0},
+	{}
 };
+
 MODULE_DEVICE_TABLE(spi, trf7970a_id_table);
 
 static struct spi_driver trf7970a_spi_driver = {
 	.probe		= trf7970a_probe,
 	.remove		= trf7970a_remove,
 	.id_table	= trf7970a_id_table,
-	.driver		= {
-		.name	= "trf7970a",
-		.of_match_table = of_match_ptr(trf7970a_of_match),
-		.pm	= &trf7970a_pm_ops,
+	.driver	= {
+		.name		= "trf7970a",
+		.of_match_table	= of_match_ptr(trf7970a_of_match),
+		.pm		= &trf7970a_pm_ops,
 	},
 };
 
-- 
2.12.0
