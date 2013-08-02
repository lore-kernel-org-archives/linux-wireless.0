Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39932 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3HBPiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 11:38:17 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/7] mac80211: fix ieee80211_sta_process_chanswitch for 5/10 MHz channels
Date: Fri,  2 Aug 2013 17:38:01 +0200
Message-Id: <1375457886-7275-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130802_173830_208221_9CEED21E)
In-Reply-To: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/mlme.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 211246b..45a87ee 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1102,6 +1102,15 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	case -1:
 		cfg80211_chandef_create(&new_chandef, new_chan,
 					NL80211_CHAN_NO_HT);
+		/* keep width for 5/10 MHz channels */
+		switch (sdata->vif.bss_conf.chandef.width) {
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
+			new_chandef.width = sdata->vif.bss_conf.chandef.width;
+			break;
+		default:
+			break;
+		}
 		break;
 	}
 
-- 
1.7.10.4

