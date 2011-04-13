Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60416 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab1DMT4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 1/5] ath5k: disable 5 GHz support if a 2.4 GHz radio is detected
Date: Wed, 13 Apr 2011 21:56:42 +0200
Message-Id: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a dual-radio dual-band AR5312 device, the calibration data is shared
between the 5 GHz and the 2.4 GHz radio/MAC.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/caps.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index f77e8a7..7dd88e1 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -94,6 +94,9 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		}
 	}
 
+	if ((ah->ah_radio_5ghz_revision & 0xf0) == AR5K_SREV_RAD_2112)
+		__clear_bit(AR5K_MODE_11A, caps->cap_mode);
+
 	/* Set number of supported TX queues */
 	if (ah->ah_version == AR5K_AR5210)
 		caps->cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES_NOQCU;
-- 
1.7.3.2

