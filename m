Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:37849 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZFQSxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 14:53:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: restore PS mode, before we put the chip into FULL SLEEP state.
Date: Wed, 17 Jun 2009 20:53:21 +0200
Message-Id: <1245264801-26959-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245264801-26959-1-git-send-email-juhosg@openwrt.org>
References: <1245264801-26959-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want to put the chip into FULL SLEEP state, when we are disabling the
radio, but the the current code always change it to AWAKE/NETWORK SLEEP.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9f49a32..66a6c1f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1196,8 +1196,8 @@ void ath_radio_disable(struct ath_softc *sc)
 
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1);
-	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 	ath9k_ps_restore(sc);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 }
 
 /*******************/
-- 
1.5.3.2

