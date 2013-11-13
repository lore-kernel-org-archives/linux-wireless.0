Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48919 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3KMW5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 17:57:38 -0500
Received: by mail-wg0-f45.google.com with SMTP id a1so1121166wgh.12
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 14:57:37 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC] squash! mac80211: minstrel_ht: add basic support for VHT rates <= 80MHz
Date: Wed, 13 Nov 2013 23:57:03 +0100
Message-Id: <1384383423-23888-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_235741_204967_61C1CBC9)
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

For v2:
- typo in vht mcs mask in minstrel_ht_set_rate

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 520da45..8572b8f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -745,7 +745,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
 	else if (flags & IEEE80211_TX_RC_VHT_MCS)
 		idx = ((group->streams - 1) << 4) |
-		      ((index % MCS_GROUP_RATES) & ~0xF);
+		      ((index % MCS_GROUP_RATES) & 0xF);
 	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
 
-- 
1.8.2

