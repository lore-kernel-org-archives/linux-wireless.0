Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f43.google.com ([209.85.215.43]:50278 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:33:50 -0400
Received: by ewy20 with SMTP id 20so1671957ewy.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:33:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC 4/5] mac80211: add a HW flag for TDLS support
Date: Thu, 15 Sep 2011 13:25:33 +0300
Message-Id: <1316082334-7664-5-git-send-email-arik@wizery.com> (sfid-20110915_123358_258921_F572C594)
In-Reply-To: <1316082334-7664-1-git-send-email-arik@wizery.com>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow TDLS operations and peers only in supporting hardware.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/cfg.c     |   11 +++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..25bd038 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1094,6 +1094,9 @@ enum sta_notify_cmd {
  *	stations based on the PM bit of incoming frames.
  *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
  *	the PS mode of connected stations.
+ *
+ * @IEEE80211_HW_SUPPORTS_TDLS:
+ *	This device can operate as a TDLS (802.11z) peer.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1119,6 +1122,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
+	IEEE80211_HW_SUPPORTS_TDLS			= 1<<23,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3ef0bc6..9c6ac93 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -797,6 +797,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS) &&
+	    (sta->flags & WLAN_STA_TDLS_PEER)) {
+		return -ENOTSUPP;
+	}
+
 	rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
@@ -2308,6 +2313,9 @@ static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	bool send_direct;
 	int ret;
 
+	if (!(sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
 #ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
 	printk(KERN_DEBUG "TDLS mgmt action %d peer %pM\n", action_code, peer);
 #endif
@@ -2422,6 +2430,9 @@ static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 
+	if (!(sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
 #ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
 	printk(KERN_DEBUG "TDLS oper %d peer %pM\n", oper, peer);
 #endif
-- 
1.7.4.1

