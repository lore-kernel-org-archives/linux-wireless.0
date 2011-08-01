Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38914 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1HAJdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 05:33:07 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so4380927fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 02:33:06 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2 2/2] mac80211: Don't use EAPOL frames for rate sampling
Date: Mon,  1 Aug 2011 11:32:53 +0200
Message-Id: <1312191173-23963-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110801_113311_691875_7FF5EC95)
In-Reply-To: <1312191173-23963-1-git-send-email-helmut.schaa@googlemail.com>
References: <1312191173-23963-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Haven't done much testing yet but this looks safe to me.
Helmut

 net/mac80211/rc80211_minstrel_ht.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 66a1eeb..2158838 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -608,7 +608,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		return mac80211_minstrel.get_rate(priv, sta, &msp->legacy, txrc);
 
 	info->flags |= mi->tx_flags;
-	sample_idx = minstrel_get_sample_rate(mp, mi);
+
+	/* Don't use EAPOL frames for sampling on non-mrr hw */
+	if (mp->hw->max_rates == 1 &&
+	    txrc->skb->protocol == cpu_to_be16(ETH_P_PAE))
+		sample_idx = -1;
+	else
+		sample_idx = minstrel_get_sample_rate(mp, mi);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
-- 
1.7.3.4

