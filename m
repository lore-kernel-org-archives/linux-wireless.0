Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37791 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYKNLAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 06:00:43 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 03:00:43 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18717.22961.296661.281335@gargle.gargle.HOWL> (sfid-20081114_120048_273379_26D83BF2)
Date: Fri, 14 Nov 2008 16:27:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Use the HT capabilities from the IE instead of the station's caps.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/ht.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0ffbe12..ece79ae 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -36,7 +36,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 
 	ht_cap->ht_supported = true;
 
-	ht_cap->cap = ht_cap->cap & sband->ht_cap.cap;
+	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) & sband->ht_cap.cap;
 	ht_cap->cap &= ~IEEE80211_HT_CAP_SM_PS;
 	ht_cap->cap |= sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS;
 
-- 
1.6.0.3

