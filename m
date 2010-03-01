Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55574 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0CAPal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 10:30:41 -0500
Received: by wwa36 with SMTP id 36so1356905wwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 07:30:40 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 1 Mar 2010 10:30:40 -0500
Message-ID: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
Subject: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
From: Andrew Blaich <ablaich@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This Patch:

The rate control algorithm, default is Minstrel for ath5k, determines
the number of retries to use for each rate.  However, there exists in
ath5k_hw_setup_4word_tx_desc (which is called for AR5212 like devices)
a set number of retries defined by AR5K_TUNE_HWTXTRIES.  The set
number of tries is added to the tx_tries0 variable setup by the rate
control algorithm.  This changes the number of retries the rate
control algorithm considers necessary.  By removing the
AR5K_TUNE_HWTXTRIES from the retry calculation the rate control
algorithm is given control over the number of retries.


Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/desc.c
b/drivers/net/wireless/ath/ath5k/desc.c
index dc30a2b..c18d8d4 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
 	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
 					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
-	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
+	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
 					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
 	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
