Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52442 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1DIVKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 17:10:25 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 2/3] ath5k: fix SIFS time handling
Date: Sat,  9 Apr 2011 23:10:20 +0200
Message-Id: <1302383421-1418-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302383421-1418-1-git-send-email-nbd@openwrt.org>
References: <1302383421-1418-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k uses 8 usec as a sifs time, extracted from the initvals, whereas the
standard requires a sifs time of 10. The difference originates from the fact
that the SIFS register has an offset of 2 usec.
Fix the SIFS time definition to use the standard value of 10 usec and subtract
2 usecs when writing the SIFS register.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    3 +--
 drivers/net/wireless/ath/ath5k/qcu.c   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 996d8af..a49aeac 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -224,8 +224,7 @@
 
 /* SIFS */
 #define	AR5K_INIT_SIFS_TURBO			6
-/* XXX: 8 from initvals 10 from standard */
-#define	AR5K_INIT_SIFS_DEFAULT_BG		8
+#define	AR5K_INIT_SIFS_DEFAULT_BG		10
 #define	AR5K_INIT_SIFS_DEFAULT_A		16
 #define	AR5K_INIT_SIFS_HALF_RATE		32
 #define AR5K_INIT_SIFS_QUARTER_RATE		64
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 93abcfa..b18c502 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -519,7 +519,7 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 		return -EINVAL;
 
 	sifs = ath5k_hw_get_default_sifs(ah);
-	sifs_clock = ath5k_hw_htoclock(ah, sifs);
+	sifs_clock = ath5k_hw_htoclock(ah, sifs - 2);
 
 	/* EIFS
 	 * Txtime of ack at lowest rate + SIFS + DIFS
-- 
1.7.3.2

