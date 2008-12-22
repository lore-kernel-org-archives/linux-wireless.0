Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25114 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYLVSUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:20:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:20:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 01/18] mac80211: add HT conf helpers
Date: Mon, 22 Dec 2008 10:20:22 -0800
Message-ID: <1229970039-10561-2-git-send-email-lrodriguez@atheros.com> (sfid-20081222_192054_494051_F40AEF56)
In-Reply-To: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In HT capable drivers you often need to check if you
are currently using HT20 or HT40. This adds a few small
helpers to let drivers figure that out.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b3bd00a..ee2b75e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1963,4 +1963,34 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
+static inline bool
+conf_is_ht20(struct ieee80211_conf *conf)
+{
+	return conf->ht.channel_type == NL80211_CHAN_HT20;
+}
+
+static inline bool
+conf_is_ht40_minus(struct ieee80211_conf *conf)
+{
+	return conf->ht.channel_type == NL80211_CHAN_HT40MINUS;
+}
+
+static inline bool
+conf_is_ht40_plus(struct ieee80211_conf *conf)
+{
+	return conf->ht.channel_type == NL80211_CHAN_HT40PLUS;
+}
+
+static inline bool
+conf_is_ht40(struct ieee80211_conf *conf)
+{
+	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
+}
+
+static inline bool
+conf_is_ht(struct ieee80211_conf *conf)
+{
+	return conf->ht.channel_type != NL80211_CHAN_NO_HT;
+}
+
 #endif /* MAC80211_H */
-- 
1.6.1.rc3.51.g5832d

