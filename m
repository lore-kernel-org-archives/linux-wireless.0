Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40802 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbZASQtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 11:49:05 -0500
Date: Mon, 19 Jan 2009 18:48:46 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix MFP Association Comeback to use Timeout
	Interval IE
Message-ID: <20090119164846.GA30710@jm.kir.nu> (sfid-20090119_174912_140214_2084517E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The separate Association Comeback Time IE was removed from IEEE 802.11w
and the Timeout Interval IE (from IEEE 802.11r) is used instead. The
editing on this is still somewhat incomplete in IEEE 802.11w/D7.0, but
still, the use of Timeout Interval IE is the expected mechanism.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/ieee80211.h  |    8 +++++++-
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |    5 +++--
 net/mac80211/util.c        |    6 +++---
 4 files changed, 15 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-01-19 18:34:11.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-01-19 18:37:48.000000000 +0200
@@ -1036,8 +1036,8 @@ enum ieee80211_eid {
 	WLAN_EID_HT_INFORMATION = 61,
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
+	WLAN_EID_TIMEOUT_INTERVAL = 56,
 	WLAN_EID_MMIE = 76 /* 802.11w */,
-	WLAN_EID_ASSOC_COMEBACK_TIME = 77,
 	WLAN_EID_WPA = 221,
 	WLAN_EID_GENERIC = 221,
 	WLAN_EID_VENDOR_SPECIFIC = 221,
@@ -1126,6 +1126,12 @@ struct ieee80211_country_ie_triplet {
 	};
 } __attribute__ ((packed));
 
+enum ieee80211_timeout_interval_type {
+	WLAN_TIMEOUT_REASSOC_DEADLINE = 1 /* 802.11r */,
+	WLAN_TIMEOUT_KEY_LIFETIME = 2 /* 802.11r */,
+	WLAN_TIMEOUT_ASSOC_COMEBACK = 3 /* 802.11w */,
+};
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-19 18:34:14.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-19 18:36:09.000000000 +0200
@@ -837,7 +837,7 @@ struct ieee802_11_elems {
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem; 	/* first quite element */
-	u8 *assoc_comeback;
+	u8 *timeout_int;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -865,7 +865,7 @@ struct ieee802_11_elems {
 	u8 pwr_constr_elem_len;
 	u8 quiet_elem_len;
 	u8 num_of_quiet_elem;	/* can be more the one */
-	u8 assoc_comeback_len;
+	u8 timeout_int_len;
 };
 
 static inline struct ieee80211_local *hw_to_local(
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-19 18:34:16.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-01-19 18:39:58.000000000 +0200
@@ -1317,9 +1317,10 @@ static void ieee80211_rx_mgmt_assoc_resp
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
-	    elems.assoc_comeback && elems.assoc_comeback_len == 4) {
+	    elems.timeout_int && elems.timeout_int_len == 5 &&
+	    elems.timeout_int[0] == WLAN_TIMEOUT_ASSOC_COMEBACK) {
 		u32 tu, ms;
-		tu = get_unaligned_le32(elems.assoc_comeback);
+		tu = get_unaligned_le32(elems.timeout_int + 1);
 		ms = tu * 1024 / 1000;
 		printk(KERN_DEBUG "%s: AP rejected association temporarily; "
 		       "comeback duration %u TU (%u ms)\n",
--- wireless-testing.orig/net/mac80211/util.c	2009-01-19 18:34:19.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-01-19 18:40:37.000000000 +0200
@@ -653,9 +653,9 @@ void ieee802_11_parse_elems(u8 *start, s
 			elems->pwr_constr_elem = pos;
 			elems->pwr_constr_elem_len = elen;
 			break;
-		case WLAN_EID_ASSOC_COMEBACK_TIME:
-			elems->assoc_comeback = pos;
-			elems->assoc_comeback_len = elen;
+		case WLAN_EID_TIMEOUT_INTERVAL:
+			elems->timeout_int = pos;
+			elems->timeout_int_len = elen;
 			break;
 		default:
 			break;

-- 
Jouni Malinen                                            PGP id EFC895FA
