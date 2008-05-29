Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYE2Ih5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 39/43] iwlwifi: disable FAT channel when not permitted
Date: Thu, 29 May 2008 16:35:24 +0800
Message-Id: <1212050128-17132-40-git-send-email-yi.zhu@intel.com> (sfid-20080529_103811_623485_52832D35)
In-Reply-To: <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch disables FAT channel when it is not permitted according to
the EEPROM.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 010085a..c9bbfbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -486,6 +486,25 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
+			switch (ch->fat_extension_channel) {
+			case HT_IE_EXT_CHANNEL_ABOVE:
+				/* only above is allowed, disable below */
+				geo_ch->flags |= IEEE80211_CHAN_NO_FAT_BELOW;
+				break;
+			case HT_IE_EXT_CHANNEL_BELOW:
+				/* only below is allowed, disable above */
+				geo_ch->flags |= IEEE80211_CHAN_NO_FAT_ABOVE;
+				break;
+			case HT_IE_EXT_CHANNEL_NONE:
+				/* fat not allowed: disable both*/
+				geo_ch->flags |= (IEEE80211_CHAN_NO_FAT_ABOVE |
+						  IEEE80211_CHAN_NO_FAT_BELOW);
+				break;
+			case HT_IE_EXT_CHANNEL_MAX:
+				/* both above and below are permitted */
+				break;
+			}
+
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
 				    ch->max_power_avg;
-- 
1.5.3.6

