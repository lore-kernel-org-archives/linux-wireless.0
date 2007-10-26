Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3968 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbXJZVHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ieee80211: fix TKIP QoS bug
Date: Fri, 26 Oct 2007 17:04:29 -0400
Message-Id: <11934326813508-git-send-email-linville@tuxdriver.com> (sfid-20071026_220718_604511_4B1A4AB0)
In-Reply-To: <11934326811535-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The commit 65b6a277 titled "ieee80211: Fix header->qos_ctl endian issue"
*introduced* an endianness bug. Partially revert it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/ieee80211/ieee80211_crypt_tkip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 5a48d8e..7f11dd9 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -584,7 +584,7 @@ static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
 	if (stype & IEEE80211_STYPE_QOS_DATA) {
 		const struct ieee80211_hdr_3addrqos *qoshdr =
 			(struct ieee80211_hdr_3addrqos *)skb->data;
-		hdr[12] = qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TID);
+		hdr[12] = le16_to_cpu(qoshdr->qos_ctl) & IEEE80211_QCTL_TID;
 	} else
 		hdr[12] = 0;		/* priority */
 
-- 
1.5.2.4

