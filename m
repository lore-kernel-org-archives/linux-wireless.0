Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0HGAHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 20:07:08 -0400
Received: by bwz3 with SMTP id 3so287799bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 17:07:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] minstrel_ht: fill out more than 3 rates
Date: Sat, 7 Aug 2010 00:07:52 +0200
Cc: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008070007.53294.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix,

I've stumbled into this conundrum a while ago...
then as usual: forgot that it existed, until yesterday:

As you know minstrel (our non ht fallback) enables mrr-mode
only if the driver sets hw->max_rates to 4 or more. 
minstrel_ht - on the other hand - just prepares a set
of 3 rates, so at least one additional retry with
different tx-vectors remains unused...

How the last tries should be used is up for debate,
I've opted out for lowest possible MCS.
(although, some devices may also use a legacy
 rate for the final tries...)

And the reason why I think it's worth to do an additional
round: The reordering penalty for lost MPDUs on the receiver-
side can be as high as 100ms, which is quite expensive compared
to some extra airtime...
---
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c5b4659..5f44c0b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -584,7 +584,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_priv *mp = priv;
-	int sample_idx;
+	int sample_idx, i = 0;
 
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
@@ -595,21 +595,29 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	info->flags |= mi->tx_flags;
 	sample_idx = minstrel_get_sample_rate(mp, mi);
 	if (sample_idx >= 0) {
-		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
+		minstrel_ht_set_rate(mp, mi, &ar[i++], sample_idx,
 			txrc, true, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
+		minstrel_ht_set_rate(mp, mi, &ar[i++], mi->max_tp_rate,
 			txrc, false, true);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
-		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
+		minstrel_ht_set_rate(mp, mi, &ar[i++], mi->max_tp_rate,
 			txrc, false, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
+		minstrel_ht_set_rate(mp, mi, &ar[i++], mi->max_tp_rate2,
 			txrc, false, true);
 	}
-	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, true);
+	minstrel_ht_set_rate(mp, mi, &ar[i++], mi->max_prob_rate,
+			     txrc, false, true);
 
-	ar[3].count = 0;
-	ar[3].idx = -1;
+	for (;i < mp->hw->max_rates; i++) {
+		minstrel_ht_set_rate(mp, mi, &ar[i++], 0,
+				     txrc, false, true);
+	}
+
+	for (; i < IEEE80211_TX_MAX_RATES; i++) {
+		ar[i].count = 0;
+		ar[i].idx = -1;
+	}
 
 	mi->total_packets++;
 
