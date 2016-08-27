Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35637 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754252AbcH0Q1w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 12:27:52 -0400
Received: by mail-pf0-f175.google.com with SMTP id x72so38074507pfd.2
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2016 09:27:52 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Subject: [PATCH] fix:gpio: mark symbols static where possible
Date: Sun, 28 Aug 2016 00:27:08 +0800
Message-Id: <1472315228-14802-1-git-send-email-baoyou.xie@linaro.org> (sfid-20160827_182837_986767_50A72A67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get 1 warning about global functions without a declaration
in the ath9k gpio driver when building with W=1:
drivers/net/wireless/ath/ath9k/gpio.c:25:6: warning: no previous prototype for 'ath_fill_led_pin' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is declared
and don't need a declaration, but can be made static.
so this patch marks it 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 490f74d..ddb2886 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -22,7 +22,7 @@
 
 #ifdef CONFIG_MAC80211_LEDS
 
-void ath_fill_led_pin(struct ath_softc *sc)
+static void ath_fill_led_pin(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-- 
2.7.4
