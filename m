Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44147 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbbCLTfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 15:35:20 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@suse.org, Ben <ben.rosenfeld@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] cfg80211: Process all pending regulatory requests/hints
Date: Thu, 12 Mar 2015 09:37:34 -0400
Message-Id: <1426167454-7070-1-git-send-email-ilan.peer@intel.com> (sfid-20150312_203539_613472_27D4FE32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben <ben.rosenfeld@intel.com>

It is possible that there are several regulatory requests
pending, but the processing of the last one does not call
CRDA, and thus the other requests are not handled.

Fix this by rescheduling the work until all requests have been
processed.

Signed-off-by: Ben Rosenfeld <ben.rosenfeld@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/reg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d867103..8c6cf52 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2159,6 +2159,13 @@ static void reg_process_pending_hints(void)
 	}
 
 	reg_process_hint(reg_request);
+
+	lr = get_last_request();
+
+	spin_lock(&reg_requests_lock);
+	if (!list_empty(&reg_requests_list) && lr && lr->processed)
+		schedule_work(&reg_work);
+	spin_unlock(&reg_requests_lock);
 }
 
 /* Processes beacon hints -- this has nothing to do with country IEs */
-- 
1.8.3.2

