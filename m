Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3977 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbXJZVHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: make ieee802_11_parse_elems return void
Date: Fri, 26 Oct 2007 17:04:35 -0400
Message-Id: <11934326823109-git-send-email-linville@tuxdriver.com> (sfid-20071026_220729_884134_E79A99DE)
In-Reply-To: <11934326821301-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
 <11934326823646-git-send-email-linville@tuxdriver.com>
 <11934326821301-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Some APs send management frames with junk padding after the last IE.
We already account for a similar problem with some Apple Airport
devices, but at least one device is known to send more than a single
extra byte.  The device in question is the Draytek Vigor2900:

	http://www.draytek.com.au/products/Vigor2900.php

The junk in question looks like an IE that runs off the end of the
frame.  This cause us to return ParseFailed.  Since the frame in
question is an association response, this causes us to fail to associate
with this AP.

The return code from ieee802_11_parse_elems is superfluous.
All callers still check for the presence of the specific IEs that
interest them anyway.  So, remove the return code so the parse never
"fails".

Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   56 ++++++-----------------------------------
 1 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index e78b51e..73d39e1 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -108,15 +108,11 @@ struct ieee802_11_elems {
 	u8 wmm_param_len;
 };
 
-typedef enum { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 } ParseRes;
-
-
-static ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
-				       struct ieee802_11_elems *elems)
+static void ieee802_11_parse_elems(u8 *start, size_t len,
+				   struct ieee802_11_elems *elems)
 {
 	size_t left = len;
 	u8 *pos = start;
-	int unknown = 0;
 
 	memset(elems, 0, sizeof(*elems));
 
@@ -127,15 +123,8 @@ static ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
 		elen = *pos++;
 		left -= 2;
 
-		if (elen > left) {
-#if 0
-			if (net_ratelimit())
-				printk(KERN_DEBUG "IEEE 802.11 element parse "
-				       "failed (id=%d elen=%d left=%d)\n",
-				       id, elen, left);
-#endif
-			return ParseFailed;
-		}
+		if (elen > left)
+			return;
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -202,28 +191,15 @@ static ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
 			elems->ext_supp_rates_len = elen;
 			break;
 		default:
-#if 0
-			printk(KERN_DEBUG "IEEE 802.11 element parse ignored "
-				      "unknown element (id=%d elen=%d)\n",
-				      id, elen);
-#endif
-			unknown++;
 			break;
 		}
 
 		left -= elen;
 		pos += elen;
 	}
-
-	/* Do not trigger error if left == 1 as Apple Airport base stations
-	 * send AssocResps that are one spurious byte too long. */
-
-	return unknown ? ParseUnknown : ParseOK;
 }
 
 
-
-
 static int ecw2cw(int ecw)
 {
 	int cw = 1;
@@ -907,12 +883,7 @@ static void ieee80211_auth_challenge(struct net_device *dev,
 
 	printk(KERN_DEBUG "%s: replying to auth challenge\n", dev->name);
 	pos = mgmt->u.auth.variable;
-	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
-	    == ParseFailed) {
-		printk(KERN_DEBUG "%s: failed to parse Auth(challenge)\n",
-		       dev->name);
-		return;
-	}
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 	if (!elems.challenge) {
 		printk(KERN_DEBUG "%s: no challenge IE in shared key auth "
 		       "frame\n", dev->name);
@@ -1200,12 +1171,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	aid &= ~(BIT(15) | BIT(14));
 
 	pos = mgmt->u.assoc_resp.variable;
-	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
-	    == ParseFailed) {
-		printk(KERN_DEBUG "%s: failed to parse AssocResp\n",
-		       dev->name);
-		return;
-	}
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 
 	if (!elems.supp_rates) {
 		printk(KERN_DEBUG "%s: no SuppRates element in AssocResp\n",
@@ -1434,7 +1400,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	int channel, invalid = 0, clen;
+	int channel, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1478,9 +1444,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	}
 
-	if (ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
-				   &elems) == ParseFailed)
-		invalid = 1;
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
@@ -1699,9 +1663,7 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 	if (baselen > len)
 		return;
 
-	if (ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
-				   &elems) == ParseFailed)
-		return;
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (elems.erp_info && elems.erp_info_len >= 1)
 		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);
-- 
1.5.2.4

