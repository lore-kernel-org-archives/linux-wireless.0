Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:42310 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1BZBdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:25 -0500
Received: by gwb15 with SMTP id 15so1407576gwb.10
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:24 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: [PATCH 5/5] nl80211: Let userspace set the authenticated flag for a mesh peer.
Date: Fri, 25 Feb 2011 17:32:40 -0800
Message-Id: <1298683960-20835-6-git-send-email-thomas@cozybit.com>
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

---
 include/linux/nl80211.h |    7 ++++++-
 net/mac80211/cfg.c      |    6 ++++++
 net/wireless/nl80211.c  |    2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 528cd4c..625f8dc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1159,8 +1159,11 @@ enum nl80211_iftype {
 /**
  * enum nl80211_sta_flags - station flags
  *
- * Station flags. When a station is added to an AP interface, it is
+ * Station flags. Stations added to an AP interface, are
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
index b70e2a6..a292c2a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -662,6 +662,12 @@ static void sta_apply_parameters(struct ieee80211_local *local,
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
index 4651bcf..21f2533 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2244,7 +2244,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.supported_rates)
 			err = -EINVAL;
-		if (params.sta_flags_mask)
+		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHENTICATED))
 			err = -EINVAL;
 		break;
 	default:
-- 
1.7.0.4

