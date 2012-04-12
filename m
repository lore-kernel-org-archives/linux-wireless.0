Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42044 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762679Ab2DLUgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:36:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: do not register LEDs on AR913x
Date: Thu, 12 Apr 2012 22:35:57 +0200
Message-Id: <1334262958-90777-3-git-send-email-nbd@openwrt.org> (sfid-20120412_223612_525229_ACEC8A2B)
In-Reply-To: <1334262958-90777-2-git-send-email-nbd@openwrt.org>
References: <1334262958-90777-1-git-send-email-nbd@openwrt.org>
 <1334262958-90777-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LED support is typically handled via system GPIO on these platforms.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index fbe23de..dd10f4a 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -41,6 +41,9 @@ void ath_init_leds(struct ath_softc *sc)
 {
 	int ret;
 
+	if (AR_SREV_9100(sc->sc_ah))
+		return;
+
 	if (sc->sc_ah->led_pin < 0) {
 		if (AR_SREV_9287(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9287;
-- 
1.7.3.2

