Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:59861 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbYA2TcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 14:32:09 -0500
Date: Tue, 29 Jan 2008 20:29:16 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] rc80211-pid: fix rate adjustment
Message-ID: <20080129202916.750ae353@morte> (sfid-20080129_193214_590902_E184AD81)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge rate_control_pid_shift_adjust() to rate_control_pid_adjust_rate()
in order to make the learning algorithm aware of constraints on rates. Also
add some comments and rename variables.

This fixes a bug which prevented 802.11b/g non-AP STAs from working with
802.11b only AP STAs.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John, this is for 2.6.25.

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
- * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
+ * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -64,71 +64,66 @@
  */
 
 
-/* Shift the adjustment so that we won't switch to a lower rate if it exhibited
- * a worse failed frames behaviour and we'll choose the highest rate whose
- * failed frames behaviour is not worse than the one of the original rate
- * target. While at it, check that the adjustment is within the ranges. Then,
- * provide the new rate index. */
-static int rate_control_pid_shift_adjust(struct rc_pid_rateinfo *r,
-					 int adj, int cur, int l)
-{
-	int i, j, k, tmp;
-
-	j = r[cur].rev_index;
-	i = j + adj;
-
-	if (i < 0)
-		return r[0].index;
-	if (i >= l - 1)
-		return r[l - 1].index;
-
-	tmp = i;
-
-	if (adj < 0) {
-		for (k = j; k >= i; k--)
-			if (r[k].diff <= r[j].diff)
-				tmp = k;
-	} else {
-		for (k = i + 1; k + i < l; k++)
-			if (r[k].diff <= r[i].diff)
-				tmp = k;
-	}
-
-	return r[tmp].index;
-}
-
+/* Adjust the rate while ensuring that we won't switch to a lower rate if it
+ * exhibited a worse failed frames behaviour and we'll choose the highest rate
+ * whose failed frames behaviour is not worse than the one of the original rate
+ * target. While at it, check that the new rate is valid. */
 static void rate_control_pid_adjust_rate(struct ieee80211_local *local,
 					 struct sta_info *sta, int adj,
 					 struct rc_pid_rateinfo *rinfo)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
-	int newidx;
-	int maxrate;
-	int back = (adj > 0) ? 1 : -1;
+	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
+	int cur = sta->txrate_idx;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
+	band = sband->band;
+	n_bitrates = sband->n_bitrates;
 
-	newidx = rate_control_pid_shift_adjust(rinfo, adj, sta->txrate_idx,
-					       sband->n_bitrates);
+	/* Map passed arguments to sorted values. */
+	cur_sorted = rinfo[cur].rev_index;
+	new_sorted = cur_sorted + adj;
+
+	/* Check limits. */
+	if (new_sorted < 0)
+		new_sorted = rinfo[0].rev_index;
+	else if (new_sorted >= n_bitrates)
+		new_sorted = rinfo[n_bitrates - 1].rev_index;
 
-	while (newidx != sta->txrate_idx) {
-		if (rate_supported(sta, sband->band, newidx) &&
-		    (maxrate < 0 || newidx <= maxrate)) {
-			sta->txrate_idx = newidx;
-			break;
-		}
+	tmp = new_sorted;
 
-		newidx += back;
+	if (adj < 0) {
+		/* Ensure that the rate decrease isn't disadvantageous. */
+		for (probe = cur_sorted; probe >= new_sorted; probe--)
+			if (rinfo[probe].diff <= rinfo[cur_sorted].diff &&
+			    rate_supported(sta, band, rinfo[probe].index))
+				tmp = probe;
+	} else {
+		/* Look for rate increase with zero (or below) cost. */
+		for (probe = new_sorted + 1; probe < n_bitrates; probe++)
+			if (rinfo[probe].diff <= rinfo[new_sorted].diff &&
+			    rate_supported(sta, band, rinfo[probe].index))
+				tmp = probe;
 	}
 
+	/* Fit the rate found to the nearest supported rate. */
+	do {
+		if (rate_supported(sta, band, rinfo[tmp].index)) {
+			sta->txrate_idx = rinfo[tmp].index;
+			break;
+		}
+		if (adj < 0)
+			tmp--;
+		else
+			tmp++;
+	} while (tmp < n_bitrates && tmp >= 0);
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(
 		&((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
-		newidx, sband->bitrates[newidx].bitrate);
+		sta->txrate_idx, sband->bitrates[sta->txrate_idx].bitrate);
 #endif
 }
 


--
Ciao
Stefano
