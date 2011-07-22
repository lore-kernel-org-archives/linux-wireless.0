Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab1GVFnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 31/31] ath6kl: change aggreation timeout message from an error to a debug message
Date: Fri, 22 Jul 2011 08:42:04 +0300
Message-ID: <1311313324-6766-33-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074352_927298_2BED0D5E)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I connect to my Linksys WT610N AP supporting 11n I see a lot of
aggreation timeout errors:

[  408.885053] ath6kl: aggr timeout (st 3109 end 3140)
[  463.872108] ath6kl: aggr timeout (st 3671 end 3702)
[  495.010060] ath6kl: aggr timeout (st 3983 end 4014)
[  503.604047] ath6kl: aggr timeout (st 4065 end 0)
[  518.963047] ath6kl: aggr timeout (st 141 end 172)
[  525.014066] ath6kl: aggr timeout (st 205 end 236)
[  573.957051] ath6kl: aggr timeout (st 701 end 732)
[  585.019067] ath6kl: aggr timeout (st 816 end 847)

But still the connection seems to work. To not clutter the logs change
the error message to a debug message. But add a fixme comment so that
this will be investigated.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 2e60588..66b3999 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -35,6 +35,7 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_SCATTER	= BIT(12),    /* hif scatter tracing */
 	ATH6KL_DBG_WLAN_CFG     = BIT(13),    /* cfg80211 i/f file tracing */
 	ATH6KL_DBG_RAW_BYTES    = BIT(14),    /* dump tx/rx and wmi frames */
+	ATH6KL_DBG_AGGR		= BIT(15),    /* aggregation */
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 615b46d..0cab1c1 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1250,8 +1250,13 @@ static void aggr_timeout(unsigned long arg)
 		if (!rxtid->aggr || !rxtid->timer_mon || rxtid->progress)
 			continue;
 
+		/*
+		 * FIXME: these timeouts happen quite fruently, something
+		 * line once within 60 seconds. Investigate why.
+		 */
 		stats->num_timeouts++;
-		ath6kl_err("aggr timeout (st %d end %d)\n",
+		ath6kl_dbg(ATH6KL_DBG_AGGR,
+			   "aggr timeout (st %d end %d)\n",
 			   rxtid->seq_next,
 			   ((rxtid->seq_next + rxtid->hold_q_sz-1) &
 			    ATH6KL_MAX_SEQ_NO));
-- 
1.7.1

