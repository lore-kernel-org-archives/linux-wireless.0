Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZCSFyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:54:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 5/6] cfg80211: send channel max bandwidth to userspace
Date: Thu, 19 Mar 2009 01:54:39 -0400
Message-Id: <1237442080-27509-6-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065450_037485_AFB03527)
In-Reply-To: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |    3 +++
 net/wireless/nl80211.c  |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3700d92..3924fe4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -670,6 +670,7 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
+ * @NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH: max bandwidth allowed, given in MHz
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -679,6 +680,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -686,6 +688,7 @@ enum nl80211_frequency_attr {
 };
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+#define NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e03c9a2..e2727ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -208,9 +208,10 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
 			if (chan->flags & IEEE80211_CHAN_RADAR)
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
-
 			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 				    DBM_TO_MBM(chan->max_power));
+			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
+				    chan->max_bandwidth);
 
 			nla_nest_end(msg, nl_freq);
 		}
-- 
1.6.0.6

