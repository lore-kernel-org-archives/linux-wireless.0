Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:41469 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3DRMaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 08:30:46 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so1209237ead.27
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 05:30:45 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 2/2] mac80211: minstrel_ht: initialize rates selection
Date: Thu, 18 Apr 2013 14:26:21 +0200
Message-Id: <1366287981-24134-2-git-send-email-karl.beldan@gmail.com> (sfid-20130418_143049_012369_721AC3FB)
In-Reply-To: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
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
 
+	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
+	minstrel_ht_update_stats(mp, mi);
+
 	return;
 
 use_legacy:
-- 
1.8.2

