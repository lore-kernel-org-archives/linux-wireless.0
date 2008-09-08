Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYIHNb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 09:31:29 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
Subject: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
Date: Mon,  8 Sep 2008 16:31:26 +0300
Message-Id: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com> (sfid-20080908_153133_681427_F36FAEAB)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch handle scanning on IBSS mode like on STA mode.
When queuing the scan work we don't refer to the return value of
ieee80211_sta_start_scan so if we are in the last scan period, we will
return 0 to ieee80211_ioctl_siwscan and not -EAGAIN, and then iwlist will
call ieee80211_ioctl_giwscan to get the scan results and will not fail.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2564553..72d5fe2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4090,7 +4090,8 @@ int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_local *local = sdata->local;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

