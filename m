Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56142 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933542AbcK2SIA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 13:08:00 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Return avg sig, rx, tx values in ethtool stats.
Date: Tue, 29 Nov 2016 10:07:52 -0800
Message-Id: <1480442872-7358-1-git-send-email-greearb@candelatech.com> (sfid-20161129_190824_045626_457405E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

For non-station devices.  This gives at least some useful
summary in some cases (especially when we know AP has only one
station attached, for instance).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against 4.7.10+, applied to 4.4 and 4.9 for me as well.

 net/mac80211/ethtool.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 4e937c1..dc6f76f 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -12,6 +12,25 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "driver-ops.h"
+#include <asm/div64.h>
+
+static inline __s64 mac_div(__s64 n, __u32 base)
+{
+	if (n < 0) {
+		__u64 tmp = -n;
+		do_div(tmp, base);
+		/* printk("pktgen: pg_div, n: %llu  base: %d  rv: %llu\n",
+		   n, base, tmp); */
+		return -tmp;
+	}
+	else {
+		__u64 tmp = n;
+		do_div(tmp, base);
+		/* printk("pktgen: pg_div, n: %llu  base: %d  rv: %llu\n",
+		   n, base, tmp); */
+		return tmp;
+	}
+}
 
 static int ieee80211_set_ringparam(struct net_device *dev,
 				   struct ethtool_ringparam *rp)
@@ -128,6 +147,12 @@ static void ieee80211_get_stats(struct net_device *dev,
 			data[i] = (u8)sinfo.signal_avg;
 		i++;
 	} else {
+		int amt_tx = 0;
+		int amt_rx = 0;
+		int amt_sig = 0;
+		s64 tx_accum = 0;
+		s64 rx_accum = 0;
+		s64 sig_accum = 0;
 		list_for_each_entry(sta, &local->sta_list, list) {
 			/* Make sure this station belongs to the proper dev */
 			if (sta->sdata->dev != dev)
@@ -137,6 +162,37 @@ static void ieee80211_get_stats(struct net_device *dev,
 			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
+
+			i++; /* skip sta state */
+
+			if (sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE)) {
+				tx_accum += 100000 *
+					cfg80211_calculate_bitrate(&sinfo.txrate);
+				amt_tx++;
+				data[i] = mac_div(tx_accum, amt_tx);
+			}
+			i++;
+
+			if (sinfo.filled & BIT(NL80211_STA_INFO_RX_BITRATE)) {
+				rx_accum += 100000 *
+					cfg80211_calculate_bitrate(&sinfo.rxrate);
+				amt_rx++;
+				data[i] = mac_div(rx_accum, amt_rx);
+			}
+			i++;
+
+			if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL_AVG)) {
+				sig_accum += sinfo.signal_avg;
+				amt_sig++;
+				data[i] = (mac_div(sig_accum, amt_sig) & 0xFF);
+			}
+			i++;
+
+			/*pr_err("sta: %p (%s) sig_accum: %ld  amt-sig: %d filled: 0x%x:%08x rpt-sig-avg: %d  i: %d  div: %d sinfo.signal_avg: %d\n",
+			       sta, sta->sdata->name, (long)(sig_accum), amt_sig, (u32)(sinfo.filled >> 32),
+			       (u32)(sinfo.filled), (u32)(data[i-1]), i-1, (u32)(mac_div(sig_accum, amt_sig)),
+			       sinfo.signal_avg);*/
+
 		}
 	}
 
-- 
2.4.11
