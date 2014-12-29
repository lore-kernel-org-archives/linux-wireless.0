Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54996 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaL2J7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 04:59:07 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so21518522wiw.16
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2014 01:59:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: add TDLS supported channels correctly
Date: Mon, 29 Dec 2014 11:59:03 +0200
Message-Id: <1419847143-25447-1-git-send-email-arik@wizery.com> (sfid-20141229_105912_498843_BDD0281A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function adding the supported channels IE during a TDLS connection had
several issues:
1. If the entire subband is usable, the function exitted the loop without
adding it
2. The function only checked chandef_usable, ignoring flags like RADAR
which would prevent TDLS off-channel communcation.
3. HT20 was explicitly required in the chandef, while not a requirement
for TDLS off-channel.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 55ddd77..bd89249 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -68,12 +68,11 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 		ch = ieee80211_get_channel(sdata->local->hw.wiphy, i);
 		if (ch) {
 			/* we will be active on the channel */
-			u32 flags = IEEE80211_CHAN_DISABLED |
-				    IEEE80211_CHAN_NO_IR;
 			cfg80211_chandef_create(&chandef, ch,
-						NL80211_CHAN_HT20);
-			if (cfg80211_chandef_usable(sdata->local->hw.wiphy,
-						    &chandef, flags)) {
+						NL80211_CHAN_NO_HT);
+			if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
+						    &chandef,
+						    sdata->wdev.iftype)) {
 				ch_cnt++;
 				continue;
 			}
@@ -89,6 +88,14 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (ch_cnt) {
+		u8 *pos = skb_put(skb, 2);
+		*pos++ = ieee80211_frequency_to_channel(subband_start);
+		*pos++ = ch_cnt;
+
+		subband_cnt++;
+	}
+
 	return subband_cnt;
 }
 
-- 
2.1.0

