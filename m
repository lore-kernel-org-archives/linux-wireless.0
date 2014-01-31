Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:40290
	"EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488AbaAaWR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 17:17:27 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 2/3] NFC: trf7970a: Add ISO/IEC 15693 Support
Date: Fri, 31 Jan 2014 15:17:10 -0700
Message-Id: <1391206631-9862-3-git-send-email-mgreer@animalcreek.com> (sfid-20140131_231732_060901_FF2ABDEC)
In-Reply-To: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for ISO/IEC 15693 RF technology and Type V tags.

CC: Erick Macias <emacias@ti.com>
CC: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 151 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 7b9cfec..5da1e78 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -74,9 +74,25 @@
  * Unfortunately, that means that the driver has to peek into tx frames
  * when the framing is 'NFC_DIGITAL_FRAMING_NFCA_T2T'.  This is done by
  * the trf7970a_per_cmd_config() routine.
+ *
+ * ISO/IEC 15693 frames specify whether to use single or double sub-carrier
+ * frequencies and whether to use low or high data rates in the flags byte
+ * of the frame.  This means that the driver has to peek at all 15693 frames
+ * to determine what speed to set the communication to.  In addition, Type V
+ * write and lock commands use the OPTION flag to indicate that an EOF must
+ * be sent to the tag before it will send its response.  So the driver has
+ * to examine all Type V frames for that reason too.
+ *
+ * It is unclear how long to wait before sending the EOF.  According to the
+ * Note under Table 1-1 in section 1.6 of
+ * http://www.ti.com/lit/ug/scbu011/scbu011.pdf, that wait should be at least
+ * 10 ms for TI Tag-it HF-I tags; however testing has shown that is not long
+ * enough.  For this reason, the driver waits 20 ms which seems to work
+ * reliably.
  */
 
-#define TRF7970A_SUPPORTED_PROTOCOLS		NFC_PROTO_MIFARE_MASK
+#define TRF7970A_SUPPORTED_PROTOCOLS \
+		(NFC_PROTO_MIFARE_MASK | NFC_PROTO_ISO15693_MASK)
 
 /* TX data must be prefixed with a FIFO reset cmd, a cmd that depends
  * on what the current framing is, the address of the TX length byte 1
@@ -94,6 +110,7 @@
 
 #define TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT	3
 #define TRF7970A_WAIT_FOR_FIFO_DRAIN_TIMEOUT	3
+#define TRF7970A_WAIT_TO_ISSUE_ISO15693_EOF	20
 
 /* Quirks */
 /* Erratum: When reading IRQ Status register on trf7970a, we must issue a
@@ -253,6 +270,36 @@
 /* NFC (ISO/IEC 14443A) Type 2 Tag commands */
 #define NFC_T2T_CMD_READ			0x30
 
+/* ISO 15693 commands codes */
+#define ISO15693_CMD_INVENTORY			0x01
+#define ISO15693_CMD_READ_SINGLE_BLOCK		0x20
+#define ISO15693_CMD_WRITE_SINGLE_BLOCK		0x21
+#define ISO15693_CMD_LOCK_BLOCK			0x22
+#define ISO15693_CMD_READ_MULTIPLE_BLOCK	0x23
+#define ISO15693_CMD_WRITE_MULTIPLE_BLOCK	0x24
+#define ISO15693_CMD_SELECT			0x25
+#define ISO15693_CMD_RESET_TO_READY		0x26
+#define ISO15693_CMD_WRITE_AFI			0x27
+#define ISO15693_CMD_LOCK_AFI			0x28
+#define ISO15693_CMD_WRITE_DSFID		0x29
+#define ISO15693_CMD_LOCK_DSFID			0x2a
+#define ISO15693_CMD_GET_SYSTEM_INFO		0x2b
+#define ISO15693_CMD_GET_MULTIPLE_BLOCK_SECURITY_STATUS	0x2c
+
+/* ISO 15693 request and response flags */
+#define ISO15693_REQ_FLAG_SUB_CARRIER		BIT(0)
+#define ISO15693_REQ_FLAG_DATA_RATE		BIT(1)
+#define ISO15693_REQ_FLAG_INVENTORY		BIT(2)
+#define ISO15693_REQ_FLAG_PROTOCOL_EXT		BIT(3)
+#define ISO15693_REQ_FLAG_SELECT		BIT(4)
+#define ISO15693_REQ_FLAG_AFI			BIT(4)
+#define ISO15693_REQ_FLAG_ADDRESS		BIT(5)
+#define ISO15693_REQ_FLAG_NB_SLOTS		BIT(5)
+#define ISO15693_REQ_FLAG_OPTION		BIT(6)
+
+#define ISO15693_REQ_FLAG_SPEED_MASK \
+		(ISO15693_REQ_FLAG_SUB_CARRIER | ISO15693_REQ_FLAG_DATA_RATE)
+
 enum trf7970a_state {
 	TRF7970A_ST_OFF,
 	TRF7970A_ST_IDLE,
@@ -260,6 +307,7 @@ enum trf7970a_state {
 	TRF7970A_ST_WAIT_FOR_TX_FIFO,
 	TRF7970A_ST_WAIT_FOR_RX_DATA,
 	TRF7970A_ST_WAIT_FOR_RX_DATA_CONT,
+	TRF7970A_ST_WAIT_TO_ISSUE_EOF,
 	TRF7970A_ST_MAX
 };
 
@@ -279,6 +327,7 @@ struct trf7970a {
 	int				technology;
 	int				framing;
 	u8				tx_cmd;
+	bool				issue_eof;
 	int				ss_gpio;
 	int				en2_gpio;
 	int				en_gpio;
@@ -532,8 +581,13 @@ static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
 		trf->state = TRF7970A_ST_WAIT_FOR_TX_FIFO;
 		timeout = TRF7970A_WAIT_FOR_FIFO_DRAIN_TIMEOUT;
 	} else {
-		trf->state = TRF7970A_ST_WAIT_FOR_RX_DATA;
-		timeout = trf->timeout;
+		if (trf->issue_eof) {
+			trf->state = TRF7970A_ST_WAIT_TO_ISSUE_EOF;
+			timeout = TRF7970A_WAIT_TO_ISSUE_ISO15693_EOF;
+		} else {
+			trf->state = TRF7970A_ST_WAIT_FOR_RX_DATA;
+			timeout = trf->timeout;
+		}
 	}
 
 	dev_dbg(trf->dev, "Setting timeout for %d ms, state: %d\n", timeout,
@@ -709,6 +763,10 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 			trf7970a_abort_and_send_err(trf, -EIO);
 		}
 		break;
+	case TRF7970A_ST_WAIT_TO_ISSUE_EOF:
+		if (status != TRF7970A_IRQ_STATUS_TX)
+			trf7970a_abort_and_send_err(trf, -EIO);
+		break;
 	default:
 		dev_err(trf->dev, "%s - Driver in invalid state: %d\n",
 				__func__, trf->state);
@@ -718,6 +776,29 @@ static irqreturn_t trf7970a_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void trf7970a_issue_eof(struct trf7970a *trf)
+{
+	int ret;
+
+	dev_dbg(trf->dev, "Issuing EOF\n");
+
+	ret = trf7970a_cmd(trf, TRF7970A_CMD_FIFO_RESET);
+	if (ret)
+		trf7970a_abort_and_send_err(trf, ret);
+
+	ret = trf7970a_cmd(trf, TRF7970A_CMD_EOF);
+	if (ret)
+		trf7970a_abort_and_send_err(trf, ret);
+
+	trf->state = TRF7970A_ST_WAIT_FOR_RX_DATA;
+
+	dev_dbg(trf->dev, "Setting timeout for %d ms, state: %d\n",
+			trf->timeout, trf->state);
+
+	schedule_delayed_work(&trf->timeout_work,
+			msecs_to_jiffies(trf->timeout));
+}
+
 static void trf7970a_timeout_work_handler(struct work_struct *work)
 {
 	struct trf7970a *trf = container_of(work, struct trf7970a,
@@ -732,6 +813,8 @@ static void trf7970a_timeout_work_handler(struct work_struct *work)
 		trf->ignore_timeout = false;
 	else if (trf->state == TRF7970A_ST_WAIT_FOR_RX_DATA_CONT)
 		trf7970a_send_upstream(trf); /* No more rx data so send up */
+	else if (trf->state == TRF7970A_ST_WAIT_TO_ISSUE_EOF)
+		trf7970a_issue_eof(trf);
 	else
 		trf7970a_abort_and_send_err(trf, -ETIMEDOUT);
 
@@ -750,6 +833,9 @@ static int trf7970a_config_rf_tech(struct trf7970a *trf, int tech)
 	case NFC_DIGITAL_RF_TECH_106A:
 		trf->iso_ctrl = TRF7970A_ISO_CTRL_14443A_106;
 		break;
+	case NFC_DIGITAL_RF_TECH_ISO15693:
+		trf->iso_ctrl = TRF7970A_ISO_CTRL_15693_SGL_1OF4_2648;
+		break;
 	default:
 		dev_dbg(trf->dev, "Unsupported rf technology: %d\n", tech);
 		return -EINVAL;
@@ -771,6 +857,8 @@ static int trf7970a_config_framing(struct trf7970a *trf, int framing)
 		trf->iso_ctrl |= TRF7970A_ISO_CTRL_RX_CRC_N;
 		break;
 	case NFC_DIGITAL_FRAMING_NFCA_STANDARD_WITH_CRC_A:
+	case NFC_DIGITAL_FRAMING_ISO15693_INVENTORY:
+	case NFC_DIGITAL_FRAMING_ISO15693_TVT:
 		trf->tx_cmd = TRF7970A_CMD_TRANSMIT;
 		trf->iso_ctrl &= ~TRF7970A_ISO_CTRL_RX_CRC_N;
 		break;
@@ -821,15 +909,43 @@ err_out:
 	return ret;
 }
 
+static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
+{
+	int ret;
+
+	switch (cmd) {
+	case ISO15693_CMD_WRITE_SINGLE_BLOCK:
+	case ISO15693_CMD_LOCK_BLOCK:
+	case ISO15693_CMD_WRITE_MULTIPLE_BLOCK:
+	case ISO15693_CMD_WRITE_AFI:
+	case ISO15693_CMD_LOCK_AFI:
+	case ISO15693_CMD_WRITE_DSFID:
+	case ISO15693_CMD_LOCK_DSFID:
+		ret = 1;
+		break;
+	default:
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 {
 	u8 *req = skb->data;
-	u8 special_fcn_reg1;
+	u8 special_fcn_reg1, iso_ctrl;
 	int ret;
 
+	trf->issue_eof = false;
+
 	/* When issuing Type 2 read command, make sure the '4_bit_RX' bit in
 	 * special functions register 1 is cleared; otherwise, its a write or
 	 * sector select command and '4_bit_RX' must be set.
+	 *
+	 * When issuing an ISO 15693 command, inspect the flags byte to see
+	 * what speed to use.  Also, remember when the OPTION flag is set on
+	 * a Type V write or lock command so the driver will know that it
+	 * has to send an EOF in order to get a response.
 	 */
 	if ((trf->technology == NFC_DIGITAL_RF_TECH_106A) &&
 			(trf->framing == NFC_DIGITAL_FRAMING_NFCA_T2T)) {
@@ -846,6 +962,37 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 
 			trf->special_fcn_reg1 = special_fcn_reg1;
 		}
+	} else if (trf->technology == NFC_DIGITAL_RF_TECH_ISO15693) {
+		iso_ctrl = trf->iso_ctrl & ~TRF7970A_ISO_CTRL_RFID_SPEED_MASK;
+
+		switch (req[0] & ISO15693_REQ_FLAG_SPEED_MASK) {
+		case 0x00:
+			iso_ctrl |= TRF7970A_ISO_CTRL_15693_SGL_1OF4_662;
+			break;
+		case ISO15693_REQ_FLAG_SUB_CARRIER:
+			iso_ctrl |= TRF7970A_ISO_CTRL_15693_DBL_1OF4_667a;
+			break;
+		case ISO15693_REQ_FLAG_DATA_RATE:
+			iso_ctrl |= TRF7970A_ISO_CTRL_15693_SGL_1OF4_2648;
+			break;
+		case (ISO15693_REQ_FLAG_SUB_CARRIER |
+				ISO15693_REQ_FLAG_DATA_RATE):
+			iso_ctrl |= TRF7970A_ISO_CTRL_15693_DBL_1OF4_2669;
+			break;
+		}
+
+		if (iso_ctrl != trf->iso_ctrl) {
+			ret = trf7970a_write(trf, TRF7970A_ISO_CTRL, iso_ctrl);
+			if (ret)
+				return ret;
+
+			trf->iso_ctrl = iso_ctrl;
+		}
+
+		if ((trf->framing == NFC_DIGITAL_FRAMING_ISO15693_TVT) &&
+				trf7970a_is_iso15693_write_or_lock(req[1]) &&
+				(req[0] & ISO15693_REQ_FLAG_OPTION))
+			trf->issue_eof = true;
 	}
 
 	return 0;
-- 
1.8.3.4

