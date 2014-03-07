Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:65351 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaCGNiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:09 -0500
Received: by mail-ea0-f171.google.com with SMTP id n15so2305332ead.16
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:08 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 4/8] cfg80211: Modify chandef related functions to work with 5/10MHz channels
Date: Fri,  7 Mar 2014 14:37:51 +0100
Message-Id: <1394199475-5208-5-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143816_797871_A4DC54F6)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h |  4 ++++
 net/wireless/chan.c    | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f5ecd6c..16f19e0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -367,6 +367,10 @@ static inline enum nl80211_channel_type
 cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		return NL80211_CHAN_5MHZ;
+	case NL80211_CHAN_WIDTH_10:
+		return NL80211_CHAN_10MHZ;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		return NL80211_CHAN_NO_HT;
 	case NL80211_CHAN_WIDTH_20:
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..0bcdd27 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -22,6 +22,14 @@ void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 	chandef->center_freq2 = 0;
 
 	switch (chan_type) {
+	case NL80211_CHAN_5MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_5;
+		chandef->center_freq1 = chan->center_freq;
+		break;
+	case NL80211_CHAN_10MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_10;
+		chandef->center_freq1 = chan->center_freq;
+		break;
 	case NL80211_CHAN_NO_HT:
 		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 		chandef->center_freq1 = chan->center_freq;
@@ -531,12 +539,14 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		width = 5;
 		break;
 	case NL80211_CHAN_WIDTH_10:
+		prohibited_flags |= IEEE80211_CHAN_NO_10MHZ;
 		width = 10;
 		break;
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
 	case NL80211_CHAN_WIDTH_20_NOHT:
+		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
 		break;
 	case NL80211_CHAN_WIDTH_40:
-- 
1.8.5.1

