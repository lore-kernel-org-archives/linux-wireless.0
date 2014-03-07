Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46427 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaCGNiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:11 -0500
Received: by mail-ee0-f48.google.com with SMTP id e51so1746578eek.7
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:10 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 5/8] nl80211: Modify chandef related functions to work with 5/10MHz channels
Date: Fri,  7 Mar 2014 14:37:52 +0100
Message-Id: <1394199475-5208-6-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143822_582062_B4D4A778)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4fe2e6e..48040cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1843,6 +1843,8 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
 
 		switch (chantype) {
+		case NL80211_CHAN_5MHZ:
+		case NL80211_CHAN_10MHZ:
 		case NL80211_CHAN_NO_HT:
 		case NL80211_CHAN_HT20:
 		case NL80211_CHAN_HT40PLUS:
@@ -2213,6 +2215,8 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 			chandef->chan->center_freq))
 		return -ENOBUFS;
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
-- 
1.8.5.1

