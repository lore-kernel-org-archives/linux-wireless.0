Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:42651 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaETHiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:38:13 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH] mac80211: avoid "uninitialised variable" warning
Date: Tue, 20 May 2014 09:36:54 +0200
Message-Id: <1400571414-19116-1-git-send-email-antonio@meshcoding.com> (sfid-20140520_093820_763857_ADB5F62F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc is not able to correlate chan_pwr and have_chan_pwr
in ieee80211_handle_pwr_constr(), therefore it throws a
warning about chan_pwr being potentially used uninitialised
even if this is not true.

However, initialise chan_pwr to 0 to silent the warning.

Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f073ef..43a2a7c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1146,7 +1146,7 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_country_ie_triplet *triplet;
 	int chan = ieee80211_frequency_to_channel(channel->center_freq);
-	int i, chan_pwr, chan_increment, new_ap_level;
+	int i, chan_pwr = 0, chan_increment, new_ap_level;
 	bool have_chan_pwr = false;
 
 	/* Invalid IE */
-- 
1.8.5.5

