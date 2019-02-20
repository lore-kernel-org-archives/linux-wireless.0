Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0617C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9158620685
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfBTK7E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:59:04 -0500
Received: from shell.v3.sk ([90.176.6.54]:59840 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfBTK7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:59:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id DDF51101A5B;
        Wed, 20 Feb 2019 11:59:00 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FuVoN_aGiGFk; Wed, 20 Feb 2019 11:58:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id BFEBE101A65;
        Wed, 20 Feb 2019 11:58:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3QXePhZhG7M7; Wed, 20 Feb 2019 11:58:49 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id D3767101A5D;
        Wed, 20 Feb 2019 11:58:48 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v2 2/3] libertas_tf: don't defer firmware loading until start()
Date:   Wed, 20 Feb 2019 11:58:39 +0100
Message-Id: <20190220105840.793525-3-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220105840.793525-1-lkundrak@v3.sk>
References: <20190220105840.793525-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to be able to get a MAC address before we register the device
with ieee80211 we'll need to load the firmware way earlier.

There seems to be one problem with this: the device seems to start
with radio enabled and starts sending in frames right after the firmware
load finishes. Disable the radio as soon as possible.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

---
Changes since v1:
- Fix build
- Reword the commit message not to call the firmware behavior a bug
- Move the radioon =3D RADIO_OFF initialization a bit earlier

 .../net/wireless/marvell/libertas_tf/if_usb.c | 24 +++++------
 .../marvell/libertas_tf/libertas_tf.h         |  5 +--
 .../net/wireless/marvell/libertas_tf/main.c   | 41 +++++++++++--------
 3 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/=
net/wireless/marvell/libertas_tf/if_usb.c
index 7a5a1a85dcf7..a4b9ede70705 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -42,14 +42,14 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
=20
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
-static int if_usb_prog_firmware(struct if_usb_card *cardp);
+static int if_usb_prog_firmware(struct lbtf_private *priv);
 static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
 			       uint8_t *payload, uint16_t nb);
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 			uint16_t nb, u8 data);
 static void if_usb_free(struct if_usb_card *cardp);
 static int if_usb_submit_rx_urb(struct if_usb_card *cardp);
-static int if_usb_reset_device(struct if_usb_card *cardp);
+static int if_usb_reset_device(struct lbtf_private *priv);
=20
 /**
  *  if_usb_wrike_bulk_callback -  call back to handle URB status
@@ -222,13 +222,11 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto dealloc;
 	}
=20
+	cardp->boot2_version =3D udev->descriptor.bcdDevice;
 	priv =3D lbtf_add_card(cardp, &udev->dev, &if_usb_ops);
 	if (!priv)
 		goto dealloc;
=20
-	cardp->priv =3D priv;
-	cardp->boot2_version =3D udev->descriptor.bcdDevice;
-
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
=20
@@ -253,7 +251,7 @@ static void if_usb_disconnect(struct usb_interface *i=
ntf)
=20
 	lbtf_deb_enter(LBTF_DEB_MAIN);
=20
-	if_usb_reset_device(cardp);
+	if_usb_reset_device(priv);
=20
 	if (priv)
 		lbtf_remove_card(priv);
@@ -336,8 +334,9 @@ static int if_usb_send_fw_pkt(struct if_usb_card *car=
dp)
 	return 0;
 }
=20
-static int if_usb_reset_device(struct if_usb_card *cardp)
+static int if_usb_reset_device(struct lbtf_private *priv)
 {
+	struct if_usb_card *cardp =3D priv->card;
 	struct cmd_ds_802_11_reset *cmd =3D cardp->ep_out_buf + 4;
 	int ret;
=20
@@ -808,14 +807,17 @@ static int check_fwfile_format(const u8 *data, u32 =
totlen)
 }
=20
=20
-static int if_usb_prog_firmware(struct if_usb_card *cardp)
+static int if_usb_prog_firmware(struct lbtf_private *priv)
 {
+	struct if_usb_card *cardp =3D priv->card;
 	int i =3D 0;
 	static int reset_count =3D 10;
 	int ret =3D 0;
=20
 	lbtf_deb_enter(LBTF_DEB_USB);
=20
+	cardp->priv =3D priv;
+
 	kernel_param_lock(THIS_MODULE);
 	ret =3D request_firmware(&cardp->fw, lbtf_fw_name, &cardp->udev->dev);
 	if (ret < 0) {
@@ -851,7 +853,7 @@ static int if_usb_prog_firmware(struct if_usb_card *c=
ardp)
=20
 	if (cardp->bootcmdresp <=3D 0) {
 		if (--reset_count >=3D 0) {
-			if_usb_reset_device(cardp);
+			if_usb_reset_device(priv);
 			goto restart;
 		}
 		return -1;
@@ -880,7 +882,7 @@ static int if_usb_prog_firmware(struct if_usb_card *c=
ardp)
 	if (!cardp->fwdnldover) {
 		pr_info("failed to load fw, resetting device!\n");
 		if (--reset_count >=3D 0) {
-			if_usb_reset_device(cardp);
+			if_usb_reset_device(priv);
 			goto restart;
 		}
=20
@@ -889,8 +891,6 @@ static int if_usb_prog_firmware(struct if_usb_card *c=
ardp)
 		goto release_fw;
 	}
=20
-	cardp->priv->fw_ready =3D 1;
-
  release_fw:
 	release_firmware(cardp->fw);
 	cardp->fw =3D NULL;
diff --git a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h b/dri=
vers/net/wireless/marvell/libertas_tf/libertas_tf.h
index 11d5ff68bc5e..3ed1fbe28798 100644
--- a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
@@ -177,8 +177,8 @@ struct lbtf_ops {
 	/** Hardware access */
 	int (*hw_host_to_card)(struct lbtf_private *priv, u8 type,
 			       u8 *payload, u16 nb);
-	int (*hw_prog_firmware)(struct if_usb_card *cardp);
-	int (*hw_reset_device)(struct if_usb_card *cardp);
+	int (*hw_prog_firmware)(struct lbtf_private *priv);
+	int (*hw_reset_device)(struct lbtf_private *priv);
 };
=20
 /** Private structure for the MV device */
@@ -254,7 +254,6 @@ struct lbtf_private {
 	struct ieee80211_supported_band band;
 	struct lbtf_offset_value offsetvalue;
=20
-	u8 fw_ready;
 	u8 surpriseremoved;
 	struct sk_buff_head bc_ps_buf;
=20
diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/ne=
t/wireless/marvell/libertas_tf/main.c
index a9c04ca75ccc..d8bf0a4071da 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -118,11 +118,6 @@ static void lbtf_cmd_work(struct work_struct *work)
 	priv->cmd_timed_out =3D 0;
 	spin_unlock_irq(&priv->driver_lock);
=20
-	if (!priv->fw_ready) {
-		lbtf_deb_leave_args(LBTF_DEB_CMD, "fw not ready");
-		return;
-	}
-
 	/* Execute the next command */
 	if (!priv->cur_cmd)
 		lbtf_execute_next_command(priv);
@@ -294,36 +289,29 @@ static void lbtf_tx_work(struct work_struct *work)
 static int lbtf_op_start(struct ieee80211_hw *hw)
 {
 	struct lbtf_private *priv =3D hw->priv;
-	void *card =3D priv->card;
 	int ret =3D -1;
=20
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
=20
-	if (!priv->fw_ready)
-		/* Upload firmware */
-		if (priv->ops->hw_prog_firmware(card))
-			goto err_prog_firmware;
-
 	/* poke the firmware */
 	priv->capability =3D WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->radioon =3D RADIO_ON;
 	priv->mac_control =3D CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	ret =3D lbtf_setup_firmware(priv);
 	if (ret)
-		goto err_prog_firmware;
+		goto err_setup_firmware;
=20
 	if ((priv->fwrelease < LBTF_FW_VER_MIN) ||
 	    (priv->fwrelease > LBTF_FW_VER_MAX)) {
 		ret =3D -1;
-		goto err_prog_firmware;
+		goto err_setup_firmware;
 	}
=20
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
=20
-err_prog_firmware:
-	priv->ops->hw_reset_device(card);
-	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programming fw; ret=3D%d", =
ret);
+err_setup_firmware:
+	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "fw setup error; ret=3D%d", ret);
 	return ret;
 }
=20
@@ -554,6 +542,11 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buf=
f *skb)
=20
 	lbtf_deb_enter(LBTF_DEB_RX);
=20
+	if (priv->radioon !=3D RADIO_ON) {
+		lbtf_deb_rx("rx before we turned on the radio");
+		goto done;
+	}
+
 	prxpd =3D (struct rxpd *) skb->data;
=20
 	memset(&stats, 0, sizeof(stats));
@@ -591,13 +584,14 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_bu=
ff *skb)
=20
 	ieee80211_rx_irqsafe(priv->hw, skb);
=20
+done:
 	lbtf_deb_leave(LBTF_DEB_RX);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbtf_rx);
=20
 /**
- * lbtf_add_card: Add and initialize the card, no fw upload yet.
+ * lbtf_add_card: Add and initialize the card.
  *
  *  @card    A pointer to card
  *
@@ -623,6 +617,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct=
 device *dmdev,
 	priv->card =3D card;
 	priv->ops =3D ops;
 	priv->tx_skb =3D NULL;
+	priv->radioon =3D RADIO_OFF;
=20
 	hw->queues =3D 1;
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
@@ -646,6 +641,18 @@ struct lbtf_private *lbtf_add_card(void *card, struc=
t device *dmdev,
=20
 	INIT_WORK(&priv->cmd_work, lbtf_cmd_work);
 	INIT_WORK(&priv->tx_work, lbtf_tx_work);
+
+	if (priv->ops->hw_prog_firmware(priv)) {
+		lbtf_deb_usbd(dmdev, "Error programming the firmware\n");
+		priv->ops->hw_reset_device(priv);
+		goto err_init_adapter;
+	}
+
+	/* The firmware seems to start with the radio enabled. Turn it
+	 * off before an actual mac80211 start callback is invoked.
+	 */
+	lbtf_set_radio_control(priv);
+
 	if (ieee80211_register_hw(hw))
 		goto err_init_adapter;
=20
--=20
2.20.1

