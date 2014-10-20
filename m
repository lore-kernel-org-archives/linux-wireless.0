Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaJTNBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:01:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't flush when probing the AP
Date: Mon, 20 Oct 2014 15:57:18 +0300
Message-Id: <1413809838-9170-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141020_150142_680104_301953BD)
In-Reply-To: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the callers of ieee80211_mgd_probe_ap_send return right
after they call the flush() callback. This means that calling
flush() is uneeded since its meaning is to wait until the
queues of the device are empty.

Devices that know how to report status on Tx will do so using
the regular path (ieee80211_tx_status) and this status will
trigger the continuation of the flow of the probe
(ieee80211_sta_tx_notify).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9ddd721..abba89d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1956,8 +1956,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(sdata, ifmgd->probe_timeout);
-	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		ieee80211_flush_queues(sdata->local, sdata);
 }
 
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
-- 
1.9.1

