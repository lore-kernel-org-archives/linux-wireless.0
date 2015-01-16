Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35400 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbbAPKjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:35 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so2936824wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:39:34 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 1/6] mac80211: ibss, fix chandef setup for HT40
Date: Fri, 16 Jan 2015 11:38:39 +0100
Message-Id: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113940_469889_05CC4050)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases when used HT40+/HT40-, center_freq1
was configured incorrectly. Next this couse
fall back to HT20.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b606b53..13b8105 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -407,10 +407,15 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->u.ibss.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
-	case NL80211_CHAN_WIDTH_40:
 		chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
 		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
 		break;
+	case NL80211_CHAN_WIDTH_40:
+		cfg80211_chandef_create(&chandef, cbss->channel,
+					NL80211_CHAN_WIDTH_20_NOHT);
+		chandef.width = sdata->u.ibss.chandef.width;
+		chandef.center_freq1 = sdata->u.ibss.chandef.center_freq1;
+		break;
 	case NL80211_CHAN_WIDTH_5:
 	case NL80211_CHAN_WIDTH_10:
 		cfg80211_chandef_create(&chandef, cbss->channel,
-- 
1.9.1

