Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:45826 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BRMGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 07:06:47 -0500
Date: Fri, 18 Feb 2011 13:06:42 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: Simon Morgenthaler <s.morgenthaler@students.unibe.ch>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <29482921.30.1298030799163.JavaMail.wlan@500181>
In-Reply-To: <10437684.20.1298030296565.JavaMail.wlan@500181>
Subject: [PATCH] ath5k: Enable AR2315 chipset recognition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Enable recognition of AR2315 chipsets in ath5k driver.

Reported-by: Simon Morgenthaler <s.morgenthaler@students.unibe.ch>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index c71fdbb..bc82405 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -220,7 +220,8 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 			ah->ah_radio = AR5K_RF5112;
 			ah->ah_single_chip = false;
 			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_5112B;
-		} else if (ah->ah_mac_version == (AR5K_SREV_AR2415 >> 4)) {
+		} else if (ah->ah_mac_version == (AR5K_SREV_AR2415 >> 4) ||
+			ah->ah_mac_version == (AR5K_SREV_AR2315_R6 >> 4)) {
 			ah->ah_radio = AR5K_RF2316;
 			ah->ah_single_chip = true;
 			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2316;
--
1.7.1
