Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963AbZLNWMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 6/6] iwlwifi: fix 40MHz operation setting on cards that do not allow it
Date: Mon, 14 Dec 2009 14:12:13 -0800
Message-Id: <1260828733-22726-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
References: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Some devices have 40MHz operation disabled entirely. Ensure that driver do
not enable 40MHz operation if a channel does not allow this.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2135

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 08ad6e4..4a30969 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -749,7 +749,8 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 	ch_info->ht40_eeprom = *eeprom_ch;
 	ch_info->ht40_max_power_avg = eeprom_ch->max_power_avg;
 	ch_info->ht40_flags = eeprom_ch->flags;
-	ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
+	if (eeprom_ch->flags & EEPROM_CHANNEL_VALID)
+		ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
 
 	return 0;
 }
-- 
1.5.6.3

