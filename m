Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54999 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1HOOQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 10:16:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: stop tx before doing hw config and rate update
Date: Mon, 15 Aug 2011 19:47:19 +0530
Message-ID: <1313417839-3617-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110815_161701_297594_699A044D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assumption is that during the hw config, transmission was
already stopped by mac80211. But during channel type change,
the mac80211 continue to transmit frames. The driver like ath9k
does chip reset while doing channel set. This could leads to
buffer overflow at driver side. And also after setting the channel
at driver side and before calling rate updation, the frames are
continued to xmit with older rates. This patch ensures that
the frames are always xmitted with updated rates and avoid buffer
overflow.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea74190..5500f40 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -669,6 +669,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d6470c7..c283ed2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+	drv_flush(local, false);
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -245,6 +248,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	}
 
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-- 
1.7.6

