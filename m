Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27964 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751739Ab1AUDTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:19:09 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-09329946
	for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 12:19:07 +0900 (JST)
Subject: [PATCH v3] ath5k: Simplify loop when setting up channels
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	me@bobcopeland.com
Date: Fri, 21 Jan 2011 12:19:52 +0900
Message-ID: <20110121031952.7059.68911.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify confusing code and get rid of an unnecessary variable.

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v3:	Bob pointed out another wrong check: count <= max.
	The loop really was confusing _me_...
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6850112..69ec878 100644
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
+	for (ch = 1; ch <= size && count < max; ch++) {
 		freq = ieee80211_channel_to_frequency(ch, band);
 
 		if (freq == 0) /* mapping failed - not a standard channel */
@@ -312,7 +312,6 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		}
 
 		count++;
-		max--;
 	}
 
 	return count;

