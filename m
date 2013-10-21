Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60901 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3JURXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:13 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so4326078wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/14] iwlwifi: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:37 +0200
Message-Id: <1382376158-25586-14-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193807_447080_93CDA8D3)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      | 8 ++++----
 drivers/net/wireless/iwlwifi/dvm/scan.c         | 2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/scan.c         | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index d94f8ab..f69301e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -352,12 +352,12 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 					channels[i].max_power,
 					channels[i].flags & IEEE80211_CHAN_RADAR ?
 					" (IEEE 802.11h required)" : "",
-					((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+					((channels[i].flags & IEEE80211_CHAN_NO_IR)
 					|| (channels[i].flags &
 					IEEE80211_CHAN_RADAR)) ? "" :
 					", IBSS",
 					channels[i].flags &
-					IEEE80211_CHAN_PASSIVE_SCAN ?
+					IEEE80211_CHAN_NO_IR ?
 					"passive only" : "active/passive");
 	}
 	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
@@ -375,12 +375,12 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 					channels[i].max_power,
 					channels[i].flags & IEEE80211_CHAN_RADAR ?
 					" (IEEE 802.11h required)" : "",
-					((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+					((channels[i].flags & IEEE80211_CHAN_NO_IR)
 					|| (channels[i].flags &
 					IEEE80211_CHAN_RADAR)) ? "" :
 					", IBSS",
 					channels[i].flags &
-					IEEE80211_CHAN_PASSIVE_SCAN ?
+					IEEE80211_CHAN_NO_IR ?
 					"passive only" : "active/passive");
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 35e0ee8..928f864 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -544,7 +544,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		channel = chan->hw_value;
 		scan_ch->channel = cpu_to_le16(channel);
 
-		if (!is_active || (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		if (!is_active || (chan->flags & IEEE80211_CHAN_NO_IR))
 			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 4c887f3..f4a6d31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -614,10 +614,10 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			channel->flags = IEEE80211_CHAN_NO_HT40;
 
 			if (!(eeprom_ch->flags & EEPROM_CHANNEL_IBSS))
-				channel->flags |= IEEE80211_CHAN_NO_IBSS;
+				channel->flags |= IEEE80211_CHAN_NO_IR;
 
 			if (!(eeprom_ch->flags & EEPROM_CHANNEL_ACTIVE))
-				channel->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+				channel->flags |= IEEE80211_CHAN_NO_IR;
 
 			if (eeprom_ch->flags & EEPROM_CHANNEL_RADAR)
 				channel->flags |= IEEE80211_CHAN_RADAR;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index b76a9a8..2fab203 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -223,10 +223,10 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			channel->flags |= IEEE80211_CHAN_NO_160MHZ;
 
 		if (!(ch_flags & NVM_CHANNEL_IBSS))
-			channel->flags |= IEEE80211_CHAN_NO_IBSS;
+			channel->flags |= IEEE80211_CHAN_NO_IR;
 
 		if (!(ch_flags & NVM_CHANNEL_ACTIVE))
-			channel->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+			channel->flags |= IEEE80211_CHAN_NO_IR;
 
 		if (ch_flags & NVM_CHANNEL_RADAR)
 			channel->flags |= IEEE80211_CHAN_RADAR;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index dff7592..e0cd100 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -192,7 +192,7 @@ static void iwl_mvm_scan_fill_channels(struct iwl_scan_cmd *cmd,
 	for (i = 0; i < cmd->channel_count; i++) {
 		chan->channel = cpu_to_le16(req->channels[i]->hw_value);
 		chan->type = cpu_to_le32(type);
-		if (req->channels[i]->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		if (req->channels[i]->flags & IEEE80211_CHAN_NO_IR)
 			chan->type &= cpu_to_le32(~SCAN_CHANNEL_TYPE_ACTIVE);
 		chan->active_dwell = cpu_to_le16(active_dwell);
 		chan->passive_dwell = cpu_to_le16(passive_dwell);
@@ -642,7 +642,7 @@ static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
 		channels->iter_count[index] = cpu_to_le16(1);
 		channels->iter_interval[index] = 0;
 
-		if (!(s_band->channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		if (!(s_band->channels[i].flags & IEEE80211_CHAN_NO_IR))
 			channels->type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
 
-- 
1.8.4.rc3

