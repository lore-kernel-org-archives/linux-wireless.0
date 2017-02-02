Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53179 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbdBBJOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 04:14:54 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v2 2/3] ath9k_hw: check if the chip failed to wake up
Date: Thu,  2 Feb 2017 10:14:51 +0100
Message-Id: <20170202091452.11939-2-nbd@nbd.name> (sfid-20170202_101500_129305_90E8D281)
In-Reply-To: <20170202091452.11939-1-nbd@nbd.name>
References: <20170202091452.11939-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In an RFC patch, Sven Eckelmann and Simon Wunderlich reported:

"QCA 802.11n chips (especially AR9330/AR9340) sometimes end up in a
state in which a read of AR_CFG always returns 0xdeadbeef.
This should not happen when when the power_mode of the device is
ATH9K_PM_AWAKE."

Include the check for the default register state in the existing MAC
hang check.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ac36873d6da4..8c5c2dd8fa7f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1603,6 +1603,10 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 	int count = 50;
 	u32 reg, last_val;
 
+	/* Check if chip failed to wake up */
+	if (REG_READ(ah, AR_CFG) == 0xdeadbeef)
+		return false;
+
 	if (AR_SREV_9300(ah))
 		return !ath9k_hw_detect_mac_hang(ah);
 
-- 
2.11.0
