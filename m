Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab0IHX0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:26:01 -0400
Received: by pzk34 with SMTP id 34so248716pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:26:00 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order to fetch MAC address
Date: Wed,  8 Sep 2010 16:25:25 -0700
Message-Id: <1283988329-44549-6-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 requires that the MAC address be known and set before calling
ieee80211_register_hw().  If this isn't done, we see bad MAC addresses
in our packet headers.  In order to make this happen, I had to restructure
to have if_sdio_probe load the firmware and get the hardware specs.

I had to add a if_sdio_update_hw_spec function as if_sdio can't use the standard
command as several required variables aren't setup yet.
if_sdio_update_hw_spec essentially uses polled io to get the hw spec
command response from the card.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_sdio.c     |  263 ++++++++++++++++++++----
 drivers/net/wireless/libertas_tf/libertas_tf.h |    2 +-
 drivers/net/wireless/libertas_tf/main.c        |   38 +++--
 3 files changed, 248 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index 1e72b4c..189b820 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -91,12 +91,15 @@ struct if_sdio_card {
 	struct workqueue_struct	*workqueue;
 	struct work_struct	packet_worker;
 
+	u8 hw_addr[ETH_ALEN];
+	u32 fwrelease;
+	u32 fwcapinfo;
+
 	u8			rx_unit;
 };
 
-static int if_sdio_enable_interrupts(struct lbtf_private *priv)
+static int _if_sdio_enable_interrupts(struct if_sdio_card *card)
 {
-	struct if_sdio_card *card = priv->card;
 	int ret;
 
 	lbtf_deb_enter(LBTF_DEB_SDIO);
@@ -109,9 +112,14 @@ static int if_sdio_enable_interrupts(struct lbtf_private *priv)
 	return (ret);
 }
 
-static int if_sdio_disable_interrupts(struct lbtf_private *priv)
+static int if_sdio_enable_interrupts(struct lbtf_private *priv)
 {
 	struct if_sdio_card *card = priv->card;
+	return _if_sdio_enable_interrupts(card);
+}
+
+static int _if_sdio_disable_interrupts(struct if_sdio_card *card)
+{
 	int ret;
 
 	lbtf_deb_enter(LBTF_DEB_SDIO);
@@ -124,6 +132,12 @@ static int if_sdio_disable_interrupts(struct lbtf_private *priv)
 	return (ret);
 }
 
+static int if_sdio_disable_interrupts(struct lbtf_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	return _if_sdio_disable_interrupts(card);
+}
+
 /*
  *  For SD8385/SD8686, this function reads firmware status after
  *  the image is downloaded, or reads RX packet length when
@@ -187,7 +201,6 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 	struct lbtf_private *priv = card->priv;
 	int ret;
 	unsigned long flags;
-	u8 i;
 
 	lbtf_deb_enter(LBTF_DEB_SDIO);
 
@@ -414,10 +427,14 @@ static void if_sdio_host_to_card_worker(struct work_struct *work)
 			break;
 
 		// Check for removed device
-		if (card->priv->surpriseremoved) {
-			lbtf_deb_sdio("Device removed\n");
-			kfree(packet);
-			break;
+		if (card->priv) {
+			if (card->priv->surpriseremoved) {
+				lbtf_deb_sdio("Device removed\n");
+				kfree(packet);
+				break;
+			}
+		} else {
+			lbtf_deb_sdio("host->card called during init, assuming device exists");
 		}
 
 		sdio_claim_host(card->func);
@@ -687,7 +704,7 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 	/*
 	 * Disable interrupts
 	 */
-	ret = if_sdio_disable_interrupts(card->priv);
+	ret = _if_sdio_disable_interrupts(card);
 	if (ret)
 		pr_warning("unable to disable interrupts: %d", ret);
 
@@ -709,7 +726,6 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 		if( lbtf_reset_fw == 0 ) {
 			goto success;
 		} else {
-			int i = 0;
 			lbtf_deb_sdio("attempting to reset and reload firmware\n");
 
 			if_sdio_reset_device(card);
@@ -733,15 +749,6 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 	lbtf_deb_sdio("Firmware loaded\n");
 
 success:
-	/*
-	 * Enable interrupts now that everything is set up
-	 */
-	ret = if_sdio_enable_interrupts(card->priv);
-	if (ret) {
-		pr_err("Error enabling interrupts: %d", ret);
-		goto out;
-	}
-
 	sdio_claim_host(card->func);
 	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
 	sdio_release_host(card->func);
@@ -756,19 +763,16 @@ out:
 /* Libertas callbacks                                              */
 /*******************************************************************/
 
-static int if_sdio_host_to_card(struct lbtf_private *priv,
+static int _if_sdio_host_to_card(struct if_sdio_card *card,
 		u8 type, u8 *buf, u16 nb)
 {
 	int ret;
-	struct if_sdio_card *card;
 	struct if_sdio_packet *packet, *cur;
 	u16 size;
 	unsigned long flags;
 
 	lbtf_deb_enter_args(LBTF_DEB_SDIO, "type %d, bytes %d", type, nb);
 
-	card = priv->card;
-
 	if (nb > (65536 - sizeof(struct if_sdio_packet) - 4)) {
 		ret = -EINVAL;
 		goto out;
@@ -812,6 +816,27 @@ static int if_sdio_host_to_card(struct lbtf_private *priv,
 		cur->next = packet;
 	}
 
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	queue_work(card->workqueue, &card->packet_worker);
+
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_host_to_card(struct lbtf_private *priv,
+		u8 type, u8 *buf, u16 nb)
+{
+	struct if_sdio_card *card;
+	unsigned long flags;
+
+	card = priv->card;
+
+	spin_lock_irqsave(&card->lock, flags);
 	/* TODO: the dndl_sent has to do with sleep stuff.
 	 * Commented out till we add that.
 	 */
@@ -825,17 +850,9 @@ static int if_sdio_host_to_card(struct lbtf_private *priv,
 	default:
 		lbtf_deb_sdio("unknown packet type %d\n", (int)type);
 	}
-
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	queue_work(card->workqueue, &card->packet_worker);
-
-	ret = 0;
-
-out:
-	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
-
-	return ret;
+	return _if_sdio_host_to_card(card, type, buf, nb);
 }
 
 static int if_sdio_enter_deep_sleep(struct lbtf_private *priv)
@@ -846,7 +863,6 @@ static int if_sdio_enter_deep_sleep(struct lbtf_private *priv)
 
 static int if_sdio_exit_deep_sleep(struct lbtf_private *priv)
 {
-	struct if_sdio_card *card = priv->card;
 	int ret = -1;
 
 	lbtf_deb_enter(LBTF_DEB_SDIO);
@@ -857,14 +873,12 @@ static int if_sdio_exit_deep_sleep(struct lbtf_private *priv)
 
 static int if_sdio_reset_deep_sleep_wakeup(struct lbtf_private *priv)
 {
-	struct if_sdio_card *card = priv->card;
 	int ret = -1;
 
 	lbtf_deb_enter(LBTF_DEB_SDIO);
 
 	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
 	return ret;
-
 }
 
 static void if_sdio_reset_device(struct if_sdio_card *card)
@@ -878,7 +892,7 @@ static void if_sdio_reset_device(struct if_sdio_card *card)
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_HALT);
 
-	if_sdio_host_to_card(card->priv, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
+	_if_sdio_host_to_card(card, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
 
 	msleep(1000);
 
@@ -888,6 +902,157 @@ static void if_sdio_reset_device(struct if_sdio_card *card)
 }
 EXPORT_SYMBOL_GPL(if_sdio_reset_device);
 
+/**
+ *  lbtf_update_hw_spec: Updates the hardware details.
+ *
+ *  @priv    	A pointer to struct lbtf_private structure
+ *
+ *  Returns: 0 on success, error on failure
+ */
+int if_sdio_update_hw_spec(struct if_sdio_card *card)
+{
+	struct cmd_ds_get_hw_spec cmd;
+	int ret = -1;
+	unsigned long timeout;
+	u16 size, type, chunk;
+	int wait_cmd_done = 0;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	/* Send hw spec command */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.hdr.command = cpu_to_le16(CMD_GET_HW_SPEC);
+	memcpy(cmd.permanentaddr, card->hw_addr, ETH_ALEN);
+	ret = _if_sdio_host_to_card(card, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
+	if (ret) {
+		goto out;
+	}
+
+	/* Wait for and retrieve response */
+	timeout = jiffies + HZ;
+	while (wait_cmd_done < 1) {
+		/* Wait for response to cmd */
+		sdio_claim_host(card->func);
+		ret = if_sdio_wait_status(card, IF_SDIO_UL_RDY);
+		sdio_release_host(card->func);
+		if (ret) {
+			/* time-out */
+			lbtf_deb_sdio("error waiting on IO ready");
+			goto out;
+		}
+
+		/* get the rx size */
+		sdio_claim_host(card->func);
+		size = if_sdio_read_rx_len(card, &ret);
+		sdio_release_host(card->func);
+		if (ret)
+			goto out;
+
+		if (size == 0) {
+		} else if (size < 4) {
+			lbtf_deb_sdio("invalid packet size (%d bytes) from firmware\n",
+				(int)size);
+			ret = -EINVAL;
+			goto out;
+		} else /* size > 4 */ {
+			/*
+			 * Get command response.
+			 *
+			 * The transfer must be in one transaction or the firmware
+			 * goes suicidal. There's no way to guarantee that for all
+			 * controllers, but we can at least try.
+			 */
+			sdio_claim_host(card->func);
+			chunk = sdio_align_size(card->func, size);
+
+			ret = sdio_readsb(card->func, card->buffer, card->ioport, chunk);
+			sdio_release_host(card->func);
+			if (ret)
+				goto out;
+
+			chunk = card->buffer[0] | (card->buffer[1] << 8);
+			type = card->buffer[2] | (card->buffer[3] << 8);
+
+			lbtf_deb_sdio("packet of type %d and size %d bytes\n",
+				(int)type, (int)chunk);
+
+			lbtf_deb_hex(LBTF_DEB_SDIO, "SDIO Rx: ", card->buffer,
+						 min_t(unsigned int, size, 100));
+
+			if (chunk > size) {
+				lbtf_deb_sdio("packet fragment (%d > %d)\n",
+					(int)chunk, (int)size);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (chunk < size) {
+				lbtf_deb_sdio("packet fragment (%d < %d)\n",
+					(int)chunk, (int)size);
+			}
+
+			switch (type) {
+			case MVMS_DAT:
+				lbtf_deb_sdio("Got MVMS_DAT");
+				continue;
+			case MVMS_CMD:
+				lbtf_deb_sdio("Got MVMS_CMD");
+				memcpy(&cmd, card->buffer +4, sizeof(cmd));
+				wait_cmd_done = 1;
+				break;
+			case MVMS_EVENT:
+				lbtf_deb_sdio("Got MVMS_EVENT");
+				continue;
+			default:
+				lbtf_deb_sdio("invalid type (%d) from firmware\n",
+						(int)type);
+				ret = -EINVAL;
+				goto out;
+			}
+		} /* size > 4 */
+
+		if (!wait_cmd_done) {
+			if (time_after(jiffies, timeout)) {
+				ret = -ETIMEDOUT;
+				pr_warning("Update hw spec cmd timed out\n");
+				ret = -1;
+				goto out;
+			}
+
+			msleep(10);
+		}
+	}
+
+	lbtf_deb_sdio("Got hw spec command response");
+
+	/* Process cmd return */
+	card->fwcapinfo = le32_to_cpu(cmd.fwcapinfo);
+
+	/* The firmware release is in an interesting format: the patch
+	 * level is in the most significant nibble ... so fix that: */
+	card->fwrelease = le32_to_cpu(cmd.fwrelease);
+	card->fwrelease = (card->fwrelease << 8) |
+		(card->fwrelease >> 24 & 0xff);
+
+	printk(KERN_INFO "libertas_tf_sdio: %pM, fw %u.%u.%up%u, cap 0x%08x\n",
+		cmd.permanentaddr,
+		card->fwrelease >> 24 & 0xff,
+		card->fwrelease >> 16 & 0xff,
+		card->fwrelease >>  8 & 0xff,
+		card->fwrelease       & 0xff,
+		card->fwcapinfo);
+	lbtf_deb_sdio("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
+		    cmd.hwifversion, cmd.version);
+
+	memmove(card->hw_addr, cmd.permanentaddr, ETH_ALEN);
+
+out:
+	lbtf_deb_leave(LBTF_DEB_SDIO);
+	return ret;
+}
+
+
 /*******************************************************************/
 /* SDIO callbacks                                                  */
 /*******************************************************************/
@@ -919,8 +1084,8 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	 * successfully received the command.
 	 */
 	if (cause & IF_SDIO_H_INT_DNLD)
-		lbtf_host_to_card_done(card->priv);
-
+		if (card->priv)
+			lbtf_host_to_card_done(card->priv);
 
 	if (cause & IF_SDIO_H_INT_UPLD) {
 		ret = if_sdio_card_to_host(card);
@@ -1065,7 +1230,26 @@ static int if_sdio_probe(struct sdio_func *func,
 			func->class, func->vendor, func->device,
 			model, (unsigned)card->ioport);
 
-	priv = lbtf_add_card(card, &func->dev);
+	/* Upload firmware */
+	lbtf_deb_sdio("Going to upload fw...");
+	if (if_sdio_prog_firmware(card))
+		goto reclaim;
+
+	/*
+	 * We need to get the hw spec here because we must have the
+	 * MAC address before we call lbtf_add_card
+	 *
+	 * Read priv address from HW
+	 */
+	memset(card->hw_addr, 0xff, ETH_ALEN);
+	ret = if_sdio_update_hw_spec(card);
+	if (ret) {
+		ret = -1;
+		pr_err("Error fetching MAC address from hardware.");
+		goto reclaim;
+	}
+
+	priv = lbtf_add_card(card, &func->dev, card->hw_addr);
 	if (!priv) {
 		ret = -ENOMEM;
 		goto reclaim;
@@ -1075,7 +1259,6 @@ static int if_sdio_probe(struct sdio_func *func,
 	priv->card = card;
 
 	priv->hw_host_to_card = if_sdio_host_to_card;
-	priv->hw_prog_firmware = if_sdio_prog_firmware;
 	priv->enter_deep_sleep = if_sdio_enter_deep_sleep;
 	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
 	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index bedb6b1..c7588fd 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -498,7 +498,7 @@ void lbtf_cmd_response_rx(struct lbtf_private *priv);
 /* main.c */
 struct chan_freq_power *lbtf_get_region_cfp_table(u8 region,
 	int *cfp_no);
-struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev);
+struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev, u8 mac_addr[ETH_ALEN]);
 int lbtf_remove_card(struct lbtf_private *priv);
 int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb);
 void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail);
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 119d625..14ce1bc 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -150,14 +150,15 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
 	int ret = -1;
 
 	lbtf_deb_enter(LBTF_DEB_FW);
+
 	/*
 	 * Read priv address from HW
 	 */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	ret = lbtf_update_hw_spec(priv);
 	if (ret) {
-		ret = -1;
-		goto done;
+		   ret = -1;
+		   goto done;
 	}
 
 	lbtf_set_mac_control(priv);
@@ -165,6 +166,7 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
 	lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
 
 	ret = 0;
+
 done:
 	lbtf_deb_leave_args(LBTF_DEB_FW, "ret: %d", ret);
 	return ret;
@@ -325,18 +327,20 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (!priv->fw_ready) {
-		lbtf_deb_main("Going to upload fw...");
-		/* Upload firmware */
-		if (priv->hw_prog_firmware(card))
-			goto err_prog_firmware;
-		else
-			priv->fw_ready = 1;
-	} else {
-		if (priv->enable_interrupts) {
-			priv->enable_interrupts(priv);
+	if (priv->hw_prog_firmware) {
+		if (!priv->fw_ready) {
+			lbtf_deb_main("Going to upload fw...");
+			/* Upload firmware */
+			if (priv->hw_prog_firmware(card))
+				goto err_prog_firmware;
+			else
+				priv->fw_ready = 1;
+		} else {
+			if (priv->enable_interrupts) {
+				priv->enable_interrupts(priv);
+			}
+			lbtf_deb_main("FW was already ready...");
 		}
-		lbtf_deb_main("FW was already ready...");
 	}
 
 	/* poke the firmware */
@@ -433,6 +437,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 		lbtf_set_mac_address(priv, (u8 *) vif->addr);
 	}
 
+
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 }
@@ -663,7 +668,7 @@ EXPORT_SYMBOL_GPL(lbtf_rx);
  *
  *  Returns: pointer to struct lbtf_priv.
  */
-struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
+struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev, u8 mac_addr[ETH_ALEN])
 {
 	struct ieee80211_hw *hw;
 	struct lbtf_private *priv = NULL;
@@ -701,6 +706,11 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 
 	INIT_WORK(&priv->cmd_work, lbtf_cmd_work);
 	INIT_WORK(&priv->tx_work, lbtf_tx_work);
+
+	printk(KERN_INFO "libertas_tf: Marvell WLAN 802.11 thinfirm adapter\n");
+
+	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
+
 	if (ieee80211_register_hw(hw))
 		goto err_init_adapter;
 
-- 
1.7.0

