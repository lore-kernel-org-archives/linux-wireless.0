Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57473 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJGNx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 09:53:59 -0400
Received: by mail-wi0-f174.google.com with SMTP id cc10so7923645wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 06:53:58 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211/trivial: fix typo in starting baserate for rts_cts_rate_idx
Date: Tue,  7 Oct 2014 15:53:38 +0200
Message-Id: <1412690018-18429-1-git-send-email-karl.beldan@gmail.com> (sfid-20141007_155402_831759_96F0C2C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Fixes: 5253ffb8 ("mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates")
Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8fdadfd..6081329 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -448,7 +448,7 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 	 */
 	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
-		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
+		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
 
 		rate = &sband->bitrates[rates[0].idx];
 
-- 
2.0.1

