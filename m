Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59380 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3F0Q7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:59:15 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 09/18] mac80211: return if IBSS chandef can not be used
Date: Thu, 27 Jun 2013 18:58:51 +0200
Message-Id: <1372352340-20663-11-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_185937_953998_5600FE28)
In-Reply-To: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was originally designed to fail when a 40+/40- mode can not be
used, but basic modes (such as 5/10/20 MHz) must be handled
with an error.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/ibss.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6adc5af..2e0256b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -85,6 +85,14 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	chandef = ifibss->chandef;
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
+		    chandef.width == NL80211_CHAN_WIDTH_10 ||
+		    chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+		    chandef.width == NL80211_CHAN_WIDTH_20) {
+			sdata_info(sdata,
+				   "Failed to join IBSS, beacons forbidden\n");
+			return;
+		}
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
 	}
-- 
1.7.10.4

