Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43601 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbZAHLeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:34:11 -0500
Message-Id: <20090108113401.414539229@atheros.com> (sfid-20090108_123414_833013_5B4B1A64)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:09 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCHv2 11/16] mac80211: 802.11w - Implement Association Comeback processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When MFP is enabled, the AP does not allow a STA to associate if an
existing security association exists without first going through SA
Query process. When this happens, the association request is denied
with a new status code ("temporarily rejected") ans Association
Comeback IE is used to notify when the association may be tried again
(i.e., when the SA Query procedure has timed out).

Use the comeback time to update the mac80211 client MLME timer for
next association attempt to minimize waiting time if association is
temporarily rejected.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 include/linux/ieee80211.h  |    4 ++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |   20 +++++++++++++++++---
 net/mac80211/util.c        |    4 ++++
 4 files changed, 27 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-01-08 13:06:38.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-01-08 13:06:45.000000000 +0200
@@ -914,6 +914,9 @@ enum ieee80211_statuscode {
 	/* 802.11g */
 	WLAN_STATUS_ASSOC_DENIED_NOSHORTTIME = 25,
 	WLAN_STATUS_ASSOC_DENIED_NODSSSOFDM = 26,
+	/* 802.11w */
+	WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY = 30,
+	WLAN_STATUS_ROBUST_MGMT_FRAME_POLICY_VIOLATION = 31,
 	/* 802.11i */
 	WLAN_STATUS_INVALID_IE = 40,
 	WLAN_STATUS_INVALID_GROUP_CIPHER = 41,
@@ -1034,6 +1037,7 @@ enum ieee80211_eid {
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
 	WLAN_EID_MMIE = 76 /* 802.11w */,
+	WLAN_EID_ASSOC_COMEBACK_TIME = 77,
 	WLAN_EID_WPA = 221,
 	WLAN_EID_GENERIC = 221,
 	WLAN_EID_VENDOR_SPECIFIC = 221,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-08 13:06:36.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-08 13:06:45.000000000 +0200
@@ -821,6 +821,7 @@ struct ieee802_11_elems {
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem; 	/* first quite element */
+	u8 *assoc_comeback;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -848,6 +849,7 @@ struct ieee802_11_elems {
 	u8 pwr_constr_elem_len;
 	u8 quiet_elem_len;
 	u8 num_of_quiet_elem;	/* can be more the one */
+	u8 assoc_comeback_len;
 };
 
 static inline struct ieee80211_local *hw_to_local(
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-08 13:06:36.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-01-08 13:06:45.000000000 +0200
@@ -1288,6 +1288,23 @@ static void ieee80211_rx_mgmt_assoc_resp
 	       sdata->dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
+	pos = mgmt->u.assoc_resp.variable;
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+
+	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
+	    elems.assoc_comeback && elems.assoc_comeback_len == 4) {
+		u32 tu, ms;
+		tu = get_unaligned_le32(elems.assoc_comeback);
+		ms = tu * 1024 / 1000;
+		printk(KERN_DEBUG "%s: AP rejected association temporarily; "
+		       "comeback duration %u TU (%u ms)\n",
+		       sdata->dev->name, tu, ms);
+		if (ms > IEEE80211_ASSOC_TIMEOUT)
+			mod_timer(&ifsta->timer,
+				  jiffies + msecs_to_jiffies(ms));
+		return;
+	}
+
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       sdata->dev->name, status_code);
@@ -1303,9 +1320,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 		       "set\n", sdata->dev->name, aid);
 	aid &= ~(BIT(15) | BIT(14));
 
-	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
-
 	if (!elems.supp_rates) {
 		printk(KERN_DEBUG "%s: no SuppRates element in AssocResp\n",
 		       sdata->dev->name);
--- wireless-testing.orig/net/mac80211/util.c	2009-01-08 13:03:43.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-01-08 13:06:45.000000000 +0200
@@ -653,6 +653,10 @@ void ieee802_11_parse_elems(u8 *start, s
 			elems->pwr_constr_elem = pos;
 			elems->pwr_constr_elem_len = elen;
 			break;
+		case WLAN_EID_ASSOC_COMEBACK_TIME:
+			elems->assoc_comeback = pos;
+			elems->assoc_comeback_len = elen;
+			break;
 		default:
 			break;
 		}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
