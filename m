Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:11716 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933330AbXCZWjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 18:39:25 -0400
Subject: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
From: mohamed <mabbas@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain
Date: Mon, 26 Mar 2007 04:38:25 -0700
Message-Id: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add basic support for IEEE 802.11n discovery and association.

This patch adds support to discover IEEE 802.11n AP and enable 
association to 802.11n Network. It parses beacon to discover 802.11n 
IE and include HT capability information element in Association Request
Frame. 
It also call low level driver with the HT capability available during 
association. 

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff -Nupr wireless-dev/include/net/mac80211.h
wireless-dev-new/include/net/mac80211.h
--- wireless-dev/include/net/mac80211.h	2007-03-27 00:36:28.000000000
-0700
+++ wireless-dev-new/include/net/mac80211.h	2007-03-27
00:59:40.000000000 -0700
@@ -526,6 +526,9 @@ struct ieee80211_hw {
 	 * per-packet RC4 key with each TX frame when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
 
+	/* The device capable of supporting 11n */
+#define IEEE80211_HW_SUPPORT_HT_MODE (1<<15)
+
 	u32 flags;			/* hardware flags defined above */
 
 	/* Set to the size of a needed device specific skb headroom for TX
skbs. */
@@ -720,6 +723,17 @@ struct ieee80211_ops {
 	/* Get the current TSF timer value from firmware/hardware. Currently,
 	 * this is only used for IBSS mode debugging and, as such, is not a
 	 * required function. */
+
+	/* Configure ht parameters 
+	*/
+	int (*conf_ht)(struct ieee80211_hw *hw, 
+		       struct ieee80211_ht_capability *ht_cap_param,
+		       struct ieee80211_ht_additional_info *ht_extra_param);
+
+	/* Get ht capabilities from the device */
+	int (*get_ht_capab)(struct ieee80211_hw *hw,
+			    struct ieee80211_ht_capability *ht_cap_param);
+
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 
 	/* Reset the TSF timer and allow firmware/hardware to synchronize with
diff -Nupr wireless-dev/net/mac80211/ieee80211_i.h
wireless-dev-new/net/mac80211/ieee80211_i.h
--- wireless-dev/net/mac80211/ieee80211_i.h	2007-03-27
00:36:28.000000000 -0700
+++ wireless-dev-new/net/mac80211/ieee80211_i.h	2007-03-27
00:59:40.000000000 -0700
@@ -91,6 +91,8 @@ struct ieee80211_sta_bss {
 	size_t rsn_ie_len;
 	u8 *wmm_ie;
 	size_t wmm_ie_len;
+	u8 *ht_ie;
+	size_t ht_ie_len;
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -269,6 +271,7 @@ struct ieee80211_if_sta {
 	unsigned int create_ibss:1;
 	unsigned int mixed_cell:1;
 	unsigned int wmm_enabled:1;
+	unsigned int ht_enabled:1;
 	unsigned int auto_ssid_sel:1;
 	unsigned int auto_bssid_sel:1;
 	unsigned int auto_channel_sel:1;
diff -Nupr wireless-dev/net/mac80211/ieee80211_iface.c
wireless-dev-new/net/mac80211/ieee80211_iface.c
--- wireless-dev/net/mac80211/ieee80211_iface.c	2007-03-27
00:36:28.000000000 -0700
+++ wireless-dev-new/net/mac80211/ieee80211_iface.c	2007-03-27
00:59:40.000000000 -0700
@@ -191,6 +191,7 @@ void ieee80211_if_set_type(struct net_de
 			IEEE80211_AUTH_ALG_SHARED_KEY;
 		ifsta->create_ibss = 1;
 		ifsta->wmm_enabled = 1;
+		ifsta->ht_enabled = 1;
 		ifsta->auto_channel_sel = 1;
 		ifsta->auto_bssid_sel = 1;
 
diff -Nupr wireless-dev/net/mac80211/ieee80211_sta.c
wireless-dev-new/net/mac80211/ieee80211_sta.c
--- wireless-dev/net/mac80211/ieee80211_sta.c	2007-03-27
00:36:28.000000000 -0700
+++ wireless-dev-new/net/mac80211/ieee80211_sta.c	2007-03-27
01:26:06.000000000 -0700
@@ -96,6 +96,10 @@ struct ieee802_11_elems {
 	u8 rsn_len;
 	u8 *erp_info;
 	u8 erp_info_len;
+	u8 *ht_cap_param;
+	u8 ht_cap_param_len;
+	u8 *ht_extra_param;
+	u8 ht_extra_param_len;
 	u8 *ext_supp_rates;
 	u8 ext_supp_rates_len;
 	u8 *wmm_info;
@@ -197,6 +201,14 @@ static ParseRes ieee802_11_parse_elems(u
 			elems->ext_supp_rates = pos;
 			elems->ext_supp_rates_len = elen;
 			break;
+		case WLAN_EID_HT_CAPABILITY:
+			elems->ht_cap_param = pos;
+			elems->ht_cap_param_len = elen;
+			break;
+		case WLAN_EID_HT_EXTRA_INFO:		
+			elems->ht_extra_param = pos;
+			elems->ht_extra_param_len = elen;
+			break;
 		default:
 #if 0
 			printk(KERN_DEBUG "IEEE 802.11 element parse ignored "
@@ -230,7 +242,55 @@ static int ecw2cw(int ecw)
 	return cw - 1;
 }
 
+/* call low level driver with 11n params as it was recieved
+   from the AP
+*/   
+static void ieee80211_sta_ht_params(struct net_device *dev, 
+			struct sta_info *sta,
+			struct ieee80211_ht_additional_info *ht_extra_param,
+			struct ieee80211_ht_capability *ht_cap_param)
+{
+	int rc;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	if (local->ops->conf_ht) {
+		rc = local->ops->conf_ht(local_to_hw(local), ht_cap_param, 
+					 ht_extra_param);
+
+		if (rc)
+			sta->flags &= ~WLAN_STA_HT;
+	} else 
+		sta->flags &= ~WLAN_STA_HT;
+
+	return;
+}
+
+/* Get 11n capabilties from low level driver */
+static void ieee80211_fill_ht_ie(struct net_device *dev,
+				 struct ieee80211_ht_capability *ht_capab)
+{
+	int rc;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	if (!local->ops->get_ht_capab){
+		memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
+		return;
+	}
+
+	rc = local->ops->get_ht_capab(local_to_hw(local), ht_capab);
+	if (!rc) {
+		memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
+		return;
+	}
 
+	ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
+					ht_capab->capabilitiesInfo);
+	ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
+					ht_capab->extended_ht_capability_info);
+	ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
+					ht_capab->tx_BF_capability_info);
+}
+ 
 static void ieee80211_sta_wmm_params(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     u8 *wmm_param, size_t wmm_param_len)
@@ -487,6 +547,7 @@ static void ieee80211_send_assoc(struct 
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
+	int ht_enabled = 0;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -509,6 +570,9 @@ static void ieee80211_send_assoc(struct 
 			capab |= WLAN_CAPABILITY_PRIVACY;
 		if (bss->wmm_ie) {
 			wmm = 1;
+		
+			if (bss->ht_ie)
+				ht_enabled = 1;
 		}
 		ieee80211_rx_bss_put(dev, bss);
 	}
@@ -584,6 +648,15 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 0;
 	}
 
+	/* if low level driver support 11n fill in 11n IE */
+	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_capability);
+		ieee80211_fill_ht_ie(dev, 
+				     (struct ieee80211_ht_capability *)pos);
+	}
+		
 	kfree(ifsta->assocreq_ies);
 	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
 	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_ATOMIC);
@@ -1215,6 +1288,16 @@ static void ieee80211_rx_mgmt_assoc_resp
 	}
 	sta->supp_rates = rates;
 
+	if (elems.ht_extra_param && elems.ht_cap_param && elems.wmm_param &&
+	    ifsta->ht_enabled  ) {
+		sta->flags |= WLAN_STA_HT;
+		ieee80211_sta_ht_params(dev, sta, 
+					(struct ieee80211_ht_additional_info *) 
+					elems.ht_extra_param, 
+					(struct ieee80211_ht_capability *)
+					elems.ht_cap_param);
+	}
+
 	rate_control_rate_init(sta, local);
 
 	if (elems.wmm_param && ifsta->wmm_enabled) {
@@ -1310,6 +1393,7 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss->wpa_ie);
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
+	kfree(bss->ht_ie);
 	kfree(bss);
 }
 
@@ -1556,6 +1640,22 @@ static void ieee80211_rx_bss_info(struct
 		bss->wmm_ie_len = 0;
 	}
 
+	if (elems.ht_cap_param &&
+	    (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_param_len ||
+	     memcmp(bss->ht_ie, elems.ht_cap_param, elems.ht_cap_param_len)))
{
+		kfree(bss->ht_ie);	
+		bss->ht_ie = kmalloc(elems.ht_cap_param_len + 2, GFP_ATOMIC);
+		if (bss->ht_ie) {
+			memcpy(bss->ht_ie, elems.ht_cap_param - 2,
+				elems.ht_cap_param_len + 2);
+			bss->ht_ie_len = elems.ht_cap_param_len + 2;
+		} else
+                        bss->ht_ie_len = 0;
+	} else if (!elems.ht_cap_param && bss->ht_ie) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = NULL;
+		bss->ht_ie_len = 0;
+	}
 
 	bss->hw_mode = rx_status->phymode;
 	bss->channel = channel;
diff -Nupr wireless-dev/net/mac80211/ieee80211_sysfs_sta.c
wireless-dev-new/net/mac80211/ieee80211_sysfs_sta.c
--- wireless-dev/net/mac80211/ieee80211_sysfs_sta.c	2007-03-27
00:36:28.000000000 -0700
+++ wireless-dev-new/net/mac80211/ieee80211_sysfs_sta.c	2007-03-27
00:59:40.000000000 -0700
@@ -79,7 +79,7 @@ STA_ATTR(wep_weak_iv_count, wep_weak_iv_
 
 static ssize_t show_sta_flags(const struct sta_info *sta, char *buf)
 {
-	return sprintf(buf, "%s%s%s%s%s%s%s%s%s",
+	return sprintf(buf, "%s%s%s%s%s%s%s%s%s%s",
 		       sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		       sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		       sta->flags & WLAN_STA_PS ? "PS\n" : "",
@@ -89,7 +89,8 @@ static ssize_t show_sta_flags(const stru
 		       sta->flags & WLAN_STA_SHORT_PREAMBLE ?
 		       "SHORT PREAMBLE\n" : "",
 		       sta->flags & WLAN_STA_WME ? "WME\n" : "",
-		       sta->flags & WLAN_STA_WDS ? "WDS\n" : "");
+		       sta->flags & WLAN_STA_WDS ? "WDS\n" : "",
+		       sta->flags & WLAN_STA_HT ? "HT\n" : "");
 }
 __STA_ATTR(flags);
 
diff -Nupr wireless-dev/net/mac80211/sta_info.h
wireless-dev-new/net/mac80211/sta_info.h
--- wireless-dev/net/mac80211/sta_info.h	2007-03-27 00:36:28.000000000
-0700
+++ wireless-dev-new/net/mac80211/sta_info.h	2007-03-27
00:59:40.000000000 -0700
@@ -26,6 +26,7 @@
 				    */
 #define WLAN_STA_SHORT_PREAMBLE BIT(7)
 #define WLAN_STA_WME BIT(9)
+#define WLAN_STA_HT  BIT(10)
 #define WLAN_STA_WDS BIT(27)
 
 
