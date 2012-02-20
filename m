Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2BTNUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 08:20:03 -0500
Subject: [PATCH] mac80211: fix associated vs. idle race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 14:19:58 +0100
Message-ID: <1329743998.3458.19.camel@jlt3.sipsolutions.net> (sfid-20120220_142008_621515_90E66724)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Eliad reports that if a scan finishes in the
middle of processing associated (however it
happens), the interface can go idle. This is
because we set assoc_data to NULL before we
set associated. Change the order so any idle
check will find either one of them.

Doing this requires duplicating the TX sync
processing, but I already have a patch to
delete that completely and will submit that
as soon as my driver changes to no longer
require it are submitted.

Reported-by: Eliad Peller <eliad@wizery.com>
Tested-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/net/mac80211/mlme.c	2012-02-20 14:17:48.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-02-20 14:17:52.000000000 +0100
@@ -2238,14 +2238,28 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	} else {
 		printk(KERN_DEBUG "%s: associated\n", sdata->name);
 
-		ieee80211_destroy_assoc_data(sdata, true);
+		/* tell driver about sync done first */
+		if (assoc_data->synced) {
+			drv_finish_tx_sync(sdata->local, sdata,
+					   assoc_data->bss->bssid,
+					   IEEE80211_TX_SYNC_ASSOC);
+			assoc_data->synced = false;
+		}
 
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
+			ieee80211_destroy_assoc_data(sdata, true);
 			sta_info_destroy_addr(sdata, mgmt->bssid);
 			cfg80211_put_bss(*bss);
 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
 		}
+
+		/*
+		 * destroy assoc_data afterwards, as otherwise an idle
+		 * recalc after assoc_data is NULL but before associated
+		 * is set can cause the interface to go idle
+		 */
+		ieee80211_destroy_assoc_data(sdata, true);
 	}
 
 	return RX_MGMT_CFG80211_RX_ASSOC;


