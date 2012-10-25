Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38131 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2JYPZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 11:25:11 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Set force WLAN LNA diversity on bit for AR9565
Date: Thu, 25 Oct 2012 20:54:51 +0530
Message-ID: <1351178692-2054-2-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121025_172516_331759_1F277AD2)
In-Reply-To: <1351178692-2054-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1351178692-2054-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When LNA diversity shared chain is enabled set force
WLAN LNA diversity on bit and enable fast diversity m2flag
for AR9565.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d2e44c3..105390a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3643,9 +3643,20 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 			    (value & AR_EEP_ANT_DIV_ENABLE)) {
 				regval |= AR_ANT_DIV_ENABLE;
 				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
+				if (is2ghz) {
+					REG_SET_BIT(ah,
+					    AR_PHY_RESTART,
+					    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
+				}
+				REG_SET_BIT(ah,
+					    AR_BTCOEX_WL_LNADIV,
+					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 			} else {
 				regval &= ~AR_ANT_DIV_ENABLE;
 				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
+				REG_CLR_BIT(ah,
+					    AR_BTCOEX_WL_LNADIV,
+					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 			}
 		}
 
-- 
1.7.4.1

