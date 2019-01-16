Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C711EC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B4A205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391183AbfAPPQu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:16:50 -0500
Received: from shell.v3.sk ([90.176.6.54]:57057 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbfAPPQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 10:16:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 3216753FF1;
        Wed, 16 Jan 2019 16:16:47 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id YEISScXpwlOm; Wed, 16 Jan 2019 16:16:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id A9DAD54068;
        Wed, 16 Jan 2019 16:16:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8f-VP_OfzLES; Wed, 16 Jan 2019 16:16:39 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 1968953FF1;
        Wed, 16 Jan 2019 16:16:39 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas: remove ifdef OLPC noise
Date:   Wed, 16 Jan 2019 16:16:19 +0100
Message-Id: <20190116151618.1972197-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<asm/olpc.h> provides machine_is_olpc() stub for CONFIG_OLPC=3Dn,
compiler should just optimize the unneeded bits away.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net=
/wireless/marvell/libertas/if_usb.c
index 220dcdee8d2b..7b61c599948e 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -12,9 +12,7 @@
 #include <linux/usb.h>
 #include <linux/olpc-ec.h>
=20
-#ifdef CONFIG_OLPC
 #include <asm/olpc.h>
-#endif
=20
 #define DRV_NAME "usb8xxx"
=20
@@ -174,13 +172,11 @@ static void if_usb_fw_timeo(struct timer_list *t)
 	wake_up(&cardp->fw_wq);
 }
=20
-#ifdef CONFIG_OLPC
 static void if_usb_reset_olpc_card(struct lbs_private *priv)
 {
 	printk(KERN_CRIT "Resetting OLPC wireless via EC...\n");
 	olpc_ec_cmd(0x25, NULL, 0, NULL, 0);
 }
-#endif
=20
 /**
  * if_usb_probe - sets the configuration values
@@ -267,10 +263,8 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->exit_deep_sleep =3D NULL;
 	priv->reset_deep_sleep_wakeup =3D NULL;
 	priv->is_polling =3D false;
-#ifdef CONFIG_OLPC
 	if (machine_is_olpc())
 		priv->reset_card =3D if_usb_reset_olpc_card;
-#endif
=20
 	cardp->boot2_version =3D udev->descriptor.bcdDevice;
=20
@@ -395,10 +389,8 @@ static int if_usb_reset_device(struct if_usb_card *c=
ardp)
 	ret =3D usb_reset_device(cardp->udev);
 	msleep(100);
=20
-#ifdef CONFIG_OLPC
 	if (ret && machine_is_olpc())
 		if_usb_reset_olpc_card(NULL);
-#endif
=20
 	return ret;
 }
@@ -939,14 +931,12 @@ static int if_usb_suspend(struct usb_interface *int=
f, pm_message_t message)
 		goto out;
 	}
=20
-#ifdef CONFIG_OLPC
 	if (machine_is_olpc()) {
 		if (priv->wol_criteria =3D=3D EHS_REMOVE_WAKEUP)
 			olpc_ec_wakeup_clear(EC_SCI_SRC_WLAN);
 		else
 			olpc_ec_wakeup_set(EC_SCI_SRC_WLAN);
 	}
-#endif
=20
 	ret =3D lbs_suspend(priv);
 	if (ret)
--=20
2.20.1

