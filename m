Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45779 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab1CDDL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:11:56 -0500
Received: by mail-gy0-f174.google.com with SMTP id 20so654114gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:11:56 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 5/7] nl80211: Let userspace set the authenticated flag for a mesh peer
Date: Thu,  3 Mar 2011 19:11:45 -0800
Message-Id: <1299208307-9428-6-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h |    7 ++++++-
 net/mac80211/cfg.c      |    6 ++++++
 net/wireless/nl80211.c  |    3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 6adaa58..209d10e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1159,8 +1159,11 @@ enum nl80211_iftype {
 /**
  * enum nl80211_sta_flags - station flags
  *
- * Station flags. When a station is added to an AP interface, it is
+ * Station flags. Stations added to an AP interface are
  * assumed to be already associated (and hence authenticated.)
+ * Mesh peers are added when they are discovered and authenticated later,
+ * either by userspace (SAE authentication) or in the kernel (open
+ * authentication).
  *
  * @__NL80211_STA_FLAG_INVALID: attribute number 0 is reserved
  * @NL80211_STA_FLAG_AUTHORIZED: station is authorized (802.1X)
@@ -1168,6 +1171,7 @@ enum nl80211_iftype {
  *	with short barker preamble
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
+ * @NL80211_STA_FLAG_AUTHENTICATED: (mesh) station is authenticated
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1177,6 +1181,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SHORT_PREAMBLE,
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
+	NL80211_STA_FLAG_AUTHENTICATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9d64ed9..a49fb0b 100644
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
index 150e8ed..52ab105 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2262,7 +2262,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.supported_rates)
 			err = -EINVAL;
-		if (params.sta_flags_mask)
+		if (params.sta_flags_mask &
+				~BIT(NL80211_STA_FLAG_AUTHENTICATED))
 			err = -EINVAL;
 		break;
 	default:
-- 
1.7.0.4

