Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60319 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936605Ab0COUAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 16:00:53 -0400
Received: by fxm19 with SMTP id 19so3597132fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:00:51 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Mar 2010 16:00:49 -0400
Message-ID: <6b5e31691003151300h1ab71850g695cbec6cdbaa0a0@mail.gmail.com>
Subject: [PATCH] ath5k: retries in ath5k_hw_setup_4word_tx_desc
From: Andrew Blaich <ablaich@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing AR5K_TUNE_HWTXTRIES from the Ath5k code, it adds 4
retries to tx_tries0.  By removing AR5K_TUNE_HWTXTRIES, the rate
control algorithm is given full control over the retry count.

Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h
b/drivers/net/wireless/ath/ath5k/ath5k.h
index ac67f02..1c5834a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -202,7 +202,6 @@
 #define AR5K_TUNE_MAX_TXPOWER                  63
 #define AR5K_TUNE_DEFAULT_TXPOWER              25
 #define AR5K_TUNE_TPC_TXPOWER                  false
-#define AR5K_TUNE_HWTXTRIES                    4

 #define AR5K_INIT_CARR_SENSE_EN                        1

diff --git a/drivers/net/wireless/ath/ath5k/desc.c
b/drivers/net/wireless/ath/ath5k/desc.c
index dc30a2b..c18d8d4 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
               AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
       tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
                                       AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
-       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
+       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
                                       AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
       tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
