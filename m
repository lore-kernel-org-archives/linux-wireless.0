Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXJYNWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:47 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fb-0000dl-FO
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:44 +0100
Message-Id: <20071025093717.164643000@sipsolutions.net> (sfid-20071025_142255_850703_AC912B73)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 7/9] mac80211: implement cfg80211s station handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements station handling from userspace via cfg80211
in mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

--- linux-2.6.orig/net/mac80211/cfg.c	2007-10-24 11:35:54.752690568 +0200
+++ linux-2.6/net/mac80211/cfg.c	2007-10-24 11:35:58.552690568 +0200
@@ -14,6 +14,7 @@
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "cfg.h"
+#include "ieee80211_rate.h"
 
 static enum ieee80211_if_types
 nl80211_type_to_mac80211_type(enum nl80211_iftype type)
@@ -382,6 +383,194 @@ static int ieee80211_set_beacon(struct w
 	return ieee80211_if_config_beacon(dev);
 }
 
+/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
+struct iapp_layer2_update {
+	u8 da[ETH_ALEN];	/* broadcast */
+	u8 sa[ETH_ALEN];	/* STA addr */
+	__be16 len;		/* 6 */
+	u8 dsap;		/* 0 */
+	u8 ssap;		/* 0 */
+	u8 control;
+	u8 xid_info[3];
+} __attribute__ ((packed));
+
+static void ieee80211_send_layer2_update(struct sta_info *sta)
+{
+	struct iapp_layer2_update *msg;
+	struct sk_buff *skb;
+
+	/* Send Level 2 Update Frame to update forwarding tables in layer 2
+	 * bridge devices */
+
+	skb = dev_alloc_skb(sizeof(*msg));
+	if (!skb)
+		return;
+	msg = (struct iapp_layer2_update *)skb_put(skb, sizeof(*msg));
+
+	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
+	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
+
+	memset(msg->da, 0xff, ETH_ALEN);
+	memcpy(msg->sa, sta->addr, ETH_ALEN);
+	msg->len = htons(6);
+	msg->dsap = 0;
+	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
+	msg->control = 0xaf;	/* XID response lsb.1111F101.
+				 * F=0 (no poll command; unsolicited frame) */
+	msg->xid_info[0] = 0x81;	/* XID format identifier */
+	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
+	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
+
+	skb->dev = sta->dev;
+	skb->protocol = eth_type_trans(skb, sta->dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx(skb);
+}
+
+static void sta_apply_parameters(struct ieee80211_local *local,
+				 struct sta_info *sta,
+				 struct station_parameters *params)
+{
+	u32 rates;
+	int i, j;
+	struct ieee80211_hw_mode *mode;
+
+	if (params->station_flags & STATION_FLAG_CHANGED) {
+		sta->flags &= ~WLAN_STA_AUTHORIZED;
+		if (params->station_flags & STATION_FLAG_AUTHORIZED)
+			sta->flags |= WLAN_STA_AUTHORIZED;
+
+		sta->flags &= ~WLAN_STA_SHORT_PREAMBLE;
+		if (params->station_flags & STATION_FLAG_SHORT_PREAMBLE)
+			sta->flags |= WLAN_STA_SHORT_PREAMBLE;
+
+		sta->flags &= ~WLAN_STA_WME;
+		if (params->station_flags & STATION_FLAG_WME)
+			sta->flags |= WLAN_STA_WME;
+	}
+
+	if (params->aid) {
+		sta->aid = params->aid;
+		if (sta->aid > IEEE80211_MAX_AID)
+			sta->aid = 0; /* XXX: should this be an error? */
+	}
+
+	if (params->listen_interval >= 0)
+		sta->listen_interval = params->listen_interval;
+
+	if (params->supported_rates) {
+		rates = 0;
+		mode = local->oper_hw_mode;
+		for (i = 0; i < params->supported_rates_len; i++) {
+			int rate = (params->supported_rates[i] & 0x7f) * 5;
+			for (j = 0; j < mode->num_rates; j++) {
+				if (mode->rates[j].rate == rate)
+					rates |= BIT(j);
+			}
+		}
+		sta->supp_rates = rates;
+	}
+}
+
+static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *mac, struct station_parameters *params)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata;
+
+	/* Prevent a race with changing the rate control algorithm */
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	/* XXX: get sta belonging to dev */
+	sta = sta_info_get(local, mac);
+	if (sta) {
+		sta_info_put(sta);
+		return -EEXIST;
+	}
+
+	if (params->vlan) {
+		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
+
+		if (sdata->type != IEEE80211_IF_TYPE_VLAN ||
+		    sdata->type != IEEE80211_IF_TYPE_AP)
+			return -EINVAL;
+	} else
+		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	sta = sta_info_add(local, dev, mac, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
+
+	sta->dev = sdata->dev;
+	if (sdata->type == IEEE80211_IF_TYPE_VLAN ||
+	    sdata->type == IEEE80211_IF_TYPE_AP)
+		ieee80211_send_layer2_update(sta);
+
+	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
+
+	sta_apply_parameters(local, sta, params);
+
+	rate_control_rate_init(sta, local);
+
+	sta_info_put(sta);
+
+	return 0;
+}
+
+static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *mac)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+
+	if (mac) {
+		/* XXX: get sta belonging to dev */
+		sta = sta_info_get(local, mac);
+		if (!sta)
+			return -ENOENT;
+
+		sta_info_free(sta);
+		sta_info_put(sta);
+	} else
+		sta_info_flush(local, dev);
+
+	return 0;
+}
+
+static int ieee80211_change_station(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    u8 *mac,
+				    struct station_parameters *params)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	struct ieee80211_sub_if_data *vlansdata;
+
+	/* XXX: get sta belonging to dev */
+	sta = sta_info_get(local, mac);
+	if (!sta)
+		return -ENOENT;
+
+	if (params->vlan && params->vlan != sta->dev) {
+		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
+
+		if (vlansdata->type != IEEE80211_IF_TYPE_VLAN ||
+		    vlansdata->type != IEEE80211_IF_TYPE_AP)
+			return -EINVAL;
+
+		sta->dev = params->vlan;
+		ieee80211_send_layer2_update(sta);
+	}
+
+	sta_apply_parameters(local, sta, params);
+
+	sta_info_put(sta);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -391,4 +580,7 @@ struct cfg80211_ops mac80211_config_ops 
 	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
 	.set_beacon = ieee80211_set_beacon,
+	.add_station = ieee80211_add_station,
+	.del_station = ieee80211_del_station,
+	.change_station = ieee80211_change_station,
 };

-- 

