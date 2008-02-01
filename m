Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYBAFvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 00:51:51 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: initialize ieee80211_channel->hw_value
Date: Thu, 31 Jan 2008 21:46:40 -0800
Message-Id: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com> (sfid-20080201_055153_777172_0E99EF3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

hw_value is being used uninitialized. fix it.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f82aec5..b0f1155 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5388,6 +5388,7 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
+		geo_ch->hw_value = ch->channel;
 
 		if (is_channel_valid(ch)) {
 			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a4fa6bf..402cd9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5810,6 +5810,7 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
+		geo_ch->hw_value = ch->channel;
 
 		if (is_channel_valid(ch)) {
 			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
-- 
1.5.3.4

