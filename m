Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44143 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0GVTpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:45:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] minstrel_ht: remove unnecessary NULL check in minstrel_ht_update_caps
Date: Thu, 22 Jul 2010 15:39:24 -0400
Message-Id: <1279827564-24742-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20100722110933.GA17585@bicker>
References: <20100722110933.GA17585@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If sta is NULL, we will have problems long before we get here...

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index b5ace24..a16694b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -636,7 +636,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	int i;
 
 	/* fall back to the old minstrel for legacy stations */
-	if (sta && !sta->ht_cap.ht_supported) {
+	if (!sta->ht_cap.ht_supported) {
 		msp->is_ht = false;
 		memset(&msp->legacy, 0, sizeof(msp->legacy));
 		msp->legacy.r = msp->ratelist;
-- 
1.7.1.1

