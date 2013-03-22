Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55892 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab3CVPvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 11:51:47 -0400
Received: by mail-ee0-f53.google.com with SMTP id e53so2280214eek.12
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 08:51:46 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC V3 2/2] mac80211: Let drivers not supporting channel contexts use VHT
Date: Fri, 22 Mar 2013 16:48:24 +0100
Message-Id: <1363967304-4394-2-git-send-email-karl.beldan@gmail.com> (sfid-20130322_165153_420876_D687E7EB)
In-Reply-To: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com>
References: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

It is possible since the global hw config and local switched to
cfg80211_chan_def.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/main.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c71efbe..9d5b9c6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -838,22 +838,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (supp_ht)
 		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
 
-	if (supp_vht) {
+	if (supp_vht)
 		local->scan_ies_len +=
 			2 + sizeof(struct ieee80211_vht_cap);
 
-		/*
-		 * (for now at least), drivers wanting to use VHT must
-		 * support channel contexts, as they contain all the
-		 * necessary VHT information and the global hw config
-		 * doesn't (yet)
-		 */
-		if (WARN_ON(!local->use_chanctx)) {
-			result = -EINVAL;
-			goto fail_wiphy_register;
-		}
-	}
-
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
 		local->hw.wiphy->max_scan_ssids = 4;
-- 
1.7.10.GIT

