Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47592 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1LQPFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 10:05:41 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 2/2] mac80211: stop data transmission while probing AP
Date: Sat, 17 Dec 2011 20:35:28 +0530
Message-ID: <1324134328-27503-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111217_160559_319724_A386531D)
In-Reply-To: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the station is out of coverage of AP and it tries to probe the AP
because of the beacon loss then there is not point in pushing the
data from the higher layer. So lets suspend the data transmission
till the probing succeeds.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 65f1262..d0b4a32 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1239,6 +1239,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	if (ifmgd->probe_send_count >= unicast_limit)
 		dst = NULL;
 
+	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL)
+		netif_tx_stop_all_queues(sdata->dev);
 	/*
 	 * When the hardware reports an accurate Tx ACK status, it's
 	 * better to send a nullfunc frame instead of a probe request,
@@ -1255,6 +1257,10 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 					 (u32) -1, true, false);
 	}
 
+	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
+		drv_flush(sdata->local, false);
+		netif_tx_wake_all_queues(sdata->dev);
+	}
 	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
-- 
1.7.8

