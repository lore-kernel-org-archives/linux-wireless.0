Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9935 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1NQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 09:16:07 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k/ath9k_htc: Fix PS wrappers for RF kill
Date: Wed, 28 Sep 2011 16:56:10 +0530
Message-ID: <1317209170-7128-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110928_151612_398867_B441F2B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ath9k_hw_gpio_get reads the GPIO in/out registers to get the status of
GPIO pins, so use PS wrappers

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c         |    7 ++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |   10 ++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index afbf540..fd0f84e 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -84,9 +84,14 @@ void ath_init_leds(struct ath_softc *sc)
 static bool ath_is_rfkill_set(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	bool is_blocked;
 
-	return ath9k_hw_gpio_get(ah, ah->rfkill_gpio) ==
+	ath9k_ps_wakeup(sc);
+	is_blocked = ath9k_hw_gpio_get(ah, ah->rfkill_gpio) ==
 				  ah->rfkill_polarity;
+	ath9k_ps_restore(sc);
+
+	return is_blocked;
 }
 
 void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index db2352e..e3a02eb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -228,8 +228,14 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 
 static bool ath_is_rfkill_set(struct ath9k_htc_priv *priv)
 {
-	return ath9k_hw_gpio_get(priv->ah, priv->ah->rfkill_gpio) ==
-		priv->ah->rfkill_polarity;
+	bool is_blocked;
+
+	ath9k_htc_ps_wakeup(priv);
+	is_blocked = ath9k_hw_gpio_get(priv->ah, priv->ah->rfkill_gpio) ==
+						 priv->ah->rfkill_polarity;
+	ath9k_htc_ps_restore(priv);
+
+	return is_blocked;
 }
 
 void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw)
-- 
1.7.0.4

