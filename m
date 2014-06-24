Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62325 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaFXTwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:43 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so906570wes.29
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/27] iwlwifi: fix NVM channel attribute map.
Date: Tue, 24 Jun 2014 22:52:04 +0300
Message-Id: <1403639541-4621-10-git-send-email-egrumbach@gmail.com> (sfid-20140624_215248_494593_787F0DE0)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Fix NVM channel attributes. Add indoor-only and GO Concurrent
bits. Remove DFS channel bit which is overlapped with radar.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 85eee79..0e3322a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -174,7 +174,9 @@ static struct ieee80211_rate iwl_cfg80211_rates[] = {
  * @NVM_CHANNEL_IBSS: usable as an IBSS channel
  * @NVM_CHANNEL_ACTIVE: active scanning allowed
  * @NVM_CHANNEL_RADAR: radar detection required
- * @NVM_CHANNEL_DFS: dynamic freq selection candidate
+ * @NVM_CHANNEL_INDOOR_ONLY: only indoor use is allowed
+ * @NVM_CHANNEL_GO_CONCURRENT: GO operation is allowed when connected to BSS
+ *	on same channel on 2.4 or same UNII band on 5.2
  * @NVM_CHANNEL_WIDE: 20 MHz channel okay (?)
  * @NVM_CHANNEL_40MHZ: 40 MHz channel okay (?)
  * @NVM_CHANNEL_80MHZ: 80 MHz channel okay (?)
@@ -185,7 +187,8 @@ enum iwl_nvm_channel_flags {
 	NVM_CHANNEL_IBSS = BIT(1),
 	NVM_CHANNEL_ACTIVE = BIT(3),
 	NVM_CHANNEL_RADAR = BIT(4),
-	NVM_CHANNEL_DFS = BIT(7),
+	NVM_CHANNEL_INDOOR_ONLY = BIT(5),
+	NVM_CHANNEL_GO_CONCURRENT = BIT(6),
 	NVM_CHANNEL_WIDE = BIT(8),
 	NVM_CHANNEL_40MHZ = BIT(9),
 	NVM_CHANNEL_80MHZ = BIT(10),
@@ -273,6 +276,16 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		if (ch_flags & NVM_CHANNEL_RADAR)
 			channel->flags |= IEEE80211_CHAN_RADAR;
 
+		if (ch_flags & NVM_CHANNEL_INDOOR_ONLY)
+			channel->flags |= IEEE80211_CHAN_INDOOR_ONLY;
+
+		/* Set the GO concurrent flag only in case that NO_IR is set.
+		 * Otherwise it is meaningless
+		 */
+		if ((ch_flags & NVM_CHANNEL_GO_CONCURRENT) &&
+		    (channel->flags & IEEE80211_CHAN_NO_IR))
+			channel->flags |= IEEE80211_CHAN_GO_CONCURRENT;
+
 		/* Initialize regulatory-based run-time data */
 
 		/*
@@ -282,7 +295,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		channel->max_power = DEFAULT_MAX_TX_POWER;
 		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
 		IWL_DEBUG_EEPROM(dev,
-				 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
+				 "Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
 				 channel->hw_value,
 				 is_5ghz ? "5.2" : "2.4",
 				 CHECK_AND_PRINT_I(VALID),
@@ -290,7 +303,8 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 				 CHECK_AND_PRINT_I(ACTIVE),
 				 CHECK_AND_PRINT_I(RADAR),
 				 CHECK_AND_PRINT_I(WIDE),
-				 CHECK_AND_PRINT_I(DFS),
+				 CHECK_AND_PRINT_I(INDOOR_ONLY),
+				 CHECK_AND_PRINT_I(GO_CONCURRENT),
 				 ch_flags,
 				 channel->max_power,
 				 ((ch_flags & NVM_CHANNEL_IBSS) &&
-- 
1.8.3.2

