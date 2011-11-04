Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1KDKVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:11 -0400
Message-Id: <20111104101942.789686440@sipsolutions.net> (sfid-20111104_112114_233736_0C07C8AC)
Date: Fri, 04 Nov 2011 11:18:11 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/12] mac80211: add support for control port protocol in
 AP mode
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will allow us to support dynamic WEP with 802.1X
properly in mac80211 by not encrypting outgoing and
accepting unencrypted incoming frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   |   21 ++++++++++++++++++++-
 net/mac80211/iface.c |   13 ++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c	2011-11-03 11:52:40.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-11-03 11:52:48.000000000 +0100
@@ -594,6 +594,8 @@ static int ieee80211_add_beacon(struct w
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
+	struct ieee80211_sub_if_data *vlan;
+	int ret;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -601,7 +603,24 @@ static int ieee80211_add_beacon(struct w
 	if (old)
 		return -EALREADY;
 
-	return ieee80211_config_beacon(sdata, params);
+	ret = ieee80211_config_beacon(sdata, params);
+	if (ret)
+		return ret;
+
+	/*
+	 * Apply control port protocol, this allows us to
+	 * not encrypt dynamic WEP control frames.
+	 */
+	sdata->control_port_protocol = params->crypto.control_port_ethertype;
+	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+		vlan->control_port_protocol =
+			params->crypto.control_port_ethertype;
+		vlan->control_port_no_encrypt =
+			params->crypto.control_port_no_encrypt;
+	}
+
+	return 0;
 }
 
 static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
--- a/net/mac80211/iface.c	2011-11-03 11:52:47.000000000 +0100
+++ b/net/mac80211/iface.c	2011-11-03 11:52:48.000000000 +0100
@@ -188,11 +188,22 @@ static int ieee80211_do_open(struct net_
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
 		break;
-	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_AP_VLAN: {
+		struct ieee80211_sub_if_data *master;
+
 		if (!sdata->bss)
 			return -ENOLINK;
+
 		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
+
+		master = container_of(sdata->bss,
+				      struct ieee80211_sub_if_data, u.ap);
+		sdata->control_port_protocol =
+			master->control_port_protocol;
+		sdata->control_port_no_encrypt =
+			master->control_port_no_encrypt;
 		break;
+		}
 	case NL80211_IFTYPE_AP:
 		sdata->bss = &sdata->u.ap;
 		break;


