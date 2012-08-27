Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53760 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab2H0PAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:00:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.6 6/6] ath9k_hw: enable PA linearization
Date: Mon, 27 Aug 2012 17:00:08 +0200
Message-Id: <1346079608-40944-6-git-send-email-nbd@openwrt.org> (sfid-20120827_170102_901397_22F319CC)
In-Reply-To: <1346079608-40944-5-git-send-email-nbd@openwrt.org>
References: <1346079608-40944-1-git-send-email-nbd@openwrt.org>
 <1346079608-40944-2-git-send-email-nbd@openwrt.org>
 <1346079608-40944-3-git-send-email-nbd@openwrt.org>
 <1346079608-40944-4-git-send-email-nbd@openwrt.org>
 <1346079608-40944-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature had been disabled in ath9k because the code to support
it was incomplete, but now the code is in sync with the internal QCA
codebase, so it's time to enable it.

On many newer devices, the calibration is assumed to be done with PA
linearization enabled.

Tests with a particular AR933x device showed that the signal emitted
at full power was highly distorted and unreliable with PA linearization
disabled. With this patch, the signal becomes clear and stability
is improved.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e4b9f35..48af401 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -463,9 +463,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	/* PAPRD needs some more work to be enabled */
-	ah->config.paprd_disable = 1;
-
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
 
-- 
1.7.9.6 (Apple Git-31.1)

