Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXJOPh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:37:58 -0400
Subject: [PATCH] ieee80211: fix TKIP QoS bug
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 15 Oct 2007 16:50:54 +0200
Message-Id: <1192459854.3349.42.camel@johannes.berg> (sfid-20071015_163812_221834_58A17172)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 65b6a277 titled "ieee80211: Fix header->qos_ctl endian issue"
*introduced* an endianness bug. Partially revert it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Grumble. No comments on this for months so I'll just do this. Looks like
these people aren't able to follow endianness value swaps at all and the
code added by that commit is *obviously* wrong, assigning an le16 value
with only bits set in the low-order bits to a u8...

 net/ieee80211/ieee80211_crypt_tkip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/ieee80211/ieee80211_crypt_tkip.c	2007-10-15 16:44:11.058510862 +0200
+++ wireless-dev/net/ieee80211/ieee80211_crypt_tkip.c	2007-10-15 16:46:34.898510862 +0200
@@ -584,7 +584,7 @@ static void michael_mic_hdr(struct sk_bu
 	if (stype & IEEE80211_STYPE_QOS_DATA) {
 		const struct ieee80211_hdr_3addrqos *qoshdr =
 			(struct ieee80211_hdr_3addrqos *)skb->data;
-		hdr[12] = qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TID);
+		hdr[12] = le16_to_cpu(qoshdr->qos_ctl) & IEEE80211_QCTL_TID;
 	} else
 		hdr[12] = 0;		/* priority */
 


