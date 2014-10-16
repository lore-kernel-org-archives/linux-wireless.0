Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaJPUaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 16:30:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] mac80211: don't flush when probing the AP
Date: Thu, 16 Oct 2014 23:25:57 +0300
Message-Id: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141016_223033_220808_FE3E4779)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the callers of ieee80211_mgd_probe_ap_send return right
after they call the flush() callback. This means that calling
flush() is uneeded since its meaning is to wait until the
queues of the device are empty. It is pointless to wait if
there is nothing that must ensure that the frame has left
the Tx queue.
ieee80211_mgd_probe_ap_send is called at the very end of
a worker - so flush() is not needed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0a39361..75df184 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2219,8 +2219,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(sdata, ifmgd->probe_timeout);
-	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		ieee80211_flush_queues(sdata->local, sdata);
 }
 
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
-- 
1.9.1

