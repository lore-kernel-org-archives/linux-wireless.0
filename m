Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbbDTTyU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:54:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: While associated, force off channel transmission for action frames
Date: Mon, 20 Apr 2015 22:54:14 +0300
Message-Id: <1429559654-23126-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215425_182994_BF1BCEB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently while associated to an AP and sending an action frame to a
different AP on the same channel, the action frame will be sent
like a regular tx frame without going off channel.

When power save is enabled this can cause problems, since the device can
go into power save and miss the response to the action frame that is sent
by the other AP.

By forcing the frame to be transmitted off channel we avoid this issue.

Force the transmitting of the action frame to use off channel in
case of association
- If HW off channel is enabled
- The user did not forbid transmitting frames off channel
- The frame is not designated to the AP that we are associated with

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 265e427..e38da9f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3336,8 +3336,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		if (!sdata->u.mgd.associated)
+		sdata_lock(sdata);
+		if (!sdata->u.mgd.associated ||
+		    (params->offchan && params->wait &&
+		     local->ops->remain_on_channel &&
+		     memcmp(sdata->u.mgd.associated->bssid,
+			    mgmt->bssid, ETH_ALEN)))
 			need_offchan = true;
+		sdata_unlock(sdata);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		need_offchan = true;
-- 
2.1.0

