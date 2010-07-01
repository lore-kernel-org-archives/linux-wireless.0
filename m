Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49992 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0GAPTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 11:19:54 -0400
Received: by pwi5 with SMTP id 5so199296pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jul 2010 08:19:52 -0700 (PDT)
From: tom.leiming@gmail.com
To: nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] minstrel_ht: fix check for downgrading of top2 rate
Date: Thu,  1 Jul 2010 23:19:50 +0800
Message-Id: <1277997590-3512-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

The check should be against current top2 rate, instead of
current top rate.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 8fba6f4..b5ace24 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -443,8 +443,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		minstrel_downgrade_rate(mi, &mi->max_tp_rate, true);
 
 	rate2 = minstrel_get_ratestats(mi, mi->max_tp_rate2);
-	if (rate->attempts > 30 &&
-	    MINSTREL_FRAC(rate->success, rate->attempts) <
+	if (rate2->attempts > 30 &&
+	    MINSTREL_FRAC(rate2->success, rate2->attempts) <
 	    MINSTREL_FRAC(20, 100))
 		minstrel_downgrade_rate(mi, &mi->max_tp_rate2, false);
 
-- 
1.6.2.5

