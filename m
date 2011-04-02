Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53527 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1DBBjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:39:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k: fix beacon slot processing in ad-hoc mode
Date: Sat,  2 Apr 2011 03:39:47 +0200
Message-Id: <1301708388-8416-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
References: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent cleanups in the beacon code fixed SWBA backoff calculation,
however it did not remove a line of code that worked around the issues
from the earlier version of the code.
After the cleanup, the initial TSF based slot calculation now always
returns 0 instead of ATH_BCBUF-1, so the previous hack that reversed the
slot order needs to be removed, as ad-hoc mode does not use staggered
beacons.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 74f33bc..24861b2 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -392,14 +392,6 @@ void ath_beacon_tasklet(unsigned long data)
 	tsf += TU_TO_USEC(ah->config.sw_beacon_response_time);
 	tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
 	slot = (tsftu % (intval * ATH_BCBUF)) / intval;
-	/*
-	 * Reverse the slot order to get slot 0 on the TBTT offset that does
-	 * not require TSF adjustment and other slots adding
-	 * slot/ATH_BCBUF * beacon_int to timestamp. For example, with
-	 * ATH_BCBUF = 4, we process beacon slots as follows: 3 2 1 0 3 2 1 ..
-	 * and slot 0 is at correct offset to TBTT.
-	 */
-	slot = ATH_BCBUF - slot - 1;
 	vif = sc->beacon.bslot[slot];
 
 	ath_dbg(common, ATH_DBG_BEACON,
-- 
1.7.3.2

