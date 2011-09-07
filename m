Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1IGMYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:41 -0400
Subject: [PATCH] cfg80211: verify format of uAPSD information
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 11:50:48 +0200
Message-ID: <1315389048.4002.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The format is intended to be like the subfields
in the QoS Info field, verify that is the case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/wireless/nl80211.c	2011-09-07 11:37:54.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-09-07 11:41:39.000000000 +0200
@@ -2611,10 +2611,15 @@ static int nl80211_new_station(struct sk
 		if (tb[NL80211_STA_WME_UAPSD_QUEUES])
 			params.uapsd_queues =
 			     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
+		if (params.uapsd_queues & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+			return -EINVAL;
 
 		if (tb[NL80211_STA_WME_MAX_SP])
 			params.max_sp =
 			     nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
+
+		if (params.max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+			return -EINVAL;
 	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&


