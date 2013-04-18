Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:43780 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3DRLzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:55:47 -0400
Received: by mail-ee0-f43.google.com with SMTP id e50so1213277eek.30
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 04:55:46 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/2] mac80211: minstrel_ht: initialize rates selection
Date: Thu, 18 Apr 2013 13:51:27 +0200
Message-Id: <1366285887-23416-2-git-send-email-karl.beldan@gmail.com> (sfid-20130418_135550_969927_79CA835E)
In-Reply-To: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com>
References: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Initialize {mp,mi}->{max_tp_rate,max_tp_rate2,max_prob_rate} in
minstrel_ht's rate_init and rate_update.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index eb6dc3f..5768cc0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -907,6 +907,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!n_supported)
 		goto use_legacy;
 
+	// initialize {mp,mi}->{max_tp_rate,max_tp_rate2,max_prob_rate}
+	minstrel_ht_update_stats(mp, mi);
+
 	return;
 
 use_legacy:
-- 
1.8.2

