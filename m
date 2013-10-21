Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:35395 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3JURXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:00 -0400
Received: by mail-we0-f181.google.com with SMTP id t60so6727949wes.26
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/14] mwifiex: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:31 +0200
Message-Id: <1382376158-25586-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192305_000746_6E43E989)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 14 +++++++-------
 drivers/net/wireless/mwifiex/scan.c     |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fbad00a..7f68943 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -50,24 +50,24 @@ static const struct ieee80211_regdomain mwifiex_world_regdom_custom = {
 		REG_RULE(2412-10, 2462+10, 40, 3, 20, 0),
 		/* Channel 12 - 13 */
 		REG_RULE(2467-10, 2472+10, 20, 3, 20,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+			 NL80211_RRF_NO_IR),
 		/* Channel 14 */
 		REG_RULE(2484-10, 2484+10, 20, 3, 20,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_NO_IR |
 			 NL80211_RRF_NO_OFDM),
 		/* Channel 36 - 48 */
 		REG_RULE(5180-10, 5240+10, 40, 3, 20,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+			 NL80211_RRF_NO_IR),
 		/* Channel 149 - 165 */
 		REG_RULE(5745-10, 5825+10, 40, 3, 20,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+			 NL80211_RRF_NO_IR),
 		/* Channel 52 - 64 */
 		REG_RULE(5260-10, 5320+10, 40, 3, 30,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_NO_IR |
 			 NL80211_RRF_DFS),
 		/* Channel 100 - 140 */
 		REG_RULE(5500-10, 5700+10, 40, 3, 30,
-			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_NO_IR |
 			 NL80211_RRF_DFS),
 	}
 };
@@ -1968,7 +1968,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		user_scan_cfg->chan_list[i].radio_type = chan->band;
 
-		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		if (chan->flags & IEEE80211_CHAN_NO_IR)
 			user_scan_cfg->chan_list[i].scan_type =
 						MWIFIEX_SCAN_TYPE_PASSIVE;
 		else
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8cf7d50..0ed0664 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -515,14 +515,14 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16((u16) user_scan_in->
 					chan_list[0].scan_time);
-			else if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			else if (ch->flags & IEEE80211_CHAN_NO_IR)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->passive_scan_time);
 			else
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->active_scan_time);
 
-			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			if (ch->flags & IEEE80211_CHAN_NO_IR)
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_PASSIVE_SCAN;
 			else
-- 
1.8.4.rc3

