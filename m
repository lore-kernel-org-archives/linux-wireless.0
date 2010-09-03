Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37617 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0ICHKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 03:10:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Sep 2010 00:10:18 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Enable fastcc for HTC devices.
Date: Fri, 3 Sep 2010 12:41:28 +0530
Message-ID: <1283497888-8294-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By enabling fastcc, the scan time reduced to half.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f467207..bab8948 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -137,8 +137,6 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	if (priv->op_flags & OP_FULL_RESET)
 		fastcc = false;
 
-	/* Fiddle around with fastcc later on, for now just use full reset */
-	fastcc = false;
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -146,9 +144,10 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
 	ath_print(common, ATH_DBG_CONFIG,
-		  "(%u MHz) -> (%u MHz), HT: %d, HT40: %d\n",
+		  "(%u MHz) -> (%u MHz), HT: %d, HT40: %d fastcc: %d\n",
 		  priv->ah->curchan->channel,
-		  channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf));
+		  channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
+		  fastcc);
 
 	caldata = &priv->caldata[channel->hw_value];
 	ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
-- 
1.7.2.2

