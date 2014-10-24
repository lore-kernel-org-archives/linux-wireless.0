Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60392 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaJXMfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 08:35:04 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so1074927wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 05:35:02 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: minstrel_ht: do not always skip ht rates vht_only is true
Date: Fri, 24 Oct 2014 14:34:49 +0200
Message-Id: <1414154089-5185-1-git-send-email-karl.beldan@gmail.com> (sfid-20141024_143508_751551_228A29FF)
In-Reply-To: <1414152061.1934.2.camel@jlt4.sipsolutions.net>
References: <1414152061.1934.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When CONFIG_MAC80211_RC_MINSTREL_VHT is set, the module param
minstrel_vht_only tells minstrel_ht whether to allow the mix of ht rates
with vht rates.
ATM, minstrel_ht skips ht rates when minstrel_vht_only is true, but it does
that even if vht is not supported, which makes the sta rates fallback to
legacy as no ht rate gets enabled.

Fixes: 9208247d74bc ("mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz")
Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 4666681..c50fd94 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1193,7 +1193,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		/* HT rate */
 		if (gflags & IEEE80211_TX_RC_MCS) {
 #ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
-			if (minstrel_vht_only)
+			if (use_vht && minstrel_vht_only)
 				continue;
 #endif
 			mi->groups[i].supported = mcs->rx_mask[nss - 1];
-- 
2.0.1

