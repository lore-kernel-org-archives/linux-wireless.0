Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:44799 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936616Ab0COTyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 15:54:17 -0400
Received: by fxm19 with SMTP id 19so3590066fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 12:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6b5e31691003151250v77fea2fdh2af375225a54ffd@mail.gmail.com>
References: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
	 <b6c5339f1003031530l2a89c265t98a8560bdbf9c758@mail.gmail.com>
	 <6b5e31691003040621ge2ca051n1bb3abb4b0158546@mail.gmail.com>
	 <b6c5339f1003050515m7ec8518fy5bd29c6886228e4f@mail.gmail.com>
	 <6b5e31691003151250v77fea2fdh2af375225a54ffd@mail.gmail.com>
Date: Mon, 15 Mar 2010 15:54:12 -0400
Message-ID: <6b5e31691003151254x658e227bl8f627b66c984b1fc@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
From: Andrew Blaich <ablaich@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignore previous email, quoted text was included.

Removing AR5K_TUNE_HWTXTRIES from the Ath5k code as it adds in 4
retries on top of what is already in tx_tries0.  By removing
AR5K_TUNE_HWTXTRIES, the rate control algorithm is given full control
in setting the number of retries.

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
