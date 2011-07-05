Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53662 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1GEDLn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 23:11:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v2 5/8] ath5k: delay full calibration after reset
Date: Tue,  5 Jul 2011 10:11:21 +0700
Message-Id: <1309835484-26653-5-git-send-email-nbd@openwrt.org> (sfid-20110705_051153_343086_15A54974)
In-Reply-To: <1309835484-26653-4-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
 <1309835484-26653-2-git-send-email-nbd@openwrt.org>
 <1309835484-26653-3-git-send-email-nbd@openwrt.org>
 <1309835484-26653-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During scans the full calibration usually does not make much sense,
PAPD probing and IQ calibration should be deferred until there is
enough time to complete them. Adding 100 ms to the initial full
calibration delay should be enough to do this.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a413aa7..efec14f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2728,7 +2728,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 
 	ath5k_ani_init(ah, ani_mode);
 
-	ah->ah_cal_next_full = jiffies;
+	ah->ah_cal_next_full = jiffies + msecs_to_jiffies(100);
 	ah->ah_cal_next_ani = jiffies;
 	ah->ah_cal_next_nf = jiffies;
 	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
-- 
1.7.3.2

