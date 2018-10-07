Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB63EC46475
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA99206B2
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EA99206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbeJGHi5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 03:38:57 -0400
Received: from shell.v3.sk ([90.176.6.54]:37416 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbeJGHi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 03:38:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 5DBD8BC9D0;
        Sun,  7 Oct 2018 02:33:35 +0200 (CEST)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ce_ZhLh4Dceg; Sun,  7 Oct 2018 02:33:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 2044ABC9D2;
        Sun,  7 Oct 2018 02:33:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id heItqBYkrIEz; Sun,  7 Oct 2018 02:33:31 +0200 (CEST)
Received: from belphegor.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 449C4BC9D0;
        Sun,  7 Oct 2018 02:33:31 +0200 (CEST)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v2] libertas: return errno from lbs_add_card()
Date:   Sun,  7 Oct 2018 02:33:27 +0200
Message-Id: <20181007003327.2806010-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes the error handling somewhat cleaner -- lbs_add_card() does no
logner throw away the errno and lets its callers propagate it.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
Changes since v1:
- Address SPI & USB build failures

 drivers/net/wireless/marvell/libertas/if_cs.c   |  4 ++--
 drivers/net/wireless/marvell/libertas/if_sdio.c |  4 ++--
 drivers/net/wireless/marvell/libertas/if_spi.c  |  4 ++--
 drivers/net/wireless/marvell/libertas/if_usb.c  |  5 ++++-
 drivers/net/wireless/marvell/libertas/main.c    | 17 ++++++++++-------
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_cs.c b/drivers/net/=
wireless/marvell/libertas/if_cs.c
index 7d88223f890b..cebf03c6a622 100644
--- a/drivers/net/wireless/marvell/libertas/if_cs.c
+++ b/drivers/net/wireless/marvell/libertas/if_cs.c
@@ -900,8 +900,8 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
=20
 	/* Make this card known to the libertas driver */
 	priv =3D lbs_add_card(card, &p_dev->dev);
-	if (!priv) {
-		ret =3D -ENOMEM;
+	if (IS_ERR(priv)) {
+		ret =3D PTR_ERR(priv);
 		goto out2;
 	}
=20
diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/ne=
t/wireless/marvell/libertas/if_sdio.c
index 43743c26c071..2fd54a0aeb5a 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -1206,8 +1206,8 @@ static int if_sdio_probe(struct sdio_func *func,
=20
=20
 	priv =3D lbs_add_card(card, &func->dev);
-	if (!priv) {
-		ret =3D -ENOMEM;
+	if (IS_ERR(priv)) {
+		ret =3D PTR_ERR(priv);
 		goto free;
 	}
=20
diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net=
/wireless/marvell/libertas/if_spi.c
index e9aec6cb1105..504d6e096476 100644
--- a/drivers/net/wireless/marvell/libertas/if_spi.c
+++ b/drivers/net/wireless/marvell/libertas/if_spi.c
@@ -1146,8 +1146,8 @@ static int if_spi_probe(struct spi_device *spi)
 	 * This will call alloc_etherdev.
 	 */
 	priv =3D lbs_add_card(card, &spi->dev);
-	if (!priv) {
-		err =3D -ENOMEM;
+	if (IS_ERR(priv)) {
+		err =3D PTR_ERR(priv);
 		goto free_card;
 	}
 	card->priv =3D priv;
diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net=
/wireless/marvell/libertas/if_usb.c
index c67a8e7be310..5fee555a3d60 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -254,8 +254,11 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto dealloc;
 	}
=20
-	if (!(priv =3D lbs_add_card(cardp, &intf->dev)))
+	priv =3D lbs_add_card(cardp, &intf->dev);
+	if (IS_ERR(priv)) {
+		r =3D PTR_ERR(priv);
 		goto err_add_card;
+	}
=20
 	cardp->priv =3D priv;
=20
diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/w=
ireless/marvell/libertas/main.c
index f22e1c220cba..f7db60bc7c7f 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -907,25 +907,29 @@ struct lbs_private *lbs_add_card(void *card, struct=
 device *dmdev)
 	struct net_device *dev;
 	struct wireless_dev *wdev;
 	struct lbs_private *priv =3D NULL;
+	int err;
=20
 	/* Allocate an Ethernet device and register it */
 	wdev =3D lbs_cfg_alloc(dmdev);
 	if (IS_ERR(wdev)) {
+		err =3D PTR_ERR(wdev);
 		pr_err("cfg80211 init failed\n");
-		goto done;
+		goto err_cfg;
 	}
=20
 	wdev->iftype =3D NL80211_IFTYPE_STATION;
 	priv =3D wdev_priv(wdev);
 	priv->wdev =3D wdev;
=20
-	if (lbs_init_adapter(priv)) {
+	err =3D lbs_init_adapter(priv);
+	if (err) {
 		pr_err("failed to initialize adapter structure\n");
 		goto err_wdev;
 	}
=20
 	dev =3D alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, ether_setup);
 	if (!dev) {
+		err =3D -ENOMEM;
 		dev_err(dmdev, "no memory for network device instance\n");
 		goto err_adapter;
 	}
@@ -949,6 +953,7 @@ struct lbs_private *lbs_add_card(void *card, struct d=
evice *dmdev)
 	init_waitqueue_head(&priv->waitq);
 	priv->main_thread =3D kthread_run(lbs_thread, dev, "lbs_main");
 	if (IS_ERR(priv->main_thread)) {
+		err =3D PTR_ERR(priv->main_thread);
 		lbs_deb_thread("Error creating main thread.\n");
 		goto err_ndev;
 	}
@@ -961,7 +966,7 @@ struct lbs_private *lbs_add_card(void *card, struct d=
evice *dmdev)
 	priv->wol_gap =3D 20;
 	priv->ehs_remove_supported =3D true;
=20
-	goto done;
+	return priv;
=20
  err_ndev:
 	free_netdev(dev);
@@ -972,10 +977,8 @@ struct lbs_private *lbs_add_card(void *card, struct =
device *dmdev)
  err_wdev:
 	lbs_cfg_free(priv);
=20
-	priv =3D NULL;
-
-done:
-	return priv;
+ err_cfg:
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(lbs_add_card);
=20
--=20
2.19.0

