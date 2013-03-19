Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44900 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3CSAXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 20:23:36 -0400
Received: by mail-wi0-f179.google.com with SMTP id ez12so3265646wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 17:23:35 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC V2 2/2] mac80211: Let drivers not supporting channel contexts use VHT
Date: Tue, 19 Mar 2013 01:23:20 +0100
Message-Id: <1363652600-23223-3-git-send-email-karl.beldan@gmail.com> (sfid-20130319_012340_380296_88D2EECF)
In-Reply-To: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

It is possible since the global hw config and local switched to
cfg80211_chan_def.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/main.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1da8ce0..e97f85a 100644
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
1.7.9.dirty

