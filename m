Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab2ESIn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:43:28 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 04/10] ath9k_hw: program BT to control SPDT
Date: Sat, 19 May 2012 14:13:50 +0530
Message-ID: <1337417036-1431-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120519_104355_695745_37FE8272)
In-Reply-To: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

program BT to control SPDT everytime while loading switch table
from eeprom.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ac53d90..4791976 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3613,6 +3613,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
+		REG_SET_BIT(ah, AR_PHY_GLB_CONTROL, AR_BTCOEX_CTRL_SPDT_ENABLE);
 	}
 
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
-- 
1.7.10.2

