Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38532 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0BSRVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:21:50 -0500
Message-ID: <4B7EC8A6.8010701@openwrt.org>
Date: Fri, 19 Feb 2010 18:21:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix beacon timer restart after a card reset
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode, ath_beacon_config_ap only restarts the timer if a TSF
restart is requested. Apparently this was added, because this function
unconditionally sets the flag for TSF reset.

The problem with this is, that ath9k_hw_reset() clobbers the timer
registers (specified in the initvals), thus effectively disabling the
SWBA interrupt whenever a card reset without TSF reset is issued
(happens in a few places in the code).

This patch fixes ath_beacon_config_ap to only issue the TSF reset flag
when necessary, but reinitialize the timer unconditionally. Tests show,
that this is enough to keep the SWBA interrupt going after a call to
ath_reset()

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -526,16 +526,13 @@ static void ath_beacon_config_ap(struct 
 {
 	u32 nexttbtt, intval;
 
-	/* Configure the timers only when the TSF has to be reset */
-
-	if (!(sc->sc_flags & SC_OP_TSF_RESET))
-		return;
-
 	/* NB: the beacon interval is kept internally in TU's */
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 	intval /= ATH_BCBUF;    /* for staggered beacons */
 	nexttbtt = intval;
-	intval |= ATH9K_BEACON_RESET_TSF;
+
+	if (sc->sc_flags & SC_OP_TSF_RESET)
+		intval |= ATH9K_BEACON_RESET_TSF;
 
 	/*
 	 * In AP mode we enable the beacon timers and SWBA interrupts to
