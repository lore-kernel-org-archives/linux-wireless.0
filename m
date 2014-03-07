Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40567 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaCGNiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:16 -0500
Received: by mail-ea0-f173.google.com with SMTP id r15so2299519ead.18
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:15 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 8/8] mac80211: Update conf_is_ht() to work properly with 5/10MHz channels
Date: Fri,  7 Mar 2014 14:37:55 +0100
Message-Id: <1394199475-5208-9-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143825_741051_79D0E395)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/mac80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..f56e45b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4585,7 +4585,9 @@ conf_is_ht40(struct ieee80211_conf *conf)
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
+	return (conf->chandef.width != NL80211_CHAN_WIDTH_5) &&
+		(conf->chandef.width != NL80211_CHAN_WIDTH_10) &&
+		(conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT);
 }
 
 static inline enum nl80211_iftype
-- 
1.8.5.1

