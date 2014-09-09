Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48277 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbaIIOQg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 10:16:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Subject: [PATCH] mac80211: set network header in TDLS frames
Date: Tue,  9 Sep 2014 17:11:02 +0300
Message-Id: <1410271862-10208-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140909_161641_246676_408CFB62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Correctly mark the network header location in mac80211-generated TDLS
frames. These may be used by lower-level drivers.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index bcf51e4..4ea25de 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -412,6 +412,9 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 	tf->ether_type = cpu_to_be16(ETH_P_TDLS);
 	tf->payload_type = WLAN_TDLS_SNAP_RFTYPE;
 
+	/* network header is after the ethernet header */
+	skb_set_network_header(skb, ETH_HLEN);
+
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
 		tf->category = WLAN_CATEGORY_TDLS;
-- 
1.9.1

