Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:40747 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572AbYFMPlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 11:41:25 -0400
Message-ID: <48528944.2040907@work.ksp.sk> (sfid-20080613_174129_401648_0630E83D)
Date: Fri, 13 Jun 2008 16:50:44 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: eliminate IBSS warning in rate_lowest_index()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode prior to join/creation of new IBSS it is possible that
a frame from unknown station is received and an ibss_add_sta() is
called. This will cause a warning in rate_lowest_index() since the
list of supported rates of our station is not initialized yet.

The fix is to add ibss stations with a rate we received that frame
at; this single-element set will be extended later based on beacon
data. Also there is no need to store stations from a foreign IBSS.


Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

---

diff -Naur compat-wireless-2008-06-12-base/net/mac80211/ieee80211_i.h compat-wireless-2008-06-12/net/mac80211/ieee80211_i.h
--- compat-wireless-2008-06-12-base/net/mac80211/ieee80211_i.h	2008-06-13 15:53:03.000000000 +0200
+++ compat-wireless-2008-06-12/net/mac80211/ieee80211_i.h	2008-06-13 16:17:11.000000000 +0200
@@ -886,7 +886,7 @@
 int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t len);
 struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
 					struct sk_buff *skb, u8 *bssid,
-					u8 *addr);
+					u8 *addr, u64 supp_rates);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
diff -Naur compat-wireless-2008-06-12-base/net/mac80211/mlme.c compat-wireless-2008-06-12/net/mac80211/mlme.c
--- compat-wireless-2008-06-12-base/net/mac80211/mlme.c	2008-06-13 15:52:54.000000000 +0200
+++ compat-wireless-2008-06-12/net/mac80211/mlme.c	2008-06-13 16:18:24.000000000 +0200
@@ -2863,7 +2863,8 @@
 				       dev->name, print_mac(mac, mgmt->bssid));
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
 			ieee80211_ibss_add_sta(dev, NULL,
-					       mgmt->bssid, mgmt->sa);
+					       mgmt->bssid, mgmt->sa,
+					       BIT(rx_status->rate_idx));
 		}
 	}

@@ -4307,12 +4308,13 @@

 struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
 					struct sk_buff *skb, u8 *bssid,
-					u8 *addr)
+					u8 *addr, u64 supp_rates)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
+	int band = local->hw.conf.channel->band;

 	/* TODO: Could consider removing the least recently used entry and
 	 * allow new one to be added. */
@@ -4324,6 +4326,9 @@
 		return NULL;
 	}

+	if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid))
+		return NULL;
+
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);

@@ -4333,8 +4338,10 @@

 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);

-	sta->supp_rates[local->hw.conf.channel->band] =
-		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
+	if (supp_rates)
+		sta->supp_rates[band] = supp_rates;
+	else
+		sta->supp_rates[band] = sdata->u.sta.supp_rates_bits[band];

 	rate_control_rate_init(sta, local);

diff -Naur compat-wireless-2008-06-12-base/net/mac80211/rx.c compat-wireless-2008-06-12/net/mac80211/rx.c
--- compat-wireless-2008-06-12-base/net/mac80211/rx.c	2008-06-13 15:50:11.000000000 +0200
+++ compat-wireless-2008-06-12/net/mac80211/rx.c	2008-06-13 16:17:11.000000000 +0200
@@ -1846,8 +1846,13 @@
 		if (!bssid)
 			return 0;
 		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON) {
+			if (!rx->sta)
+				rx->sta = ieee80211_ibss_add_sta(sdata->dev,
+						rx->skb, bssid, hdr->addr2,
+						BIT(rx->status->rate_idx));
 			return 1;
+		}
 		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
 			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
@@ -1860,7 +1865,8 @@
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta)
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
-							 bssid, hdr->addr2);
+						bssid, hdr->addr2,
+						BIT(rx->status->rate_idx));
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
 		if (!multicast &&

