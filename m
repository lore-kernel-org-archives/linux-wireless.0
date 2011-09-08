Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51783 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1IHI55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 04:57:57 -0400
Received: by fxh19 with SMTP id 19so1276683fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 01:57:56 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Don't aggregate rate probe frames in minstrel_ht
Date: Thu,  8 Sep 2011 10:58:01 +0200
Message-Id: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110908_105800_411583_5B5607DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is already done by rt2x00 and ath9k by checking the
IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. Instead we can simply do it in
minstrel_ht.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Felix, I didn't have a closer look at the ath9k aggregation code but I guess it
can also be simplified with this change.

Any objections?

Thanks,
Helmut

 net/mac80211/rc80211_minstrel_ht.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2158838..6a7bbe0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -627,6 +627,8 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
 			txrc, true, false);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+		/* don't aggregate probe frames */
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 	} else {
 		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
 			txrc, false, false);
-- 
1.7.3.4

