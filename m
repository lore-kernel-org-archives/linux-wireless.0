Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3975 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbXJZVHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: reorder association debug output
Date: Fri, 26 Oct 2007 17:04:30 -0400
Message-Id: <1193432681145-git-send-email-linville@tuxdriver.com> (sfid-20071026_220726_464135_95A03928)
In-Reply-To: <11934326813508-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

There's no reason to warn about an invalid AID field when the
association was denied.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 0d99b68..ae74c79 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1174,15 +1174,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
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
@@ -1192,6 +1188,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
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
-- 
1.5.2.4

