Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbJYJAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/10] mac80211: Fix local deauth while associating
Date: Sun, 25 Oct 2015 10:59:38 +0200
Message-Id: <1445763582-11421-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100012_121230_5242367C)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Local request to deauthenticate wasn't handled while associating, thus
the association could continue even when the user space required to
disconnect.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0d0ce5c..67f0387 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4936,6 +4936,25 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
+	if (ifmgd->assoc_data &&
+	    ether_addr_equal(ifmgd->assoc_data->bss->bssid, req->bssid)) {
+		sdata_info(sdata,
+			   "aborting association with %pM by local choice (Reason: %u=%s)\n",
+			   req->bssid, req->reason_code,
+			   ieee80211_get_reason_code_string(req->reason_code));
+
+		drv_mgd_prepare_tx(sdata->local, sdata);
+		ieee80211_send_deauth_disassoc(sdata, req->bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       req->reason_code, tx,
+					       frame_buf);
+		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_report_disconnect(sdata, frame_buf,
+					    sizeof(frame_buf), true,
+					    req->reason_code);
+		return 0;
+	}
+
 	if (ifmgd->associated &&
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
 		sdata_info(sdata,
-- 
2.1.4

