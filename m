Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54796 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaBVNxN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 08:53:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/2] ath9k: make some hardware reset log messages debug-only
Date: Sat, 22 Feb 2014 14:52:49 +0100
Message-Id: <1393077169-65244-2-git-send-email-nbd@openwrt.org> (sfid-20140222_145338_102398_56691C6E)
In-Reply-To: <1393077169-65244-1-git-send-email-nbd@openwrt.org>
References: <1393077169-65244-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some chips, baseband watchdog hangs are more common than others, and
the driver has support for handling them.
Interrupts even after a watchdog hang are also quite common, so there's
not much point in spamming the user's logfiles.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index afce549..14a7524 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -451,7 +451,7 @@ void ath9k_tasklet(unsigned long data)
 		 * interrupts are enabled in the reset routine.
 		 */
 		atomic_inc(&ah->intr_ref_cnt);
-		ath_dbg(common, ANY, "FATAL: Skipping interrupts\n");
+		ath_dbg(common, RESET, "FATAL: Skipping interrupts\n");
 		goto out;
 	}
 
@@ -471,7 +471,7 @@ void ath9k_tasklet(unsigned long data)
 			 * interrupts are enabled in the reset routine.
 			 */
 			atomic_inc(&ah->intr_ref_cnt);
-			ath_dbg(common, ANY,
+			ath_dbg(common, RESET,
 				"BB_WATCHDOG: Skipping interrupts\n");
 			goto out;
 		}
@@ -484,7 +484,7 @@ void ath9k_tasklet(unsigned long data)
 			type = RESET_TYPE_TX_GTT;
 			ath9k_queue_reset(sc, type);
 			atomic_inc(&ah->intr_ref_cnt);
-			ath_dbg(common, ANY,
+			ath_dbg(common, RESET,
 				"GTT: Skipping interrupts\n");
 			goto out;
 		}
-- 
1.8.3.4 (Apple Git-47)

