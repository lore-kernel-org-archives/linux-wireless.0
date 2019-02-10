Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049F3C282D7
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDC62145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfBJTsS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 14:48:18 -0500
Received: from shell.v3.sk ([90.176.6.54]:42460 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfBJTsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 14:48:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 967E6CE822;
        Sun, 10 Feb 2019 20:48:16 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7W-aDqWSDDPL; Sun, 10 Feb 2019 20:48:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 255A3CE833;
        Sun, 10 Feb 2019 20:48:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hMu3tcAWSi0x; Sun, 10 Feb 2019 20:48:13 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 87275CE832;
        Sun, 10 Feb 2019 20:48:13 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas_tf: move the banner to a more appropriate place
Date:   Sun, 10 Feb 2019 20:48:11 +0100
Message-Id: <20190210194811.18345-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Also, turn it to a dev_info() to make checkpatch.pl happy.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/ne=
t/wireless/marvell/libertas_tf/main.c
index 1d45da187b9b..c71ad87cdc44 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -318,7 +318,6 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 		goto err_prog_firmware;
 	}
=20
-	printk(KERN_INFO "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
=20
@@ -649,6 +648,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct=
 device *dmdev)
 	if (ieee80211_register_hw(hw))
 		goto err_init_adapter;
=20
+	dev_info(dmdev, "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
 	goto done;
=20
 err_init_adapter:
--=20
2.20.1

