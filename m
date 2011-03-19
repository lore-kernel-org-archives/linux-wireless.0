Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52446 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 6/7] ath9k_hw: force rx chainmask to 7 on AR9100
Date: Sat, 19 Mar 2011 13:55:42 +0100
Message-Id: <1300539343-75509-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-5-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
 <1300539343-75509-2-git-send-email-nbd@openwrt.org>
 <1300539343-75509-3-git-send-email-nbd@openwrt.org>
 <1300539343-75509-4-git-send-email-nbd@openwrt.org>
 <1300539343-75509-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most AR9100 devices already have a chainmask of 7 (three antennas), however
on the ones that don't (rx and tx chainmask set to 5), problems with IQ
mismatch calibration have been observed.
This shows up as tx queue hangs (and subsequent hardware resets) if traffic
is sent during this type of calibration.
Forcing the rx chainmask to 7 fixes the calibration issues with no apparent
negative side effects on throughput and stability.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 175c36f..8b86568 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1869,6 +1869,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    !(AR_SREV_9271(ah)))
 		/* CB71: GPIO 0 is pulled down to indicate 3 rx chains */
 		pCap->rx_chainmask = ath9k_hw_gpio_get(ah, 0) ? 0x5 : 0x7;
+	else if (AR_SREV_9100(ah))
+		pCap->rx_chainmask = 0x7;
 	else
 		/* Use rx_chainmask from EEPROM. */
 		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
-- 
1.7.3.2

