Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59403 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3CBUUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 15:20:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3/3] minstrel_ht: increase sampling frequency
Date: Sat,  2 Mar 2013 21:20:14 +0100
Message-Id: <1362255614-30859-3-git-send-email-nbd@openwrt.org> (sfid-20130302_212025_751696_7EC78B4D)
In-Reply-To: <1362255614-30859-2-git-send-email-nbd@openwrt.org>
References: <1362255614-30859-1-git-send-email-nbd@openwrt.org>
 <1362255614-30859-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to sample all available rates, as sample attempts do not cost much
airtime and are appropriately spaced based on the average A-MPDU length.
This helps with faster recovery on rate fluctuations.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6c735e0..4d35bc5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -312,8 +312,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		}
 	}
 
-	/* try to sample up to half of the available rates during each interval */
-	mi->sample_count *= 4;
+	/* try to sample all available rates during each interval */
+	mi->sample_count *= 8;
 
 	cur_prob = 0;
 	cur_prob_tp = 0;
-- 
1.8.0.2

