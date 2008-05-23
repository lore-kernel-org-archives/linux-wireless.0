Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20871 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYEWILI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 04:11:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix compact flash interrupt handling
Date: Fri, 23 May 2008 10:10:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231010.48939.hs4233@mail.mn-solutions.de> (sfid-20080523_101114_296428_E8ED7052)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code misbehaved because it polled card status and always called the
"tx over" code-path. The old code killed the driver/firmware after some time
when doing constant data transfer while running firmware commands at the same
time, (e.g. with "watch iwconfig eth1").

Also unify the mess of constants.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-19 14:34:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-19 15:51:49.000000000 +0200
@@ -159,56 +159,41 @@ static int if_cs_poll_while_fw_download(
 
 
 
-/* Host control registers and their bit definitions */
-
-#define IF_CS_H_STATUS			0x00000000
-#define IF_CS_H_STATUS_TX_OVER		0x0001
-#define IF_CS_H_STATUS_RX_OVER		0x0002
-#define IF_CS_H_STATUS_DNLD_OVER	0x0004
-
-#define IF_CS_H_INT_CAUSE		0x00000002
-#define IF_CS_H_IC_TX_OVER		0x0001
-#define IF_CS_H_IC_RX_OVER		0x0002
-#define IF_CS_H_IC_DNLD_OVER		0x0004
-#define IF_CS_H_IC_POWER_DOWN		0x0008
-#define IF_CS_H_IC_HOST_EVENT		0x0010
-#define IF_CS_H_IC_MASK			0x001f
-
-#define IF_CS_H_INT_MASK		0x00000004
-#define	IF_CS_H_IM_MASK			0x001f
-
-#define IF_CS_H_WRITE_LEN		0x00000014
-
-#define IF_CS_H_WRITE			0x00000016
+/* First the bitmasks for the host/card interrupt/status registers: */
+#define IF_CS_TX_OVER			0x0001
+#define IF_CS_RX_OVER			0x0002
+#define IF_CS_CMD_DNLD_OVER		0x0004
+#define IF_CS_CMD_UPLD_OVER		0x0008
+#define IF_CS_HOST_EVENT		0x0010
 
-#define IF_CS_H_CMD_LEN			0x00000018
+/* And now the individual registers and assorted masks */
+#define IF_CS_HOST_STATUS		0x00000000
 
-#define IF_CS_H_CMD			0x0000001A
+#define IF_CS_HOST_INT_CAUSE		0x00000002
 
-#define IF_CS_C_READ_LEN		0x00000024
+#define IF_CS_HOST_INT_MASK		0x00000004
+#define	IF_CS_HOST_IM_MASK		0x001f
 
-#define IF_CS_H_READ			0x00000010
+#define IF_CS_HOST_WRITE		0x00000016
+#define IF_CS_HOST_WRITE_LEN		0x00000014
 
-/* Card control registers and their bit definitions */
+#define IF_CS_HOST_CMD			0x0000001A
+#define IF_CS_HOST_CMD_LEN		0x00000018
 
-#define IF_CS_C_STATUS			0x00000020
-#define IF_CS_C_S_TX_DNLD_RDY		0x0001
-#define IF_CS_C_S_RX_UPLD_RDY		0x0002
-#define IF_CS_C_S_CMD_DNLD_RDY		0x0004
-#define IF_CS_C_S_CMD_UPLD_RDY		0x0008
-#define IF_CS_C_S_CARDEVENT		0x0010
-#define IF_CS_C_S_MASK			0x001f
-#define IF_CS_C_S_STATUS_MASK		0x7f00
+#define IF_CS_READ			0x00000010
+#define IF_CS_READ_LEN			0x00000024
 
-#define IF_CS_C_INT_CAUSE		0x00000022
-#define	IF_CS_C_IC_MASK			0x001f
+#define IF_CS_CARD_CMD			0x00000012
+#define IF_CS_CARD_CMD_LEN		0x00000030
 
-#define IF_CS_C_SQ_READ_LOW		0x00000028
-#define IF_CS_C_SQ_HELPER_OK		0x10
+#define IF_CS_CARD_STATUS		0x00000020
+#define IF_CS_CARD_S_STATUS_MASK	0x7f00
 
-#define IF_CS_C_CMD_LEN			0x00000030
+#define IF_CS_CARD_INT_CAUSE		0x00000022
+#define	IF_CS_CARD_IC_MASK		0x001f
 
-#define IF_CS_C_CMD			0x00000012
+#define IF_CS_CARD_SQ_READ_LOW		0x00000028
+#define IF_CS_CARD_SQ_HELPER_OK		0x10
 
 #define IF_CS_SCRATCH			0x0000003F
 
@@ -231,8 +216,8 @@ static int if_cs_send_cmd(struct lbs_pri
 
 	/* Is hardware ready? */
 	while (1) {
-		u16 val = if_cs_read16(card, IF_CS_C_STATUS);
-		if (val & IF_CS_C_S_CMD_DNLD_RDY)
+		u16 val = if_cs_read16(card, IF_CS_CARD_STATUS);
+		if (val & IF_CS_CMD_DNLD_OVER)
 			break;
 		if (++loops > 100) {
 			lbs_pr_err("card not ready for commands\n");
@@ -241,20 +226,20 @@ static int if_cs_send_cmd(struct lbs_pri
 		mdelay(1);
 	}
 
-	if_cs_write16(card, IF_CS_H_CMD_LEN, nb);
+	if_cs_write16(card, IF_CS_HOST_CMD_LEN, nb);
 
-	if_cs_write16_rep(card, IF_CS_H_CMD, buf, nb / 2);
+	if_cs_write16_rep(card, IF_CS_HOST_CMD, buf, nb / 2);
 	/* Are we supposed to transfer an odd amount of bytes? */
 	if (nb & 1)
-		if_cs_write8(card, IF_CS_H_CMD, buf[nb-1]);
+		if_cs_write8(card, IF_CS_HOST_CMD, buf[nb-1]);
 
 	/* "Assert the download over interrupt command in the Host
 	 * status register" */
-	if_cs_write16(card, IF_CS_H_STATUS, IF_CS_H_STATUS_DNLD_OVER);
+	if_cs_write16(card, IF_CS_HOST_STATUS, IF_CS_CMD_DNLD_OVER);
 
 	/* "Assert the download over interrupt command in the Card
 	 * interrupt case register" */
-	if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_DNLD_OVER);
+	if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_CMD_DNLD_OVER);
 	ret = 0;
 
 done:
@@ -272,15 +257,15 @@ static void if_cs_send_data(struct lbs_p
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	if_cs_write16(card, IF_CS_H_WRITE_LEN, nb);
+	if_cs_write16(card, IF_CS_HOST_WRITE_LEN, nb);
 
 	/* write even number of bytes, then odd byte if necessary */
-	if_cs_write16_rep(card, IF_CS_H_WRITE, buf, nb / 2);
+	if_cs_write16_rep(card, IF_CS_HOST_WRITE, buf, nb / 2);
 	if (nb & 1)
-		if_cs_write8(card, IF_CS_H_WRITE, buf[nb-1]);
+		if_cs_write8(card, IF_CS_HOST_WRITE, buf[nb-1]);
 
-	if_cs_write16(card, IF_CS_H_STATUS, IF_CS_H_STATUS_TX_OVER);
-	if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_STATUS_TX_OVER);
+	if_cs_write16(card, IF_CS_HOST_STATUS, IF_CS_TX_OVER);
+	if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_TX_OVER);
 
 	lbs_deb_leave(LBS_DEB_CS);
 }
@@ -293,27 +278,27 @@ static int if_cs_receive_cmdres(struct l
 {
 	unsigned long flags;
 	int ret = -1;
-	u16 val;
+	u16 status;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
 	/* is hardware ready? */
-	val = if_cs_read16(priv->card, IF_CS_C_STATUS);
-	if ((val & IF_CS_C_S_CMD_UPLD_RDY) == 0) {
+	status = if_cs_read16(priv->card, IF_CS_CARD_STATUS);
+	if ((status & IF_CS_CMD_UPLD_OVER) == 0) {
 		lbs_pr_err("card not ready for CMD\n");
 		goto out;
 	}
 
-	*len = if_cs_read16(priv->card, IF_CS_C_CMD_LEN);
+	*len = if_cs_read16(priv->card, IF_CS_CARD_CMD_LEN);
 	if ((*len == 0) || (*len > LBS_CMD_BUFFER_SIZE)) {
 		lbs_pr_err("card cmd buffer has invalid # of bytes (%d)\n", *len);
 		goto out;
 	}
 
 	/* read even number of bytes, then odd byte if necessary */
-	if_cs_read16_rep(priv->card, IF_CS_C_CMD, data, *len/sizeof(u16));
+	if_cs_read16_rep(priv->card, IF_CS_CARD_CMD, data, *len/sizeof(u16));
 	if (*len & 1)
-		data[*len-1] = if_cs_read8(priv->card, IF_CS_C_CMD);
+		data[*len-1] = if_cs_read8(priv->card, IF_CS_CARD_CMD);
 
 	/* This is a workaround for a firmware that reports too much
 	 * bytes */
@@ -339,7 +324,7 @@ static struct sk_buff *if_cs_receive_dat
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	len = if_cs_read16(priv->card, IF_CS_C_READ_LEN);
+	len = if_cs_read16(priv->card, IF_CS_READ_LEN);
 	if (len == 0 || len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
 		lbs_pr_err("card data buffer has invalid # of bytes (%d)\n", len);
 		priv->stats.rx_dropped++;
@@ -354,13 +339,13 @@ static struct sk_buff *if_cs_receive_dat
 	data = skb->data;
 
 	/* read even number of bytes, then odd byte if necessary */
-	if_cs_read16_rep(priv->card, IF_CS_H_READ, data, len/sizeof(u16));
+	if_cs_read16_rep(priv->card, IF_CS_READ, data, len/sizeof(u16));
 	if (len & 1)
-		data[len-1] = if_cs_read8(priv->card, IF_CS_H_READ);
+		data[len-1] = if_cs_read8(priv->card, IF_CS_READ);
 
 dat_err:
-	if_cs_write16(priv->card, IF_CS_H_STATUS, IF_CS_H_STATUS_RX_OVER);
-	if_cs_write16(priv->card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_RX_OVER);
+	if_cs_write16(priv->card, IF_CS_HOST_STATUS, IF_CS_RX_OVER);
+	if_cs_write16(priv->card, IF_CS_HOST_INT_CAUSE, IF_CS_RX_OVER);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %p", skb);
@@ -376,13 +361,13 @@ out:
 static inline void if_cs_enable_ints(struct if_cs_card *card)
 {
 	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
+	if_cs_write16(card, IF_CS_HOST_INT_MASK, 0);
 }
 
 static inline void if_cs_disable_ints(struct if_cs_card *card)
 {
 	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
+	if_cs_write16(card, IF_CS_HOST_INT_MASK, IF_CS_HOST_IM_MASK);
 }
 
 
@@ -394,26 +379,23 @@ static irqreturn_t if_cs_interrupt(int i
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
-
-	lbs_deb_cs("cause 0x%04x\n", cause);
+	cause = if_cs_read16(card, IF_CS_CARD_INT_CAUSE);
 	if (cause == 0) {
 		/* Not for us */
 		return IRQ_NONE;
 	}
 
+	/* Clear interrupt cause */
+	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, cause & IF_CS_CARD_IC_MASK);
+	lbs_deb_cs("cause 0x%04x\n", cause);
+
 	if (cause == 0xffff) {
 		/* Read in junk, the card has probably been removed */
 		card->priv->surpriseremoved = 1;
 		return IRQ_HANDLED;
 	}
 
-	/* TODO: I'm not sure what the best ordering is */
-
-	cause = if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
-
-	if (cause & IF_CS_C_S_RX_UPLD_RDY) {
+	if (cause & IF_CS_RX_OVER) {
 		struct sk_buff *skb;
 		lbs_deb_cs("rx packet\n");
 		skb = if_cs_receive_data(priv);
@@ -421,16 +403,16 @@ static irqreturn_t if_cs_interrupt(int i
 			lbs_process_rxed_packet(priv, skb);
 	}
 
-	if (cause & IF_CS_H_IC_TX_OVER) {
+	if (cause & IF_CS_TX_OVER) {
 		lbs_deb_cs("tx over\n");
 		lbs_host_to_card_done(priv);
 	}
 
-	if (cause & IF_CS_C_S_CMD_UPLD_RDY) {
+	if (cause & IF_CS_CMD_UPLD_OVER) {
 		unsigned long flags;
 		u8 i;
 
-		lbs_deb_cs("cmd upload ready\n");
+		lbs_deb_cs("cmd upload over\n");
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		i = (priv->resp_idx == 0) ? 1 : 0;
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -444,12 +426,10 @@ static irqreturn_t if_cs_interrupt(int i
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 	}
 
-	if (cause & IF_CS_H_IC_HOST_EVENT) {
-		u16 event = if_cs_read16(priv->card, IF_CS_C_STATUS)
-			& IF_CS_C_S_STATUS_MASK;
-		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE,
-			IF_CS_H_IC_HOST_EVENT);
-		lbs_deb_cs("eventcause 0x%04x\n", event);
+	if (cause & IF_CS_HOST_EVENT) {
+		u16 event = if_cs_read16(priv->card, IF_CS_CARD_STATUS)
+			& IF_CS_CARD_S_STATUS_MASK;
+		lbs_deb_cs("event cause 0x%04x\n", event);
 		lbs_queue_event(priv, event >> 8 & 0xff);
 	}
 
@@ -514,26 +494,26 @@ static int if_cs_prog_helper(struct if_c
 
 		/* "write the number of bytes to be sent to the I/O Command
 		 * write length register" */
-		if_cs_write16(card, IF_CS_H_CMD_LEN, count);
+		if_cs_write16(card, IF_CS_HOST_CMD_LEN, count);
 
 		/* "write this to I/O Command port register as 16 bit writes */
 		if (count)
-			if_cs_write16_rep(card, IF_CS_H_CMD,
+			if_cs_write16_rep(card, IF_CS_HOST_CMD,
 				&fw->data[sent],
 				count >> 1);
 
 		/* "Assert the download over interrupt command in the Host
 		 * status register" */
-		if_cs_write8(card, IF_CS_H_STATUS, IF_CS_H_STATUS_DNLD_OVER);
+		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_CMD_DNLD_OVER);
 
 		/* "Assert the download over interrupt command in the Card
 		 * interrupt case register" */
-		if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_DNLD_OVER);
+		if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_CMD_DNLD_OVER);
 
 		/* "The host polls the Card Status register ... for 50 ms before
 		   declaring a failure */
-		ret = if_cs_poll_while_fw_download(card, IF_CS_C_STATUS,
-			IF_CS_C_S_CMD_DNLD_RDY);
+		ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_STATUS,
+			IF_CS_CMD_DNLD_OVER);
 		if (ret < 0) {
 			lbs_pr_err("can't download helper at 0x%x, ret %d\n",
 				sent, ret);
@@ -575,14 +555,15 @@ static int if_cs_prog_real(struct if_cs_
 	}
 	lbs_deb_cs("fw size %td\n", fw->size);
 
-	ret = if_cs_poll_while_fw_download(card, IF_CS_C_SQ_READ_LOW, IF_CS_C_SQ_HELPER_OK);
+	ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_SQ_READ_LOW,
+		IF_CS_CARD_SQ_HELPER_OK);
 	if (ret < 0) {
 		lbs_pr_err("helper firmware doesn't answer\n");
 		goto err_release;
 	}
 
 	for (sent = 0; sent < fw->size; sent += len) {
-		len = if_cs_read16(card, IF_CS_C_SQ_READ_LOW);
+		len = if_cs_read16(card, IF_CS_CARD_SQ_READ_LOW);
 		if (len & 1) {
 			retry++;
 			lbs_pr_info("odd, need to retry this firmware block\n");
@@ -600,16 +581,16 @@ static int if_cs_prog_real(struct if_cs_
 		}
 
 
-		if_cs_write16(card, IF_CS_H_CMD_LEN, len);
+		if_cs_write16(card, IF_CS_HOST_CMD_LEN, len);
 
-		if_cs_write16_rep(card, IF_CS_H_CMD,
+		if_cs_write16_rep(card, IF_CS_HOST_CMD,
 			&fw->data[sent],
 			(len+1) >> 1);
-		if_cs_write8(card, IF_CS_H_STATUS, IF_CS_H_STATUS_DNLD_OVER);
-		if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_DNLD_OVER);
+		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_CMD_DNLD_OVER);
+		if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_CMD_DNLD_OVER);
 
-		ret = if_cs_poll_while_fw_download(card, IF_CS_C_STATUS,
-			IF_CS_C_S_CMD_DNLD_RDY);
+		ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_STATUS,
+			IF_CS_CMD_DNLD_OVER);
 		if (ret < 0) {
 			lbs_pr_err("can't download firmware at 0x%x\n", sent);
 			goto err_release;
@@ -837,7 +818,7 @@ static int if_cs_probe(struct pcmcia_dev
 
 	/* Clear any interrupt cause that happend while sending
 	 * firmware/initializing card */
-	if_cs_write16(card, IF_CS_C_INT_CAUSE, IF_CS_C_IC_MASK);
+	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, IF_CS_CARD_IC_MASK);
 	if_cs_enable_ints(card);
 
 	/* And finally bring the card up */
