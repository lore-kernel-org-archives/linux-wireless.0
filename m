Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20977 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbcHKJ4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 05:56:45 -0400
From: "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Subject: RE: [PATCH] cfg80211: validate beacon interval for MESH/IBSS
Date: Thu, 11 Aug 2016 09:56:28 +0000
Message-ID: <99a970ef2b8f4d41b757c4e6b65648ac@aphydexm01b.ap.qualcomm.com> (sfid-20160811_115703_347157_AD268FD0)
References: <1470908642-13535-1-git-send-email-pkushwah@qti.qualcomm.com>
In-Reply-To: <1470908642-13535-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes , 
While addressing this change, we could notice that the minimum boundary for beacon interval for the case of IBSS is 1 but for Mesh it is 10. Also this check is not done for AP/P2P GO . 
Any reason why there is a discrepancy among them ? These configurations should be aligned , I guess. 
Shouldn't the minimum value be 10 ? If yes , the boundary check should be moved to cfg80211_validate_beacon_int ? 

Thanks,
Purushottam


-----Original Message-----
From: Kushwaha, Purushottam 
Sent: Thursday, August 11, 2016 3:14 PM
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org; Malinen, Jouni <jouni@qca.qualcomm.com>; Undekari, Sunil Dutt <usdutt@qti.qualcomm.com>; Kalikot Veetil, Mahesh Kumar <mkalikot@qca.qualcomm.com>; Hullur Subramanyam, Amarnath <amarnath@qca.qualcomm.com>; Kumar, Deepak (QCA) <djindal@qti.qualcomm.com>; Kushwaha, Purushottam <pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: validate beacon interval for MESH/IBSS

Beacon interval validation was missing for MESH / IBSS join.
This commit addresses the same.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 net/wireless/nl80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index f02653a..ddb1469 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7780,6 +7780,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	err = cfg80211_validate_beacon_int(rdev, ibss.beacon_interval);
+	if (err)
+		return err;
+
 	if (!rdev->ops->join_ibss)
 		return -EOPNOTSUPP;
 
@@ -9255,6 +9259,10 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		if (setup.beacon_interval < 10 ||
 		    setup.beacon_interval > 10000)
 			return -EINVAL;
+
+		err = cfg80211_validate_beacon_int(rdev, setup.beacon_interval);
+		if (err)
+			return err;
 	}
 
 	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
--
1.9.1

