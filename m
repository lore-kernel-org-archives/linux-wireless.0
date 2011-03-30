Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36385 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab1C3DGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:06:55 -0400
Received: by yxs7 with SMTP id 7so357678yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:06:55 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com
Subject: [PATCH v5 04/10] nl80211: let userspace authenticate stations
Date: Tue, 29 Mar 2011 19:06:01 -0700
Message-Id: <1301450767-27045-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |    2 ++
 net/mac80211/cfg.c      |    6 ++++++
 net/wireless/nl80211.c  |    5 ++++-
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 91e3a8d..ca4b546 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1169,6 +1169,7 @@ enum nl80211_iftype {
  *	with short barker preamble
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
+ * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1178,6 +1179,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SHORT_PREAMBLE,
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
+	NL80211_STA_FLAG_AUTHENTICATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4f73085..c57d653 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -675,6 +675,12 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
 	}
+
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
+		sta->flags &= ~WLAN_STA_AUTH;
+		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			sta->flags |= WLAN_STA_AUTH;
+	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5878f2b..e76dc79 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1922,6 +1922,7 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -2262,7 +2263,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.supported_rates)
 			err = -EINVAL;
-		if (params.sta_flags_mask)
+		if (params.sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				  BIT(NL80211_STA_FLAG_AUTHORIZED)))
 			err = -EINVAL;
 		break;
 	default:
-- 
1.7.4.1

