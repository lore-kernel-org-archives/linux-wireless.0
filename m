Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58961 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZBIIBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:01:20 -0500
Received: from mail.atheros.com ([10.10.21.49])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:01:20 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57819.562083.509881@gargle.gargle.HOWL> (sfid-20090209_090122_900471_6DC0CE7B)
Date: Mon, 9 Feb 2009 13:27:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 08/10] ath9k: Add callbacks hooks for EEPROM operations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is preparatory work for removing the individual
function pointer assignments in eeprom.c

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 81a7a70..47c8eea 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -447,6 +447,23 @@ enum hal_eep_map {
 	EEP_MAP_MAX
 };
 
+struct eeprom_ops {
+	int (*check_eeprom)(struct ath_hw *hw);
+	u32 (*get_eeprom)(struct ath_hw *hw, enum eeprom_param param);
+	bool (*fill_eeprom)(struct ath_hw *hw);
+	int (*get_eeprom_ver)(struct ath_hw *hw);
+	int (*get_eeprom_rev)(struct ath_hw *hw);
+	u8 (*get_num_ant_config)(struct ath_hw *hw, enum ieee80211_band band);
+	u16 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
+				      struct ath9k_channel *chan);
+	bool (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
+	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
+	int (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
+			   u16 cfgCtl, u8 twiceAntennaReduction,
+			   u8 twiceMaxRegulatoryPower, u8 powerLimit);
+	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
+};
+
 #define ar5416_get_eep_ver(_ah) \
 	(((_ah)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
 #define ar5416_get_eep_rev(_ah) \
-- 
1.6.1

