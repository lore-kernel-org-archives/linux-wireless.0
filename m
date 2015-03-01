Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbbCAHKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/16] mac80211: fix another suspend vs. association race
Date: Sun,  1 Mar 2015 09:10:03 +0200
Message-Id: <1425193815-17785-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081044_054372_269FC090)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since cfg80211 disconnects, but has no insight into the association
process, it can happen that it disconnects while association is in
progress. We then try to abort association in mac80211, but this is
only later so the association can complete between the two.

This results in removing an interface from the driver while bound
to the channel context, obviously causing confusion and issues.

Solve this by also checking if we're associated during quiesce and
if so deauthenticating. The frame will no longer go out to the AP
which is a bit unfortunate, but it'll resolve the crash (and before
we would have suspended without telling the AP as well.)

I'm working on a better, but more complex solution as well, which
should avoid that problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf3ae93..c5f3bd6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3985,6 +3985,34 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 				      IEEE80211_DEAUTH_FRAME_LEN);
 	}
 
+	/* This is a bit of a hack - we should find a better and more generic
+	 * solution to this. Normally when suspending, cfg80211 will in fact
+	 * deauthenticate. However, it doesn't (and cannot) stop an ongoing
+	 * auth (not so important) or assoc (this is the problem) process.
+	 *
+	 * As a consequence, it can happen that we are in the process of both
+	 * associating and suspending, and receive an association response
+	 * after cfg80211 has checked if it needs to disconnect, but before
+	 * we actually set the flag to drop incoming frames. This will then
+	 * cause the workqueue flush to process the association response in
+	 * the suspend, resulting in a successful association just before it
+	 * tries to remove the interface from the driver, which now though
+	 * has a channel context assigned ... this results in issues.
+	 *
+	 * To work around this (for now) simply deauth here again if we're
+	 * now connected.
+	 */
+	if (ifmgd->associated && !sdata->local->wowlan) {
+		u8 bssid[ETH_ALEN];
+		struct cfg80211_deauth_request req = {
+			.reason_code = WLAN_REASON_DEAUTH_LEAVING,
+			.bssid = bssid,
+		};
+
+		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
+		ieee80211_mgd_deauth(sdata, &req);
+	}
+
 	sdata_unlock(sdata);
 }
 
-- 
1.9.1

