Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62453 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0IOOWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 10:22:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 07:22:07 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Fix regression in starting ANI after association
Date: Wed, 15 Sep 2010 07:22:06 -0700
Message-ID: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sat Jul 31 00:11:59 2010 +0200

    ath9k: prevent calibration during off-channel activity

The above patch checks for off-channel before starting ANI,
but when the operating channel is set right after association,
IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
is non-NULL. This would result in not starting calibration after
the association. Fix this by clearing off-channel state in sc_flags
after association.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a2f7eb2..b529c3e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -820,7 +820,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		/* Reset rssi stats */
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-		sc->sc_flags |= SC_OP_ANI_RUN;
+		sc->sc_flags = (sc->sc_flags | SC_OP_ANI_RUN) & ~SC_OP_OFFCHANNEL;
 		ath_start_ani(common);
 	} else {
 		ath_print(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
-- 
1.7.0.4

