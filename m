Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C82CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D2E20685
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfBTK7N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:59:13 -0500
Received: from shell.v3.sk ([90.176.6.54]:59847 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfBTK7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:59:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 0051D101A60;
        Wed, 20 Feb 2019 11:59:01 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id KAZnHPdVu9vy; Wed, 20 Feb 2019 11:58:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 89265101A64;
        Wed, 20 Feb 2019 11:58:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ss00s03L0Fl6; Wed, 20 Feb 2019 11:58:49 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id A9C4E101A5C;
        Wed, 20 Feb 2019 11:58:48 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v2 1/3] libertas_tf: move hardware callbacks to a separate structure
Date:   Wed, 20 Feb 2019 11:58:38 +0100
Message-Id: <20190220105840.793525-2-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220105840.793525-1-lkundrak@v3.sk>
References: <20190220105840.793525-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We'll need to talk to the firmware to get a hardware address before
device is registered with ieee80211 subsystem at the end of
lbtf_add_card(). Hooking the callbacks after that is too late.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas_tf/cmd.c  |  2 +-
 .../net/wireless/marvell/libertas_tf/if_usb.c   | 12 +++++++-----
 .../wireless/marvell/libertas_tf/libertas_tf.h  | 17 +++++++++++------
 drivers/net/wireless/marvell/libertas_tf/main.c | 10 ++++++----
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net=
/wireless/marvell/libertas_tf/cmd.c
index 64b147dd2432..130f578daafd 100644
--- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
+++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
@@ -256,7 +256,7 @@ static void lbtf_submit_command(struct lbtf_private *=
priv,
 		     command, le16_to_cpu(cmd->seqnum), cmdsize);
 	lbtf_deb_hex(LBTF_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsiz=
e);
=20
-	ret =3D priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
+	ret =3D priv->ops->hw_host_to_card(priv, MVMS_CMD, (u8 *)cmd, cmdsize);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
=20
 	if (ret) {
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/=
net/wireless/marvell/libertas_tf/if_usb.c
index 6ede6168bd85..7a5a1a85dcf7 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -131,6 +131,12 @@ static void if_usb_fw_timeo(struct timer_list *t)
 	lbtf_deb_leave(LBTF_DEB_USB);
 }
=20
+static const struct lbtf_ops if_usb_ops =3D {
+	.hw_host_to_card =3D if_usb_host_to_card,
+	.hw_prog_firmware =3D if_usb_prog_firmware,
+	.hw_reset_device =3D if_usb_reset_device,
+};
+
 /**
  *  if_usb_probe - sets the configuration values
  *
@@ -216,15 +222,11 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto dealloc;
 	}
=20
-	priv =3D lbtf_add_card(cardp, &udev->dev);
+	priv =3D lbtf_add_card(cardp, &udev->dev, &if_usb_ops);
 	if (!priv)
 		goto dealloc;
=20
 	cardp->priv =3D priv;
-
-	priv->hw_host_to_card =3D if_usb_host_to_card;
-	priv->hw_prog_firmware =3D if_usb_prog_firmware;
-	priv->hw_reset_device =3D if_usb_reset_device;
 	cardp->boot2_version =3D udev->descriptor.bcdDevice;
=20
 	usb_get_dev(udev);
diff --git a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h b/dri=
vers/net/wireless/marvell/libertas_tf/libertas_tf.h
index ad77b92d0b41..11d5ff68bc5e 100644
--- a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
@@ -173,10 +173,19 @@ struct channel_range {
=20
 struct if_usb_card;
=20
+struct lbtf_ops {
+	/** Hardware access */
+	int (*hw_host_to_card)(struct lbtf_private *priv, u8 type,
+			       u8 *payload, u16 nb);
+	int (*hw_prog_firmware)(struct if_usb_card *cardp);
+	int (*hw_reset_device)(struct if_usb_card *cardp);
+};
+
 /** Private structure for the MV device */
 struct lbtf_private {
 	void *card;
 	struct ieee80211_hw *hw;
+	const struct lbtf_ops *ops;
=20
 	/* Command response buffer */
 	u8 cmd_resp_buff[LBS_UPLD_SIZE];
@@ -188,11 +197,6 @@ struct lbtf_private {
=20
 	struct work_struct cmd_work;
 	struct work_struct tx_work;
-	/** Hardware access */
-	int (*hw_host_to_card) (struct lbtf_private *priv, u8 type, u8 *payload=
, u16 nb);
-	int (*hw_prog_firmware) (struct if_usb_card *cardp);
-	int (*hw_reset_device) (struct if_usb_card *cardp);
-
=20
 	/** Wlan adapter data structure*/
 	/** STATUS variables */
@@ -486,7 +490,8 @@ void lbtf_cmd_response_rx(struct lbtf_private *priv);
 /* main.c */
 struct chan_freq_power *lbtf_get_region_cfp_table(u8 region,
 	int *cfp_no);
-struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev);
+struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
+				   const struct lbtf_ops *ops);
 int lbtf_remove_card(struct lbtf_private *priv);
 int lbtf_start_card(struct lbtf_private *priv);
 int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb);
diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/ne=
t/wireless/marvell/libertas_tf/main.c
index f048b57043c6..a9c04ca75ccc 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -281,7 +281,7 @@ static void lbtf_tx_work(struct work_struct *work)
 	BUG_ON(priv->tx_skb);
 	spin_lock_irq(&priv->driver_lock);
 	priv->tx_skb =3D skb;
-	err =3D priv->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len);
+	err =3D priv->ops->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len)=
;
 	spin_unlock_irq(&priv->driver_lock);
 	if (err) {
 		dev_kfree_skb_any(skb);
@@ -301,7 +301,7 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
=20
 	if (!priv->fw_ready)
 		/* Upload firmware */
-		if (priv->hw_prog_firmware(card))
+		if (priv->ops->hw_prog_firmware(card))
 			goto err_prog_firmware;
=20
 	/* poke the firmware */
@@ -322,7 +322,7 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 	return 0;
=20
 err_prog_firmware:
-	priv->hw_reset_device(card);
+	priv->ops->hw_reset_device(card);
 	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programming fw; ret=3D%d", =
ret);
 	return ret;
 }
@@ -603,7 +603,8 @@ EXPORT_SYMBOL_GPL(lbtf_rx);
  *
  *  Returns: pointer to struct lbtf_priv.
  */
-struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
+struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
+				   const struct lbtf_ops *ops)
 {
 	struct ieee80211_hw *hw;
 	struct lbtf_private *priv =3D NULL;
@@ -620,6 +621,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct=
 device *dmdev)
=20
 	priv->hw =3D hw;
 	priv->card =3D card;
+	priv->ops =3D ops;
 	priv->tx_skb =3D NULL;
=20
 	hw->queues =3D 1;
--=20
2.20.1

