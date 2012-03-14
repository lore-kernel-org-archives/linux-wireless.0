Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44535 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2CNMba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 08:31:30 -0400
Received: by wibhj6 with SMTP id hj6so7069109wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2012 05:31:29 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Don't sample max throughput rate in minstrel_ht
Date: Wed, 14 Mar 2012 13:31:11 +0100
Message-Id: <1331728271-7645-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120314_133134_173453_1DCA4C88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current max throughput rate is known to be good as otherwise it
wouldn't be the max throughput rate. Since rate sampling can introduce
some overhead (by adding RTS for example or due to not aggregating the
frame) don't sample the max throughput rate.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/rc80211_minstrel_ht.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index dbe3dd3..dc40b7b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -591,6 +591,13 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	minstrel_next_sample_idx(mi);
 
 	/*
+	 * Sampling might add some overhead (RTS, no aggregation)
+	 * to the frame. Hence, don't use sampling for the currently
+	 * used max TP rate.
+	 */
+	if (sample_idx == mi->max_tp_rate)
+		return -1;
+	/*
 	 * When not using MRR, do not sample if the probability is already
 	 * higher than 95% to avoid wasting airtime
 	 */
-- 
1.7.7

