Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32938 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950AbcGEMX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:13 +0300
Message-Id: <1467721394-8195-7-git-send-email-luca@coelho.fi> (sfid-20160705_142333_382193_96E13139)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 6/7] mac80211: report failure to start (partial) scan as scan abort
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rather than reporting the scan as having completed, report it as
being aborted.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8d4a9cd..070b40f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -362,10 +362,11 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		if (rc == 0)
 			return;
 
-		/* HW scan failed and is going to be reported as done, so clear
-		 * old scan info.
+		/* HW scan failed and is going to be reported as aborted,
+		 * so clear old scan info.
 		 */
 		memset(&local->scan_info, 0, sizeof(local->scan_info));
+		aborted = true;
 	}
 
 	kfree(local->hw_scan_req);
-- 
2.8.1

