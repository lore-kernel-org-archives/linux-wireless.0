Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C07EC282CC
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C2B2145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfBJTwd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 14:52:33 -0500
Received: from shell.v3.sk ([90.176.6.54]:42516 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfBJTwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 14:52:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id C4053CE7AD;
        Sun, 10 Feb 2019 20:52:28 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id sLPQkU6FFNvy; Sun, 10 Feb 2019 20:52:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 45BE3CE833;
        Sun, 10 Feb 2019 20:52:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BkG0HCdkhpcS; Sun, 10 Feb 2019 20:52:21 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id C56D2CE837;
        Sun, 10 Feb 2019 20:52:20 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 3/3] libertas_tf: get the MAC address before registering the device
Date:   Sun, 10 Feb 2019 20:52:17 +0100
Message-Id: <20190210195217.18817-4-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210195217.18817-1-lkundrak@v3.sk>
References: <20190210195217.18817-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The start() callback is too late for this: NetworkManager would already
have seen the hardware, thinking 00:00:00:00:00:00 is its permanent
address.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 .../net/wireless/marvell/libertas_tf/main.c   | 57 ++++---------------
 1 file changed, 11 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/ne=
t/wireless/marvell/libertas_tf/main.c
index b4bd3047eb4e..da53da71987e 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -125,37 +125,6 @@ static void lbtf_cmd_work(struct work_struct *work)
 	lbtf_deb_leave(LBTF_DEB_CMD);
 }
=20
-/**
- *  lbtf_setup_firmware: initialize firmware.
- *
- *  @priv    A pointer to struct lbtf_private structure
- *
- *  Returns: 0 on success.
- */
-static int lbtf_setup_firmware(struct lbtf_private *priv)
-{
-	int ret =3D -1;
-
-	lbtf_deb_enter(LBTF_DEB_FW);
-	/*
-	 * Read priv address from HW
-	 */
-	eth_broadcast_addr(priv->current_addr);
-	ret =3D lbtf_update_hw_spec(priv);
-	if (ret) {
-		ret =3D -1;
-		goto done;
-	}
-
-	lbtf_set_mac_control(priv);
-	lbtf_set_radio_control(priv);
-
-	ret =3D 0;
-done:
-	lbtf_deb_leave_args(LBTF_DEB_FW, "ret: %d", ret);
-	return ret;
-}
-
 /**
  *  This function handles the timeout of command sending.
  *  It will re-send the same command again.
@@ -289,30 +258,17 @@ static void lbtf_tx_work(struct work_struct *work)
 static int lbtf_op_start(struct ieee80211_hw *hw)
 {
 	struct lbtf_private *priv =3D hw->priv;
-	int ret =3D -1;
=20
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
=20
-	/* poke the firmware */
 	priv->capability =3D WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->radioon =3D RADIO_ON;
 	priv->mac_control =3D CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
-	ret =3D lbtf_setup_firmware(priv);
-	if (ret)
-		goto err_setup_firmware;
-
-	if ((priv->fwrelease < LBTF_FW_VER_MIN) ||
-	    (priv->fwrelease > LBTF_FW_VER_MAX)) {
-		ret =3D -1;
-		goto err_setup_firmware;
-	}
+	lbtf_set_mac_control(priv);
+	lbtf_set_radio_control(priv);
=20
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
-
-err_setup_firmware:
-	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "fw setup error; ret=3D%d", ret);
-	return ret;
 }
=20
 static void lbtf_op_stop(struct ieee80211_hw *hw)
@@ -649,6 +605,15 @@ struct lbtf_private *lbtf_add_card(void *card, struc=
t device *dmdev,
 		goto err_init_adapter;
 	}
=20
+	eth_broadcast_addr(priv->current_addr);
+	if (lbtf_update_hw_spec(priv))
+		goto err_init_adapter;
+
+	if (priv->fwrelease < LBTF_FW_VER_MIN ||
+	    priv->fwrelease > LBTF_FW_VER_MAX) {
+		goto err_init_adapter;
+	}
+
 	/* The firmware seems to start with the radio enabled. Turn it
 	 * off before an actual mac80211 start callback is invoked.
 	 */
--=20
2.20.1

