Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbcAYNqn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:46:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: fix ibss scan parameters
Date: Mon, 25 Jan 2016 15:46:35 +0200
Message-Id: <1453729596-9847-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160125_144645_851945_44AC79D4)
In-Reply-To: <1453729596-9847-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1453729596-9847-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When joining IBSS a full scan should be initiated in order to search
for existing cell, unless the fixed_channel parameter was set.
A default channel to create the IBSS on if no cell was found is
provided as well.
However - a scan is initiated only on the default channel provided
regardless of whether ifibss->fixed_channel is set or not, with the
obvious result of the cell not joining existing IBSS cell that is
on another channel.

Fixes: 76bed0f43b27 ("mac80211: IBSS fix scan request")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ibss.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e5e8a31..9b98378 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -7,6 +7,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1483,14 +1484,21 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 
 		sdata_info(sdata, "Trigger new scan to find an IBSS to join\n");
 
-		num = ieee80211_ibss_setup_scan_channels(local->hw.wiphy,
-							 &ifibss->chandef,
-							 channels,
-							 ARRAY_SIZE(channels));
 		scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
-		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
-					    ifibss->ssid_len, channels, num,
-					    scan_width);
+
+		if (ifibss->fixed_channel) {
+			num = ieee80211_ibss_setup_scan_channels(local->hw.wiphy,
+								 &ifibss->chandef,
+								 channels,
+								 ARRAY_SIZE(channels));
+			ieee80211_request_ibss_scan(sdata, ifibss->ssid,
+						    ifibss->ssid_len, channels,
+						    num, scan_width);
+		} else {
+			ieee80211_request_ibss_scan(sdata, ifibss->ssid,
+						    ifibss->ssid_len, NULL,
+						    0, scan_width);
+		}
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
-- 
2.5.0

