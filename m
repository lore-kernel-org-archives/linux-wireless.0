Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3LCNDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 08:03:21 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Subject: [PATCH] mac80211: remove duplicate code
Date: Tue,  3 Dec 2013 15:02:15 +0200
Message-Id: <1386075735-28589-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131203_140335_209147_21F091DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The same code appears just a few lines below.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/scan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5ad66a8..6a94d48 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -786,14 +786,6 @@ void ieee80211_scan_work(struct work_struct *work)
 	}
 
 	/*
-	 * Avoid re-scheduling when the sdata is going away.
-	 */
-	if (!ieee80211_sdata_running(sdata)) {
-		aborted = true;
-		goto out_complete;
-	}
-
-	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
 	 */
-- 
1.8.3.2

