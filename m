Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbbCLGxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/7] nl80211: ignore HT/VHT capabilities without QoS/WMM
Date: Thu, 12 Mar 2015 08:53:27 +0200
Message-Id: <1426143210-25635-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075348_649395_8A3D53E8)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As HT/VHT depend heavily on QoS/WMM, it's not a good idea to
let userspace add clients that have HT/VHT but not QoS/WMM.
Since it does so in certain cases we've observed (client is
using HT IEs but not QoS/WMM) just ignore the HT/VHT info at
this point and don't pass it down to the drivers which might
unconditionally use it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b020853..593513d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4401,6 +4401,16 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
+	/* HT/VHT requires QoS, but if we don't have that just ignore HT/VHT
+	 * as userspace might just pass through the capabilities from the IEs
+	 * directly, rather than enforcing this restriction and returning an
+	 * error in this case.
+	 */
+	if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME))) {
+		params.ht_capa = NULL;
+		params.vht_capa = NULL;
+	}
+
 	/* When you run into this, adjust the code below for the new flag */
 	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
 
-- 
1.9.1

