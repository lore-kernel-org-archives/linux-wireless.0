Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53676 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1GEDLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 23:11:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v2 7/8] ath5k: disable 32KHz sleep clock operation by default
Date: Tue,  5 Jul 2011 10:11:23 +0700
Message-Id: <1309835484-26653-7-git-send-email-nbd@openwrt.org> (sfid-20110705_051155_994325_DD085A3F)
In-Reply-To: <1309835484-26653-6-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
 <1309835484-26653-2-git-send-email-nbd@openwrt.org>
 <1309835484-26653-3-git-send-email-nbd@openwrt.org>
 <1309835484-26653-4-git-send-email-nbd@openwrt.org>
 <1309835484-26653-5-git-send-email-nbd@openwrt.org>
 <1309835484-26653-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While 32 KHz sleep clock might provide some power saving benefits,
it is also a major source of stability issues, on OpenWrt it produced
some reproducible data bus errors on register accesses on several
different MIPS platforms.

All the Atheros drivers that I can find do not enable this feature,
so it makes sense to leave it disabled in ath5k as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath/ath5k/debug.c |    3 +++
 drivers/net/wireless/ath/ath5k/reset.c |   11 ++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index c4c02d5..6ea4d5d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1066,6 +1066,8 @@ struct ath5k_hw {
 	u8			ah_retry_long;
 	u8			ah_retry_short;
 
+	u32			ah_use_32khz_clock;
+
 	u8			ah_coverage_class;
 	bool			ah_ack_bitrate_high;
 	u8			ah_bwmode;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 0bf7313..c0cebb7 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -918,6 +918,9 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 
 	debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, sc,
 			    &fops_queue);
+
+	debugfs_create_bool("32khz_clock", S_IWUSR | S_IRUSR, phydir,
+			    &sc->ah->ah_use_32khz_clock);
 }
 
 /* functions used in other places */
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index efcc4df..d94db31 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1287,11 +1287,16 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	ath5k_hw_dma_init(ah);
 
 
-	/* Enable 32KHz clock function for AR5212+ chips
+	/*
+	 * Enable 32KHz clock function for AR5212+ chips
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
-	 * exists */
-	if (ah->ah_version == AR5K_AR5212 &&
+	 * exists.
+	 * Disabled by default because it is also disabled in
+	 * other drivers and it is known to cause stability
+	 * issues on some devices
+	 */
+	if (ah->ah_use_32khz_clock && ah->ah_version == AR5K_AR5212 &&
 	    op_mode != NL80211_IFTYPE_AP)
 		ath5k_hw_set_sleep_clock(ah, true);
 
-- 
1.7.3.2

