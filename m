Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1DGXJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:30 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so2935734iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:30 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com
Subject: [PATCH v8 4/9] nl80211/mac80211: let userspace authenticate stations
Date: Thu,  7 Apr 2011 15:08:30 -0700
Message-Id: <1302214115-3688-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
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
index 59aa809..43c620e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1174,6 +1174,7 @@ enum nl80211_iftype {
  *	with short barker preamble
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
+ * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1183,6 +1184,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SHORT_PREAMBLE,
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
+	NL80211_STA_FLAG_AUTHENTICATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4f16f66..e8d7813 100644
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
index 4ce6e95..7a7b954 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1925,6 +1925,7 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -2265,7 +2266,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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
1.7.4.4

