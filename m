Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXKIICT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:19 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 04/14] mac80211: adding 802.11n IEs handling
Date: Fri,  9 Nov 2007 10:01:56 +0200
Message-Id: <1194595331658-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080233_786385_246A4D83)
In-Reply-To: <11945953312367-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch presents the ability to parse and compose HT IEs, and to put
the IE relevant data inside the mac80211's internal HT structures

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h   |   11 ++++
 net/mac80211/ieee80211_sta.c |  106 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

Index: wl2_6_24_HT/net/mac80211/ieee80211_i.h
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/ieee80211_i.h
+++ wl2_6_24_HT/net/mac80211/ieee80211_i.h
@@ -89,6 +89,10 @@ struct ieee80211_sta_bss {
 	size_t rsn_ie_len;
 	u8 *wmm_ie;
 	size_t wmm_ie_len;
+#ifdef CONFIG_MAC80211_HT
+	u8 *ht_ie;
+	size_t ht_ie_len;
+#endif /* CONFIG_MAC80211_HT */
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -759,6 +763,13 @@ int ieee80211_sta_deauthenticate(struct 
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
 void ieee80211_reset_erp_info(struct net_device *dev);
+#ifdef CONFIG_MAC80211_HT
+int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
+				   struct ieee80211_ht_info *ht_info);
+int ieee80211_ht_addt_info_ie_to_ht_bss_info(
+			struct ieee80211_ht_addt_info *ht_add_info_ie,
+			struct ieee80211_ht_bss_info *bss_info);
+#endif /* CONFIG_MAC80211_HT */
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
Index: wl2_6_24_HT/net/mac80211/ieee80211_sta.c
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/ieee80211_sta.c
+++ wl2_6_24_HT/net/mac80211/ieee80211_sta.c
@@ -90,7 +90,10 @@ struct ieee802_11_elems {
 	u8 *ext_supp_rates;
 	u8 *wmm_info;
 	u8 *wmm_param;
-
+#ifdef CONFIG_MAC80211_HT
+	u8 *ht_cap_elem;
+	u8 *ht_info_elem;
+#endif /* CONFIG_MAC80211_HT */
 	/* length of them, respectively */
 	u8 ssid_len;
 	u8 supp_rates_len;
@@ -106,6 +109,10 @@ struct ieee802_11_elems {
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
+#ifdef CONFIG_MAC80211_HT
+	u8 ht_cap_elem_len;
+	u8 ht_info_elem_len;
+#endif /* CONFIG_MAC80211_HT */
 };
 
 static void ieee802_11_parse_elems(u8 *start, size_t len,
@@ -190,6 +197,16 @@ static void ieee802_11_parse_elems(u8 *s
 			elems->ext_supp_rates = pos;
 			elems->ext_supp_rates_len = elen;
 			break;
+#ifdef CONFIG_MAC80211_HT
+		case WLAN_EID_HT_CAPABILITY:
+			elems->ht_cap_elem = pos;
+			elems->ht_cap_elem_len = elen;
+			break;
+		case WLAN_EID_HT_EXTRA_INFO:
+			elems->ht_info_elem = pos;
+			elems->ht_info_elem_len = elen;
+			break;
+#endif /* CONFIG_MAC80211_HT */
 		default:
 			break;
 		}
@@ -332,6 +349,55 @@ static void ieee80211_handle_erp_ie(stru
 		ieee80211_erp_info_change_notify(dev, changes);
 }
 
+#ifdef CONFIG_MAC80211_HT
+
+int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
+				   struct ieee80211_ht_info *ht_info)
+{
+
+	if (ht_info == NULL)
+		return -EINVAL;
+
+	memset(ht_info, 0, sizeof(*ht_info));
+
+	if (ht_cap_ie) {
+		u8 ampdu_info = ht_cap_ie->ampdu_params_info;
+
+		ht_info->ht_supported = 1;
+		ht_info->cap = le16_to_cpu(ht_cap_ie->cap_info);
+		ht_info->ampdu_factor =
+			ampdu_info & IEEE80211_HT_CAP_AMPDU_FACTOR;
+		ht_info->ampdu_density =
+			(ampdu_info & IEEE80211_HT_CAP_AMPDU_DENSITY) >> 2;
+		memcpy(ht_info->supp_mcs_set, ht_cap_ie->supp_mcs_set, 16);
+	} else
+		ht_info->ht_supported = 0;
+
+	return 0;
+}
+
+int ieee80211_ht_addt_info_ie_to_ht_bss_info(
+			struct ieee80211_ht_addt_info *ht_add_info_ie,
+			struct ieee80211_ht_bss_info *bss_info)
+{
+	if (bss_info == NULL)
+		return -EINVAL;
+
+	memset(bss_info, 0, sizeof(*bss_info));
+
+	if (ht_add_info_ie) {
+		u16 op_mode;
+		op_mode = le16_to_cpu(ht_add_info_ie->operation_mode);
+
+		bss_info->primary_channel = ht_add_info_ie->control_chan;
+		bss_info->bss_cap = ht_add_info_ie->ht_param;
+		bss_info->bss_op_mode = (u8)(op_mode & 0xff);
+	}
+
+	return 0;
+}
+
+#endif /* CONFIG_MAC80211_HT */
 
 static void ieee80211_sta_send_associnfo(struct net_device *dev,
 					 struct ieee80211_if_sta *ifsta)
@@ -630,6 +696,21 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 1; /* WME ver */
 		*pos++ = 0;
 	}
+#ifdef CONFIG_MAC80211_HT
+	/* wmm support is a must to HT */
+	if (wmm && mode->ht_info.ht_supported) {
+		__le16 tmp = cpu_to_le16(mode->ht_info.cap);
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		memcpy(pos, &tmp, sizeof(u16));
+		pos += sizeof(u16);
+		*pos++ = (mode->ht_info.ampdu_factor |
+				(mode->ht_info.ampdu_density << 2));
+		memcpy(pos, mode->ht_info.supp_mcs_set, 16);
+	}
+#endif /* CONFIG_MAC80211_HT */
 
 	kfree(ifsta->assocreq_ies);
 	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
@@ -1384,6 +1465,9 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss->wpa_ie);
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
+#ifdef CONFIG_MAC80211_HT
+	kfree(bss->ht_ie);
+#endif /* CONFIG_MAC80211_HT */
 	kfree(bss);
 }
 
@@ -1631,8 +1715,24 @@ static void ieee80211_rx_bss_info(struct
 		bss->wmm_ie = NULL;
 		bss->wmm_ie_len = 0;
 	}
-
-
+#ifdef CONFIG_MAC80211_HT
+	if (elems.ht_cap_elem &&
+	    (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_elem_len ||
+	     memcmp(bss->ht_ie, elems.ht_cap_elem, elems.ht_cap_elem_len))) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = kmalloc(elems.ht_cap_elem_len + 2, GFP_ATOMIC);
+		if (bss->ht_ie) {
+			memcpy(bss->ht_ie, elems.ht_cap_elem - 2,
+			       elems.ht_cap_elem_len + 2);
+			bss->ht_ie_len = elems.ht_cap_elem_len + 2;
+		} else
+			bss->ht_ie_len = 0;
+	} else if (!elems.ht_cap_elem && bss->ht_ie) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = NULL;
+		bss->ht_ie_len = 0;
+	}
+#endif /* CONFIG_MAC80211_HT */
 	bss->hw_mode = rx_status->phymode;
 	bss->freq = rx_status->freq;
 	if (channel != rx_status->channel &&
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
