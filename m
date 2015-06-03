Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbFCHoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:44:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: ignore invalid scan RSSI values
Date: Wed,  3 Jun 2015 10:44:17 +0300
Message-Id: <1433317457-6311-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_094435_065853_5E20DE2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Channels in 2.4GHz band overlap, this means that if we
send a probe request on channel 1 and then move to channel
2, we will hear the probe response on channel 2. In this
case, the RSSI will be lower than if we had heard it on
the channel on which it was sent (1 in this case).

The scan result ignores those invalid values and the
station last signal should not be updated as well.

In case the scan determines the signal to be invalid turn on
the flag so the station last signal will not be updated with
the value and thus user space probing for NL80211_STA_INFO_SIGNAL
and NL80211_STA_INFO_SIGNAL_AVG will not get this invalid RSSI
value.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/scan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7bb6a93..f995995 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -6,7 +6,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
- * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2013-2015  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -69,6 +69,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	int clen, srlen;
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal = 0;
+	bool signal_valid;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		signal = rx_status->signal * 100;
@@ -86,6 +87,11 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 					       GFP_ATOMIC);
 	if (!cbss)
 		return NULL;
+	/* In case the signal is invalid update the status */
+	signal_valid = abs(channel->center_freq - cbss->channel->center_freq)
+		<= local->hw.wiphy->max_adj_channel_rssi_comp;
+	if (!signal_valid)
+		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	bss = (void *)cbss->priv;
 
-- 
2.1.4

