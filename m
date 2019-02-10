Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A857DC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E25D2145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfBJTsa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 14:48:30 -0500
Received: from shell.v3.sk ([90.176.6.54]:42472 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfBJTsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 14:48:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id AFA49CE774;
        Sun, 10 Feb 2019 20:48:27 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZTz23JhNe9zo; Sun, 10 Feb 2019 20:48:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 03FC2CE830;
        Sun, 10 Feb 2019 20:48:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AOeyUViiJJHm; Sun, 10 Feb 2019 20:48:24 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 6734ACE822;
        Sun, 10 Feb 2019 20:48:24 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas_tf: fix signal reporting
Date:   Sun, 10 Feb 2019 20:48:22 +0100
Message-Id: <20190210194822.18539-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Instead of exposing the signal-to-noise ration, calculate the actual sign=
al
level taking the noise floor into account.

Also, flip the SIGNAL_DBM bit on, so that mac80211 exposes the signal
level along with the station info in scan results. This fills
NetworkManager's "nmcli d wifi output" output with colors, bars and joy.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/ne=
t/wireless/marvell/libertas_tf/main.c
index c71ad87cdc44..f93b400db949 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -562,7 +562,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff=
 *skb)
 		stats.flag |=3D RX_FLAG_FAILED_FCS_CRC;
 	stats.freq =3D priv->cur_freq;
 	stats.band =3D NL80211_BAND_2GHZ;
-	stats.signal =3D prxpd->snr;
+	stats.signal =3D prxpd->snr - prxpd->nf;
 	priv->noise =3D prxpd->nf;
 	/* Marvell rate index has a hole at value 4 */
 	if (prxpd->rx_rate > 4)
@@ -626,6 +626,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct=
 device *dmdev)
=20
 	hw->queues =3D 1;
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
 	hw->extra_tx_headroom =3D sizeof(struct txpd);
 	memcpy(priv->channels, lbtf_channels, sizeof(lbtf_channels));
 	memcpy(priv->rates, lbtf_rates, sizeof(lbtf_rates));
--=20
2.20.1

