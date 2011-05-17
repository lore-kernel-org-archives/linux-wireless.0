Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51198 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab1EQIeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 04:34:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	rmanoharan@atheros.com
Subject: [PATCH] ath9k: fix ad-hoc nexttbtt calculation
Date: Tue, 17 May 2011 10:34:12 +0200
Message-Id: <1305621252-21853-1-git-send-email-nbd@openwrt.org> (sfid-20110517_103429_503938_539BE291)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rounding up the delta between last-beacon-tsf and tsf to intval is wrong
and can lead to misconfigured timers which breaks beacon transmission.
Fix this by adding intval and subtracting the offset of the tsf within the
current slot.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index c7f4679..0199af0 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -654,7 +654,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 			delta = (tsf - sc->beacon.bc_tstamp);
 		else
 			delta = (tsf + 1 + (~0U - sc->beacon.bc_tstamp));
-		nexttbtt = tsf + roundup(delta, intval);
+		nexttbtt = tsf + intval - (delta % intval);
 	}
 
 	ath_dbg(common, ATH_DBG_BEACON,
-- 
1.7.3.2

