Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63661 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1H2Ld0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 07:33:26 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC v2] mac80211: stop tx before doing hw config and rate update
Date: Mon, 29 Aug 2011 17:03:55 +0530
Message-ID: <1314617635-27936-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110829_133330_022892_AF43ED6F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assumption is that during the hw config, transmission was
already stopped by mac80211. But during channel type change,
the mac80211 continue to transmit frames. The driver like ath9k
does chip reset while doing channel set. This could leads to
buffer overflow at driver side. And also after configuring the channel
and before doing rate updation, the frames are continued to xmit
with older rates. This patch ensures that the frames are always
xmitted with updated rates and avoid buffer overflow.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: Removed new stop queue reason code by netif
 net/mac80211/mlme.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 60a6f27..a1deb33 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	netif_tx_stop_all_queues(sdata->dev);
+
+	drv_flush(local, false);
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -245,6 +248,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	}
 
+	netif_tx_wake_all_queues(sdata->dev);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-- 
1.7.6.1

