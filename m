Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:38961 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754125AbZGIVSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:18:01 -0400
Date: Thu, 9 Jul 2009 14:12:21 -0700
From: Steven Luo <steven@steven676.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix enabling OFDM weak signal detection
Message-ID: <20090709211221.GA4854@steven676.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Steven Luo <steven@steven676.net>

It seems that OFDM weak signal detection should be enabled after an ANI
state reset, as indicated by the initial setting of ofdmWeakSigDetectOff
and what the open Atheros HAL does.  Unfortunately, the reversed sense
of ofdmWeakSigDetectOff (true if weak signal detection is NOT enabled)
seems to have resulted in a mixup here, causing weak signal detection to
be disabled.

This patch significantly improves reception and throughput from distant
stations for my AR5416-based AP running compat-wireless 2009-06-25.

Signed-off-by: Steven Luo <steven@steven676.net>
Cc: stable@kernel.org
---

--- a/drivers/net/wireless/ath/ath9k/ani.c	2009-06-24 21:14:00.000000000 -0700
+++ b/drivers/net/wireless/ath/ath9k/ani.c	2009-07-06 02:45:57.000000000 -0700
@@ -482,7 +482,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-				     !ATH9K_ANI_USE_OFDM_WEAK_SIG);
+				     ATH9K_ANI_USE_OFDM_WEAK_SIG);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
 				     ATH9K_ANI_CCK_WEAK_SIG_THR);
 

