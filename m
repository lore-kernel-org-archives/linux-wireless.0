Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53764 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab2H0PAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:00:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.6 4/6] ath9k_hw: disable PA linearization for AR9462
Date: Mon, 27 Aug 2012 17:00:06 +0200
Message-Id: <1346079608-40944-4-git-send-email-nbd@openwrt.org> (sfid-20120827_170105_537368_3C3328EE)
In-Reply-To: <1346079608-40944-3-git-send-email-nbd@openwrt.org>
References: <1346079608-40944-1-git-send-email-nbd@openwrt.org>
 <1346079608-40944-2-git-send-email-nbd@openwrt.org>
 <1346079608-40944-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for it is incomplete

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d95474e..64a00d2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2499,7 +2499,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
 		if (!ah->config.paprd_disable &&
-		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD) &&
+		    !AR_SREV_9462(ah))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
-- 
1.7.9.6 (Apple Git-31.1)

