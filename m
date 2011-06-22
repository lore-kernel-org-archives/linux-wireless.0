Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:43:53 -0400
Subject: [PATCH] mac80211: restrict advertised HW scan rates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 16:43:48 +0200
Message-ID: <1308753828.29571.14.camel@jlt3.sipsolutions.net> (sfid-20110622_164355_933314_834C2F96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Advertise only user-requested bitrates in a HW scan.
Note that the hw_scan API doesn't currently have a
way of asking for a specific probe request bitrate,
so we might end up using a bitrate that we don't
advertise as supported. I'll fix that later.

Also add a hexdump printk to hwsim to verify this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 ++
 net/mac80211/scan.c                   |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/mac80211/scan.c	2011-06-22 16:41:21.000000000 +0200
+++ b/net/mac80211/scan.c	2011-06-22 16:41:21.000000000 +0200
@@ -228,6 +228,7 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 {
 	struct cfg80211_scan_request *req = local->scan_req;
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
@@ -251,8 +252,8 @@ static bool ieee80211_prep_hw_scan(struc
 	local->hw_scan_req->n_channels = n_chans;
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
-					 req->ie, req->ie_len, band, (u32) -1,
-					 0);
+					 req->ie, req->ie_len, band,
+					 sdata->rc_rateidx_mask[band], 0);
 	local->hw_scan_req->ie_len = ielen;
 
 	return true;
--- a/drivers/net/wireless/mac80211_hwsim.c	2011-06-22 16:41:21.000000000 +0200
+++ b/drivers/net/wireless/mac80211_hwsim.c	2011-06-22 16:41:35.000000000 +0200
@@ -1185,6 +1185,8 @@ static int mac80211_hwsim_hw_scan(struct
 	for (i = 0; i < req->n_channels; i++)
 		printk(KERN_DEBUG "hwsim hw_scan freq %d\n",
 			req->channels[i]->center_freq);
+	print_hex_dump(KERN_DEBUG, "scan IEs: ", DUMP_PREFIX_OFFSET,
+			16, 1, req->ie, req->ie_len, 1);
 
 	ieee80211_queue_delayed_work(hw, &hsd->w, 2 * HZ);
 


