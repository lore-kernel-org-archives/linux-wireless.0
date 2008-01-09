Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22490 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752431AbYAIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/6] ath5k: rename function ath5k_hw_wait_for_beacon
Date: Wed,  9 Jan 2008 18:16:05 +0900
Message-Id: <1199870169-10476-3-git-send-email-bruno@thinktube.com> (sfid-20080109_091620_478511_A3991891)
In-Reply-To: <1199870169-10476-2-git-send-email-bruno@thinktube.com>
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rename to ath5k_hw_beaconq_finish, since this is more clear.
this function is unused at the moment

Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath5k/hw.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 47b33d2..8af2545 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1084,7 +1084,7 @@ extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 extern void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
 extern int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah, const struct ath5k_beacon_state *state);
 extern void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
-extern int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr);
+extern int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr);
 extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ath5k_mib_stats *statistics);
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 402b868..5ca2563 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2776,9 +2776,8 @@ void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
 
 /*
  * Wait for beacon queue to finish
- * TODO: This function's name is misleading, rename
  */
-int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr)
+int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
 {
 	unsigned int i;
 	int ret;
-- 
1.5.3.4

