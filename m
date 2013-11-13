Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:60189 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3KMR7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:59:38 -0500
Received: by mail-we0-f177.google.com with SMTP id t60so765858wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:59:37 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC] squash! mac80211: minstrel_ht: add basic support for VHT rates <= 80MHz
Date: Wed, 13 Nov 2013 18:59:04 +0100
Message-Id: <1384365544-5840-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_185941_695987_E210DC88)
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

For v2:
- Don't test for IEEE80211_HT_CAP_LDPC_CODING when using vht_only

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6c173a2..04c35cd 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1022,11 +1022,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
 			IEEE80211_HT_CAP_RX_STBC_SHIFT;
 		mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
+		if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
+			mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
 	}
 
-	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
-		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
-
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		u32 gflags = minstrel_mcs_groups[i].flags;
 
-- 
1.8.2

