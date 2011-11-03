Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1KCNuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 09:50:17 -0400
Subject: [PATCH 3.2] cfg80211: allow setting TXQ parameters only in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 14:50:13 +0100
Message-ID: <1320328213.3950.46.camel@jlt3.sipsolutions.net> (sfid-20111103_145021_205885_76C6F2E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In other modes the parameters should not be set.
Right now, mac80211 will set them, even if the
user asked for setting them on VLANs which the
driver doesn't know about, causing all kinds of
trouble.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/wireless/nl80211.c	2011-11-03 14:41:42.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-03 14:47:23.000000000 +0100
@@ -1252,6 +1252,12 @@ static int nl80211_set_wiphy(struct sk_b
 			goto bad_res;
 		}
 
+		if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {


