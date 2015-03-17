Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbbCQR6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:58:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH] mac80211: stop scan before connection
Date: Tue, 17 Mar 2015 19:58:38 +0200
Message-Id: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150317_185845_859627_84EC6A62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Stop scan before authentication or association to make sure
that nothing interferes with connection flow.

Currently mac80211 defers RX auth and assoc packets (among other ones)
until after the scan is complete, so auth during scan is likely to fail
if scan took too much time.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d77150d..3f3ac3e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4458,6 +4458,10 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	} else
 		WARN_ON_ONCE(!ether_addr_equal(ifmgd->bssid, cbss->bssid));
 
+	/* Cancel scan to ensure that nothing interferes with connection */
+	if (local->scanning)
+		ieee80211_scan_cancel(local);
+
 	return 0;
 }
 
-- 
1.9.1

