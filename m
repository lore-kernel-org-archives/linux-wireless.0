Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58709 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab1GLBC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 21:02:29 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v3 5/8] ath5k: delay full calibration after reset
Date: Tue, 12 Jul 2011 09:02:02 +0800
Message-Id: <1310432525-70077-5-git-send-email-nbd@openwrt.org> (sfid-20110712_030234_198660_CA1CFEA1)
In-Reply-To: <1310432525-70077-4-git-send-email-nbd@openwrt.org>
References: <1310432525-70077-1-git-send-email-nbd@openwrt.org>
 <1310432525-70077-2-git-send-email-nbd@openwrt.org>
 <1310432525-70077-3-git-send-email-nbd@openwrt.org>
 <1310432525-70077-4-git-send-email-nbd@openwrt.org>
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
index 523bb08..3b58e00 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2725,7 +2725,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 
 	ath5k_ani_init(ah, ani_mode);
 
-	ah->ah_cal_next_full = jiffies;
+	ah->ah_cal_next_full = jiffies + msecs_to_jiffies(100);
 	ah->ah_cal_next_ani = jiffies;
 	ah->ah_cal_next_nf = jiffies;
 	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
-- 
1.7.3.2

