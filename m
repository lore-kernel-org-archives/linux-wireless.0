Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11637 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab2DMHpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 03:45:55 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: fix ibss beacon next tbtt
Date: Fri, 13 Apr 2012 13:16:34 +0530
Message-ID: <1334303194-7626-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_094558_256069_38953C0C)
In-Reply-To: <1334303194-7626-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1334303194-7626-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync-up ibss beacon timer with the beacon frame's timestamp. When the
node acts as joiner, it has to sync with the received beacon timestamp
instead of reading tsf from hw. As the hw tsf wont wont be update till
bssid is configured. This patch programs hw tsf with the received beacon
timestamp if beacon timers are yet to be configured.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6264182..719a271 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -650,6 +650,8 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	u32 tsf, intval, nexttbtt;
 
 	ath9k_reset_beacon_status(sc);
+	if (!(sc->sc_flags & SC_OP_BEACONS))
+		ath9k_hw_settsf64(ah, sc->beacon.bc_tstamp);
 
 	intval = TU_TO_USEC(conf->beacon_interval);
 	tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);
-- 
1.7.10

