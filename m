Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXJJKC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 06:02:56 -0400
Subject: [PATCH] mac80211: reorder association debug output
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Marcus Better <marcus@better.se>
In-Reply-To: <fei4sd$mm0$1@sea.gmane.org> (sfid-20071010_100953_396055_10BC12ED)
References: <fdqhn4$qab$1@sea.gmane.org>   <fei4sd$mm0$1@sea.gmane.org>
	 (sfid-20071010_100953_396055_10BC12ED)
Content-Type: text/plain
Date: Wed, 10 Oct 2007 12:03:41 +0200
Message-Id: <1192010621.12541.18.camel@johannes.berg> (sfid-20071010_110259_235119_6340094F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason to warn about an invalid AID field when the
association was denied.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Odd messages in your log btw:

> Oct 10 10:26:27 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
> Oct 10 10:26:27 better kernel: wlan0: invalid aid value 0; bits 15:14 not set
> Oct 10 10:26:27 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10 (capab=0x431 status=19 aid=0)
> Oct 10 10:26:27 better kernel: wlan0: AP denied association (code=19)
> Oct 10 10:26:27 better kernel: wlan0: association with AP 00:14:6c:a7:60:10 timed out

We never use the AID value in this case...

 net/mac80211/ieee80211_sta.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-10-10 11:57:36.290680979 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-10-10 12:00:31.490680979 +0200
@@ -1195,15 +1195,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
-	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
-		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
-		       "set\n", dev->name, aid);
-	aid &= ~(BIT(15) | BIT(14));
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from " MAC_FMT " (capab=0x%x "
 	       "status=%d aid=%d)\n",
 	       dev->name, reassoc ? "Rea" : "A", MAC_ARG(mgmt->sa),
-	       capab_info, status_code, aid);
+	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
@@ -1215,6 +1211,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 		return;
 	}
 
+	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
+		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
+		       "set\n", dev->name, aid);
+	aid &= ~(BIT(15) | BIT(14));
+
 	pos = mgmt->u.assoc_resp.variable;
 	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
 	    == ParseFailed) {


