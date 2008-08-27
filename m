Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51888 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYH0WGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 18:06:02 -0400
Date: Thu, 28 Aug 2008 01:05:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dcbw@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [RFC: 2.6 patch] wireless/libertas/if_cs.c: fix memory leaks
Message-ID: <20080827220508.GQ11734@cs181140183.pp.htv.fi> (sfid-20080828_000608_588455_F8CA2954)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The leak in if_cs_prog_helper() is obvious.

It looks a bit as if not freeing "fw" in if_cs_prog_real() was done 
intentionally, but I'm not seeing why it shouldn't be freed.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/wireless/libertas/if_cs.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

0a425d93156677eb4825fc185bfe1affe5a7db2b 
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 04d7a25..8941919 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -529,227 +529,220 @@ static irqreturn_t if_cs_interrupt(int irq, void *data)
 static int if_cs_prog_helper(struct if_cs_card *card)
 {
 	int ret = 0;
 	int sent = 0;
 	u8  scratch;
 	const struct firmware *fw;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
 	scratch = if_cs_read8(card, IF_CS_SCRATCH);
 
 	/* "If the value is 0x5a, the firmware is already
 	 * downloaded successfully"
 	 */
 	if (scratch == IF_CS_SCRATCH_HELPER_OK)
 		goto done;
 
 	/* "If the value is != 00, it is invalid value of register */
 	if (scratch != IF_CS_SCRATCH_BOOT_OK) {
 		ret = -ENODEV;
 		goto done;
 	}
 
 	/* TODO: make firmware file configurable */
 	ret = request_firmware(&fw, "libertas_cs_helper.fw",
 		&handle_to_dev(card->p_dev));
 	if (ret) {
 		lbs_pr_err("can't load helper firmware\n");
 		ret = -ENODEV;
 		goto done;
 	}
 	lbs_deb_cs("helper size %td\n", fw->size);
 
 	/* "Set the 5 bytes of the helper image to 0" */
 	/* Not needed, this contains an ARM branch instruction */
 
 	for (;;) {
 		/* "the number of bytes to send is 256" */
 		int count = 256;
 		int remain = fw->size - sent;
 
 		if (remain < count)
 			count = remain;
 
 		/* "write the number of bytes to be sent to the I/O Command
 		 * write length register" */
 		if_cs_write16(card, IF_CS_CMD_LEN, count);
 
 		/* "write this to I/O Command port register as 16 bit writes */
 		if (count)
 			if_cs_write16_rep(card, IF_CS_CMD,
 				&fw->data[sent],
 				count >> 1);
 
 		/* "Assert the download over interrupt command in the Host
 		 * status register" */
 		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_BIT_COMMAND);
 
 		/* "Assert the download over interrupt command in the Card
 		 * interrupt case register" */
 		if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_BIT_COMMAND);
 
 		/* "The host polls the Card Status register ... for 50 ms before
 		   declaring a failure */
 		ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_STATUS,
 			IF_CS_BIT_COMMAND);
 		if (ret < 0) {
 			lbs_pr_err("can't download helper at 0x%x, ret %d\n",
 				sent, ret);
-			goto done;
+			goto err_release;
 		}
 
 		if (count == 0)
 			break;
 
 		sent += count;
 	}
 
+err_release:
 	release_firmware(fw);
-	ret = 0;
-
 done:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
 
 
 static int if_cs_prog_real(struct if_cs_card *card)
 {
 	const struct firmware *fw;
 	int ret = 0;
 	int retry = 0;
 	int len = 0;
 	int sent;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
 	/* TODO: make firmware file configurable */
 	ret = request_firmware(&fw, "libertas_cs.fw",
 		&handle_to_dev(card->p_dev));
 	if (ret) {
 		lbs_pr_err("can't load firmware\n");
 		ret = -ENODEV;
 		goto done;
 	}
 	lbs_deb_cs("fw size %td\n", fw->size);
 
 	ret = if_cs_poll_while_fw_download(card, IF_CS_SQ_READ_LOW,
 		IF_CS_SQ_HELPER_OK);
 	if (ret < 0) {
 		lbs_pr_err("helper firmware doesn't answer\n");
 		goto err_release;
 	}
 
 	for (sent = 0; sent < fw->size; sent += len) {
 		len = if_cs_read16(card, IF_CS_SQ_READ_LOW);
 		if (len & 1) {
 			retry++;
 			lbs_pr_info("odd, need to retry this firmware block\n");
 		} else {
 			retry = 0;
 		}
 
 		if (retry > 20) {
 			lbs_pr_err("could not download firmware\n");
 			ret = -ENODEV;
 			goto err_release;
 		}
 		if (retry) {
 			sent -= len;
 		}
 
 
 		if_cs_write16(card, IF_CS_CMD_LEN, len);
 
 		if_cs_write16_rep(card, IF_CS_CMD,
 			&fw->data[sent],
 			(len+1) >> 1);
 		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_BIT_COMMAND);
 		if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_BIT_COMMAND);
 
 		ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_STATUS,
 			IF_CS_BIT_COMMAND);
 		if (ret < 0) {
 			lbs_pr_err("can't download firmware at 0x%x\n", sent);
 			goto err_release;
 		}
 	}
 
 	ret = if_cs_poll_while_fw_download(card, IF_CS_SCRATCH, 0x5a);
-	if (ret < 0) {
+	if (ret < 0)
 		lbs_pr_err("firmware download failed\n");
-		goto err_release;
-	}
-
-	ret = 0;
-	goto done;
-
 
 err_release:
 	release_firmware(fw);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
 
 
 
 /********************************************************************/
 /* Callback functions for libertas.ko                               */
 /********************************************************************/
 
 /* Send commands or data packets to the card */
 static int if_cs_host_to_card(struct lbs_private *priv,
 	u8 type,
 	u8 *buf,
 	u16 nb)
 {
 	int ret = -1;
 
 	lbs_deb_enter_args(LBS_DEB_CS, "type %d, bytes %d", type, nb);
 
 	switch (type) {
 	case MVMS_DAT:
 		priv->dnld_sent = DNLD_DATA_SENT;
 		if_cs_send_data(priv, buf, nb);
 		ret = 0;
 		break;
 	case MVMS_CMD:
 		priv->dnld_sent = DNLD_CMD_SENT;
 		ret = if_cs_send_cmd(priv, buf, nb);
 		break;
 	default:
 		lbs_pr_err("%s: unsupported type %d\n", __FUNCTION__, type);
 	}
 
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
 
 
 /********************************************************************/
 /* Card Services                                                    */
 /********************************************************************/
 
 /*
  * After a card is removed, if_cs_release() will unregister the
  * device, and release the PCMCIA configuration.  If the device is
  * still open, this will be postponed until it is closed.
  */
 static void if_cs_release(struct pcmcia_device *p_dev)
 {
 	struct if_cs_card *card = p_dev->priv;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
 	free_irq(p_dev->irq.AssignedIRQ, card);
 	pcmcia_disable_device(p_dev);
 	if (card->iobase)
 		ioport_unmap(card->iobase);
 
 	lbs_deb_leave(LBS_DEB_CS);
 }
 
 
 /*

