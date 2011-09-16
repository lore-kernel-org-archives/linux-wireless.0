Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1IPLp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:45:26 -0400
Subject: [PATCH] cfg80211: validate IBSS BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marek Lindner <lindner_marek@yahoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 13:45:25 +0200
Message-ID: <1316173525.4130.13.camel@jlt3.sipsolutions.net> (sfid-20110916_134530_184559_012D4B22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The IBSS BSSID is never validated, so an
invalid one might end up being used. Fix
this by rejecting invalid configuration.

Reported-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c	2011-09-16 13:42:50.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-09-16 13:43:49.000000000 +0200
@@ -4522,8 +4522,12 @@ static int nl80211_join_ibss(struct sk_b
 
 	wiphy = &rdev->wiphy;
 
-	if (info->attrs[NL80211_ATTR_MAC])
+	if (info->attrs[NL80211_ATTR_MAC]) {
 		ibss.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+		if (!is_valid_ether_addr(ibss.bssid))
+			return -EINVAL;
+	}
 	ibss.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	ibss.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 


