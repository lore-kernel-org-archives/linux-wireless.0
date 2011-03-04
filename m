Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44382 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609Ab1CDMbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 07:31:49 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so2003024bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 04:31:48 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Shortcut minstrel_ht rate setup for non-MRR capable devices
Date: Fri,  4 Mar 2011 13:31:32 +0100
Message-Id: <1299241892-6719-2-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com>
References: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices without multi rate retry support won't be able to use all rates
as specified by mintrel_ht. Hence, we can simply skip setting up further
rates as the devices will only use the first one.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

has_mrr is true if the device is able to make use of at least four rates. Not
sure if we might want to consider further special cases for devices with for
example a maximum of two rates.

Tested with rt2800pci.

 net/mac80211/rc80211_minstrel_ht.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 775cf15..6010a5b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -603,19 +603,29 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		sample = true;
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
 			txrc, true, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
-			txrc, false, false);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
 			txrc, false, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
-			txrc, false, true);
 	}
-	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, !sample);
 
-	ar[3].count = 0;
-	ar[3].idx = -1;
+	if (mp->has_mrr) {
+		if (sample_idx >= 0)
+			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
+				txrc, false, false);
+		else
+			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
+				txrc, false, true);
+
+		minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, !sample);
+
+		ar[3].count = 0;
+		ar[3].idx = -1;
+	} else {
+		/* Not using MRR, only use the first rate */
+		ar[1].count = 0;
+		ar[1].idx = -1;
+	}
 
 	mi->total_packets++;
 
-- 
1.7.1

