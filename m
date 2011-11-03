Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab1KCJlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:41:16 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] mac80211: remove uneeded scan_chan variable
Date: Thu,  3 Nov 2011 10:40:45 +0100
Message-Id: <1320313247-23167-1-git-send-email-sgruszka@redhat.com> (sfid-20111103_104119_145580_085ED27A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/main.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d4ee6d2..7710b10 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -100,7 +100,7 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
  */
 bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 {
-	struct ieee80211_channel *chan, *scan_chan;
+	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type;
 
 	/* This logic needs to match logic in ieee80211_hw_config */
@@ -114,7 +114,7 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 		else
 			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
-		chan = scan_chan = local->tmp_channel;
+		chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 	} else {
 		chan = local->oper_channel;
@@ -135,7 +135,7 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
-	struct ieee80211_channel *chan, *scan_chan;
+	struct ieee80211_channel *chan;
 	int ret = 0;
 	int power;
 	enum nl80211_channel_type channel_type;
@@ -143,14 +143,12 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	might_sleep();
 
-	scan_chan = local->scan_channel;
-
 	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
 	 * may need to change as well.
 	 */
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
-	if (scan_chan) {
-		chan = scan_chan;
+	if (local->scan_channel) {
+		chan = local->scan_channel;
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
@@ -159,7 +157,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		else
 			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
-		chan = scan_chan = local->tmp_channel;
+		chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 	} else {
 		chan = local->oper_channel;
-- 
1.7.1

