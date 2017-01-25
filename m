Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33760 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbdAYQhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 11:37:02 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/4] ath9k_hw: check if the chip failed to wake up
Date: Wed, 25 Jan 2017 17:36:52 +0100
Message-Id: <20170125163654.66431-2-nbd@nbd.name> (sfid-20170125_173709_185234_566BC8FD)
In-Reply-To: <20170125163654.66431-1-nbd@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name>
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
index 6989f89b3116..11fd98df2c43 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1623,6 +1623,10 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
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
