Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:53615 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3JURXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:03 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so6969135wes.34
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/14] iwlegacy: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:32 +0200
Message-Id: <1382376158-25586-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192307_505858_11A342CB)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 drivers/net/wireless/iwlegacy/common.c   | 4 ++--
 drivers/net/wireless/iwlegacy/debug.c    | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dea3b50..5a66595 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1595,7 +1595,7 @@ il3945_get_channels_for_scan(struct il_priv *il, enum ieee80211_band band,
 		 *  and use long active_dwell time.
 		 */
 		if (!is_active || il_is_channel_passive(ch_info) ||
-		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
+		    (chan->flags & IEEE80211_CHAN_NO_IR)) {
 			scan_ch->type = 0;	/* passive */
 			if (IL_UCODE_API(il->ucode_ver) == 1)
 				scan_ch->active_dwell =
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 3982ab7..1c5f8cd 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -805,7 +805,7 @@ il4965_get_channels_for_scan(struct il_priv *il, struct ieee80211_vif *vif,
 		}
 
 		if (!is_active || il_is_channel_passive(ch_info) ||
-		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		    (chan->flags & IEEE80211_CHAN_NO_IR))
 			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b03e22e..a27b14c 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3445,10 +3445,10 @@ il_init_geos(struct il_priv *il)
 
 		if (il_is_channel_valid(ch)) {
 			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
-				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
+				geo_ch->flags |= IEEE80211_CHAN_NO_IR;
 
 			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
-				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+				geo_ch->flags |= IEEE80211_CHAN_NO_IR;
 
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index eff2650..3a487a3 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -567,12 +567,12 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
 				      flags & IEEE80211_CHAN_RADAR ?
 				      " (IEEE 802.11h required)" : "",
 				      ((channels[i].
-					flags & IEEE80211_CHAN_NO_IBSS) ||
+					flags & IEEE80211_CHAN_NO_IR) ||
 				       (channels[i].
 					flags & IEEE80211_CHAN_RADAR)) ? "" :
 				      ", IBSS",
 				      channels[i].
-				      flags & IEEE80211_CHAN_PASSIVE_SCAN ?
+				      flags & IEEE80211_CHAN_NO_IR ?
 				      "passive only" : "active/passive");
 	}
 	supp_band = il_get_hw_mode(il, IEEE80211_BAND_5GHZ);
@@ -594,12 +594,12 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
 				      flags & IEEE80211_CHAN_RADAR ?
 				      " (IEEE 802.11h required)" : "",
 				      ((channels[i].
-					flags & IEEE80211_CHAN_NO_IBSS) ||
+					flags & IEEE80211_CHAN_NO_IR) ||
 				       (channels[i].
 					flags & IEEE80211_CHAN_RADAR)) ? "" :
 				      ", IBSS",
 				      channels[i].
-				      flags & IEEE80211_CHAN_PASSIVE_SCAN ?
+				      flags & IEEE80211_CHAN_NO_IR ?
 				      "passive only" : "active/passive");
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-- 
1.8.4.rc3

