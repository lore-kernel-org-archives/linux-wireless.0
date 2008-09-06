Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYIFWO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:14:26 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC PATCH 2/3] mac80211: disassociate when moving to new BSS
Date: Sun,  7 Sep 2008 01:14:18 +0300
Message-Id: <1220739259-16918-3-git-send-email-tomas.winkler@intel.com> (sfid-20080907_001429_993465_AD472C8D)
In-Reply-To: <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans current association when leaving to new BSS. this is
needed as old configuration and data were still stored in station table
and in low level driver, causing problems (e.g. 11n mlme) in new BSS

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ba255e2..aa5367e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3414,9 +3414,14 @@ void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
-				IEEE80211_STA_AUTO_BSSID_SEL)) &&
+			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
 	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
-				IEEE80211_STA_AUTO_SSID_SEL))) {
+			     IEEE80211_STA_AUTO_SSID_SEL))) {
+
+		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
+			ieee80211_set_disassoc(sdata, ifsta, 1, 1,
+					       WLAN_REASON_DEAUTH_LEAVING);
+
 		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		queue_work(local->hw.workqueue, &ifsta->work);
 	}
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

