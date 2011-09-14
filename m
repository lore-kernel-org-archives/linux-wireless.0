Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58682 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab1INTXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:23:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/3] ath9k: make beacon timer initialization more reliable
Date: Wed, 14 Sep 2011 21:23:02 +0200
Message-Id: <1316028183-33734-2-git-send-email-nbd@openwrt.org> (sfid-20110914_212321_732208_CA8673DE)
In-Reply-To: <1316028183-33734-1-git-send-email-nbd@openwrt.org>
References: <1316028183-33734-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When starting the AP beacon timer, it assumes that the TSF has recently
been cleared. Set the SC_OP_TSF_RESET flag to ensure that this is always
the case.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 22e8e25..6d7088b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -517,6 +517,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	/* Set the computed AP beacon timers */
 
 	ath9k_hw_disable_interrupts(ah);
+	sc->sc_flags |= SC_OP_TSF_RESET;
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah, ah->imask);
-- 
1.7.3.2

