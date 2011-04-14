Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53199 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab1DNWly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 18:41:54 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com, pstew@google.com
Subject: [PATCH 2.6.39] ath9k: fix the return value of ath_stoprecv
Date: Fri, 15 Apr 2011 00:41:43 +0200
Message-Id: <1302820903-39820-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch 'ath9k_hw: fix stopping rx DMA during resets' added code to detect
a condition where rx DMA was stopped, but the MAC failed to enter the idle
state. This condition requires a hardware reset, however the return value
of ath_stoprecv was 'true' in that case, which allowed it to skip the reset
when issuing a fast channel change.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Paul Stewart <pstew@google.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 642504f..f69dcdf 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -503,7 +503,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 			"confusing the DMA engine when we start RX up\n");
 		ATH_DBG_WARN_ON_ONCE(!stopped);
 	}
-	return stopped || reset;
+	return stopped && !reset;
 }
 
 void ath_flushrecv(struct ath_softc *sc)
-- 
1.7.3.2

