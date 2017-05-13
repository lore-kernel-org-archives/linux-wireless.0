Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36257 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdEMQlk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 12:41:40 -0400
Received: by mail-wr0-f194.google.com with SMTP id v42so10222163wrc.3
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 09:41:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] staging: rtl8192e: _rtl92e_dm_check_edca_turbo remove peername message.
Date: Sat, 13 May 2017 17:41:21 +0100
Message-Id: <20170513164121.14373-5-tvboxspy@gmail.com> (sfid-20170513_184151_217119_47C03D45)
In-Reply-To: <20170513164121.14373-1-tvboxspy@gmail.com>
References: <20170513164121.14373-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This kinda reports this as if it was an error message.

Now that bssid is reported at associate remove this piece of code
serves no purpose as there is no code for peers so remove it.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 1a43c684f9f3..b8205ebafd72 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -1693,22 +1693,6 @@ static void _rtl92e_dm_check_edca_turbo(struct net_device *dev)
 	if (priv->rtllib->pHTInfo->IOTAction & HT_IOT_ACT_DISABLE_EDCA_TURBO)
 		goto dm_CheckEdcaTurbo_EXIT;
 
-	{
-		u8 *peername[11] = {
-			"unknown", "realtek_90", "realtek_92se", "broadcom",
-			"ralink", "atheros", "cisco", "marvell", "92u_softap",
-			"self_softap"
-		};
-		static int wb_tmp;
-
-		if (wb_tmp == 0) {
-			netdev_info(dev,
-				    "%s():iot peer is %s, bssid: %pM\n",
-				    __func__, peername[pHTInfo->IOTPeer],
-				    priv->rtllib->current_network.bssid);
-			wb_tmp = 1;
-		}
-	}
 	if (!priv->rtllib->bis_any_nonbepkts) {
 		curTxOkCnt = priv->stats.txbytesunicast - lastTxOkCnt;
 		curRxOkCnt = priv->stats.rxbytesunicast - lastRxOkCnt;
-- 
2.11.0
