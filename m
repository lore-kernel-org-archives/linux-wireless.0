Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:34058 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753867Ab1ASJUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:18 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0960118815
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:17 +0900 (JST)
Subject: [PATCH 2/8] ath5k: Simplify loop when setting up channels
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:42 +0900
Message-ID: <20110119092042.19628.81667.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify confusing code and get rid of an unnecessary variable.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6850112..0387acb 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -261,7 +261,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		unsigned int mode,
 		unsigned int max)
 {
-	unsigned int i, count, size, chfreq, freq, ch;
+	unsigned int count, size, chfreq, freq, ch;
 	enum ieee80211_band band;
 
 	if (!test_bit(mode, ah->ah_modes))
@@ -285,8 +285,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		return 0;
 	}
 
-	for (i = 0, count = 0; i < size && max > 0; i++) {
-		ch = i + 1 ;
+	count = 0;
+	for (ch = 1; ch < size && count <= max; ch++) {
 		freq = ieee80211_channel_to_frequency(ch, band);
 
 		if (freq == 0) /* mapping failed - not a standard channel */
@@ -312,7 +312,6 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		}
 
 		count++;
-		max--;
 	}
 
 	return count;

