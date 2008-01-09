Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:42437 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752526AbYAIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/6] ath5k: comment out unused beacon functions and structures
Date: Wed,  9 Jan 2008 18:16:06 +0900
Message-Id: <1199870169-10476-4-git-send-email-bruno@thinktube.com> (sfid-20080109_091623_054080_57EFC043)
In-Reply-To: <1199870169-10476-3-git-send-email-bruno@thinktube.com>
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
 <1199870169-10476-3-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use '#if 0' to comment out unused functions and structures wrt beacons. we
might need that info later but right now they are useless and probably need to
be rewritten.

Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    4 ++++
 drivers/net/wireless/ath5k/hw.c    |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 8af2545..0b6694b 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -459,6 +459,7 @@ struct ath5k_mib_stats {
 #define AR5K_BEACON_ENA		0x00800000 /*enable beacon xmit*/
 #define AR5K_BEACON_RESET_TSF	0x01000000 /*force a TSF reset*/
 
+#if 0
 /**
  * struct ath5k_beacon_state - Per-station beacon timer state.
  * @bs_interval: in TU's, can also include the above flags
@@ -478,6 +479,7 @@ struct ath5k_beacon_state {
 	u16	bs_bmiss_threshold;
 	u32  	bs_cfp_next;
 };
+#endif
 
 
 
@@ -1082,9 +1084,11 @@ extern u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah);
 extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 extern void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
+#if 0
 extern int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah, const struct ath5k_beacon_state *state);
 extern void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
 extern int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr);
+#endif
 extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ath5k_mib_stats *statistics);
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 5ca2563..64ab950 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2628,6 +2628,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 		AR5K_BEACON);
 }
 
+#if 0
 /*
  * Set beacon timers
  */
@@ -2822,6 +2823,7 @@ int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
 
 	return ret;
 }
+#endif
 
 /*
  * Update mib counters (statistics)
-- 
1.5.3.4

