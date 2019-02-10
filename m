Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F75C282CC
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD482145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfBJTrr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 14:47:47 -0500
Received: from shell.v3.sk ([90.176.6.54]:42432 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfBJTrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 14:47:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 13B38CE822;
        Sun, 10 Feb 2019 20:47:44 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id vyLzXK0_5dBI; Sun, 10 Feb 2019 20:47:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 80B80CE82E;
        Sun, 10 Feb 2019 20:47:41 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kr5Mrupa6cjr; Sun, 10 Feb 2019 20:47:41 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id AFB7DCE822;
        Sun, 10 Feb 2019 20:47:40 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas_tf: lower the debug level of command trace
Date:   Sun, 10 Feb 2019 20:47:35 +0100
Message-Id: <20190210194735.17939-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Logging each and every command response is way too much for INFO level.
Silence this, unless CONFIG_LIBERTAS_THINFIRM_DEBUG has been enabled.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas_tf/cmd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net=
/wireless/marvell/libertas_tf/cmd.c
index 909ac3685010..64b147dd2432 100644
--- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
+++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
@@ -737,10 +737,9 @@ int lbtf_process_rx_command(struct lbtf_private *pri=
v)
 	respcmd =3D le16_to_cpu(resp->command);
 	result =3D le16_to_cpu(resp->result);
=20
-	if (net_ratelimit())
-		pr_info("libertastf: cmd response 0x%04x, seq %d, size %d\n",
-			respcmd, le16_to_cpu(resp->seqnum),
-			le16_to_cpu(resp->size));
+	lbtf_deb_cmd("libertastf: cmd response 0x%04x, seq %d, size %d\n",
+		     respcmd, le16_to_cpu(resp->seqnum),
+		     le16_to_cpu(resp->size));
=20
 	if (resp->seqnum !=3D priv->cur_cmd->cmdbuf->seqnum) {
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
--=20
2.20.1

