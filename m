Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42694 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751263AbdHFIia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Aug 2017 04:38:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Roee Zamir <roee.zamir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  6 Aug 2017 11:38:23 +0300
Message-Id: <20170806083823.21825-2-luca@coelho.fi> (sfid-20170806_103843_865099_42341C4B)
In-Reply-To: <20170806083823.21825-1-luca@coelho.fi>
References: <20170806083823.21825-1-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211: oce: enable receiving of bcast probe resp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roee Zamir <roee.zamir@intel.com>

One of OCE's optimizations is acception of broadcast probe responses.
Accept broadcast probe responses but don't set
NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP. Because a device's firmware
may filter out the broadcast probe resp - drivers should set this flag.

Signed-off-by: Roee Zamir <roee.zamir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/scan.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 47d2ed570470..fc7c0cee73be 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -7,7 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
- * Copyright 2016  Intel Deutschland GmbH
+ * Copyright 2016-2017  Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -183,6 +183,19 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	return bss;
 }
 
+static bool ieee80211_scan_accept_presp(struct ieee80211_sub_if_data *sdata,
+					u32 scan_flags, const u8 *da)
+{
+	if (!sdata)
+		return false;
+	/* accept broadcast for OCE */
+	if (is_broadcast_ether_addr(da))
+		return true;
+	if (scan_flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
+		return true;
+	return ether_addr_equal(da, sdata->vif.addr);
+}
+
 void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
@@ -208,19 +221,24 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		struct cfg80211_scan_request *scan_req;
 		struct cfg80211_sched_scan_request *sched_scan_req;
+		u32 scan_req_flags = 0, sched_scan_req_flags = 0;
 
 		scan_req = rcu_dereference(local->scan_req);
 		sched_scan_req = rcu_dereference(local->sched_scan_req);
 
-		/* ignore ProbeResp to foreign address unless scanning
-		 * with randomised address
+		if (scan_req)
+			scan_req_flags = scan_req->flags;
+
+		if (sched_scan_req)
+			sched_scan_req_flags = sched_scan_req->flags;
+
+		/* ignore ProbeResp to foreign address or non-bcast (OCE)
+		 * unless scanning with randomised address
 		 */
-		if (!(sdata1 &&
-		      (ether_addr_equal(mgmt->da, sdata1->vif.addr) ||
-		       scan_req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)) &&
-		    !(sdata2 &&
-		      (ether_addr_equal(mgmt->da, sdata2->vif.addr) ||
-		       sched_scan_req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)))
+		if (!ieee80211_scan_accept_presp(sdata1, scan_req_flags,
+						 mgmt->da) &&
+		    !ieee80211_scan_accept_presp(sdata2, sched_scan_req_flags,
+						 mgmt->da))
 			return;
 
 		elements = mgmt->u.probe_resp.variable;
-- 
2.13.2
