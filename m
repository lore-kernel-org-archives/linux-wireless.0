Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34565 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3H1PPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 11:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: ar9003_eeprom.c:3618 fix variable name typo
Date: Wed, 28 Aug 2013 11:09:10 -0400
Message-Id: <1377702550-11734-1-git-send-email-linville@tuxdriver.com> (sfid-20130828_171518_628925_4CB34D5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

   drivers/net/wireless/ath/ath9k/ar9003_eeprom.c: In function 'ar9003_hw_ant_ctrl_apply':
>> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3618: warning: 'regval' is used uninitialized in this function

It seems obvious that 'regval' should have been 'value'...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a6846ab..f486480 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3615,8 +3615,8 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
 	if (AR_SREV_9485(ah) && common->bt_ant_diversity) {
-		regval &= ~AR_SWITCH_TABLE_COM2_ALL;
-		regval |= ah->config.ant_ctrl_comm2g_switch_enable;
+		value &= ~AR_SWITCH_TABLE_COM2_ALL;
+		value |= ah->config.ant_ctrl_comm2g_switch_enable;
 
 	}
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
-- 
1.8.1.4

