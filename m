Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:25:50 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so242197eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:25:50 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC 3/5] nl80211/mac80211: allow adding TDLS peers as stations
Date: Thu, 15 Sep 2011 13:25:32 +0300
Message-Id: <1316082334-7664-4-git-send-email-arik@wizery.com> (sfid-20110915_122552_918148_08AA1F92)
In-Reply-To: <1316082334-7664-1-git-send-email-arik@wizery.com>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a TDLS peer STA is added it is marked with a new flag in both
nl80211 and in mac80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/linux/nl80211.h |    2 ++
 net/mac80211/cfg.c      |    6 ++++++
 net/mac80211/sta_info.h |    2 ++
 net/wireless/nl80211.c  |    3 ++-
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e21e023..34415e81 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1367,6 +1367,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1377,6 +1378,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 27dda09..3ef0bc6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -696,6 +696,12 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
 			sta->flags |= WLAN_STA_AUTH;
 	}
+
+	if (mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) {
+		sta->flags &= ~WLAN_STA_TDLS_PEER;
+		if (set & BIT(NL80211_STA_FLAG_TDLS_PEER))
+			sta->flags |= WLAN_STA_TDLS_PEER;
+	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 25fb49e..ae497e3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -45,6 +45,7 @@
  *	station in power-save mode, reply when the driver unblocks.
  * @WLAN_STA_PS_DRIVER_BUF: Station has frames pending in driver internal
  *	buffers. Automatically cleared on station wake-up.
+ * @WLAN_STA_TDLS_PEER: station is a TDLS peer.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -61,6 +62,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_PS_DRIVER_BUF	= 1<<14,
+	WLAN_STA_TDLS_PEER	= 1<<15,
 };
 
 #define STA_TID_NUM 16
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 74a4ad4..81b67a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2598,7 +2598,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
 	err = get_vlan(info, rdev, &params.vlan);
-- 
1.7.4.1

