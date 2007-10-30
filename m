Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:7112 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXJaBpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:45:06 -0400
Received: by nz-out-0506.google.com with SMTP id s18so1619429nze
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 18:45:05 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 29 Oct 2007 18:51:58 -0700
Subject: [PATCH 6/7] o80211s: support for mesh beaconing
Message-ID: <4727de20.27f8720a.49f8.ffffe7fc@mx.google.com> (sfid-20071031_014509_292165_F3A8955D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211.c     |    7 +++
 net/mac80211/ieee80211_i.h   |    3 +
 net/mac80211/ieee80211_sta.c |   88 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index fc7c6a8..e6839fd 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -473,6 +473,13 @@ static int __ieee80211_if_config(struct net_device *dev,
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
+	} else if (sdata->type == IEEE80211_IF_TYPE_MESH) {
+		/* SSID is wildcard (all 0s) */
+		conf.mesh_id = sdata->u.sta.mesh_id;
+		conf.mesh_id_len = sdata->u.sta.mesh_id_len;
+		ieee80211_set_mesh_beacon_template(dev, &conf);
+		local->hw.flags |= IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+		ieee80211_start_mesh(dev);
 	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 518c55e..b66e000 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -766,6 +766,9 @@ int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
 void ieee80211_reset_erp_info(struct net_device *dev);
 void ieee80211_start_mesh(struct net_device *dev);
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf);
+
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8c5f23a..2c24980 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2213,6 +2213,94 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	return -1;
 }
 
+
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos;
+	int rates, i;
+
+	if(!skb)
+		return -1;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_BEACON);
+	memset(mgmt->da, 0xff, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	/* SSID is left zeroed, wildcard value */
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	rates = mode->num_rates;
+	if (rates > 8)
+		rates = 8;
+	pos = skb_put(skb, 2 + rates);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = rates;
+	for (i = 0; i < rates; i++) {
+		int rate = mode->rates[i].rate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	if (mode->num_rates > 8) {
+		rates = mode->num_rates - 8;
+		pos = skb_put(skb, 2 + rates);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = rates;
+		for (i = 0; i < rates; i++) {
+			int rate = mode->rates[i+8].rate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
+
+	pos = skb_put(skb, 17);
+	*pos++ = WLAN_EID_MESH_CONFIG;
+	*pos++ = 15;
+	/* Version */
+	*pos++ = 1;
+
+	/* Active path selection protocol ID */
+	*pos++ = 0x00; /* 3 byte OUI:        */
+	*pos++ = 0x0f; /* All other OUIs are */
+	*pos++ = 0xac; /* vendor specific.   */
+	*pos++ = 0xff; /* Null protocol.     */
+
+	/* Active path selection metric ID   */
+	*pos++ = 0x00; /* 3 byte OUI */
+	*pos++ = 0x0f;
+	*pos++ = 0xac;
+	*pos++ = 0xff; /* Null metric */
+	/* Channel precedence:
+	 * Not running simple channel unification protocol
+	 */
+	memset(pos, 0x00, 4);
+	pos += 4;
+	/* Mesh capability */
+	memset(pos, 0x00, 2);
+
+	pos = skb_put(skb, 2 + conf->mesh_id_len);
+	*pos++ = WLAN_EID_MESH_ID;
+	*pos++ = conf->mesh_id_len;
+	if (conf->mesh_id_len)
+		memcpy(pos, conf->mesh_id, conf->mesh_id_len);
+
+	conf->beacon = skb;
+	return 0;
+}
+
+
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
-- 
1.5.2.5



