Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:43147 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762737AbZE0Msh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:48:37 -0400
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 12:48:27 +0000
Message-Id: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
Subject: [PATCH 1/4] ath9k: Reset SC_OP_TSF_RESET flag after stuck beacon
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a TrendNet 652-BRP running OpenWRT + ath9k very well.  The only
problem is that the beacon gets stuck maybe once a day.  After
Vasanthakumar Thiagarajan's "ath9k: cleanup beacon parameters
configuration" patch, ath9k would nearly re-configure the beacons after it
detected the stuck beacon, and did a reset.  But it would fail the
SC_OP_TSF_RESET check in ath_beacon_config_ap.  This patch gets the beacon
fully reconfigured after the reset.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index a21b213..0c67ed2 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -411,6 +411,7 @@ void ath_beacon_tasklet(unsigned long data)
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"beacon is officially stuck\n");
+			sc->sc_flags |= SC_OP_TSF_RESET;
 			ath_reset(sc, false);
 		}
 
-- 
1.6.0.4

