Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZCJCJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:09:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath9k: make few eeprom and calib items static
Date: Mon,  9 Mar 2009 22:09:42 -0400
Message-Id: <1236650982-11520-3-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032927_732124_BDF1957F)
In-Reply-To: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com>
References: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the sparse complaints:

drivers/net/wireless/ath9k/eeprom.c:1407:5: warning: symbol
'ath9k_hw_4k_get_spur_channel' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:1436:19: warning: symbol
'eep_4k_ops' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2808:5: warning: symbol
'ath9k_hw_def_get_spur_channel' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2837:19: warning: symbol
'eep_def_ops' was not declared. Should it be static?
  CC [M]  drivers/net/wireless/ath9k/eeprom.o
  CHECK   drivers/net/wireless/ath9k/mac.c
  CC [M]  drivers/net/wireless/ath9k/mac.o
  CHECK   drivers/net/wireless/ath9k/calib.c
drivers/net/wireless/ath9k/calib.c:883:6: warning: symbol 'ar9285_clc'
was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c  |    2 +-
 drivers/net/wireless/ath9k/eeprom.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index a652e9b..c9446fb 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -880,7 +880,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	return true;
 }
 
-bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
+static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
 	if (chan->channelFlags & CHANNEL_HT20) {
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index dd280cb..183c949 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1404,7 +1404,7 @@ static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
 	return 1;
 }
 
-u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
+static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_MAP4K_SPURCHAN \
 	(ah->eeprom.map4k.modalHeader.spurChans[i].spurChan)
@@ -1433,7 +1433,7 @@ u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 #undef EEP_MAP4K_SPURCHAN
 }
 
-struct eeprom_ops eep_4k_ops = {
+static struct eeprom_ops eep_4k_ops = {
 	.check_eeprom		= ath9k_hw_4k_check_eeprom,
 	.get_eeprom		= ath9k_hw_4k_get_eeprom,
 	.fill_eeprom		= ath9k_hw_4k_fill_eeprom,
@@ -2805,7 +2805,7 @@ static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
 	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
+static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_DEF_SPURCHAN \
 	(ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
@@ -2834,7 +2834,7 @@ u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 #undef EEP_DEF_SPURCHAN
 }
 
-struct eeprom_ops eep_def_ops = {
+static struct eeprom_ops eep_def_ops = {
 	.check_eeprom		= ath9k_hw_def_check_eeprom,
 	.get_eeprom		= ath9k_hw_def_get_eeprom,
 	.fill_eeprom		= ath9k_hw_def_fill_eeprom,
-- 
1.6.0.6

