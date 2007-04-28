Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52986 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965966AbXD1QmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/7] mac80211: kill ceiling_div
Date: Sat, 28 Apr 2007 12:36:01 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163601.27203.68605.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

kernel.h provides a macro which does the same thing as ceiling_div.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 4d7c035..66fb4db 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -612,12 +612,6 @@ ieee80211_tx_h_wep_encrypt(struct ieee80211_txrx_data *tx)
 }
 
 
-static inline int ceiling_div(int dividend, int divisor)
-{
-	return ((dividend + divisor - 1) / divisor);
-}
-
-
 static int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 				    int rate, int erp, int short_preamble)
 {
@@ -629,7 +623,7 @@ static int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 	 * also include SIFS.
 	 *
 	 * rate is in 100 kbps, so divident is multiplied by 10 in the
-	 * ceiling_div() operations.
+	 * DIV_ROUND_UP() operations.
 	 */
 
 	if (local->hw.conf.phymode == MODE_IEEE80211A || erp ||
@@ -651,8 +645,8 @@ static int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 		dur = 16; /* SIFS + signal ext */
 		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
 		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
-		dur += 4 * ceiling_div((16 + 8 * (len + 4) + 6) * 10,
-				       4 * rate); /* T_SYM x N_SYM */
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate); /* T_SYM x N_SYM */
 	} else {
 		/*
 		 * 802.11b or 802.11g with 802.11b compatibility:
@@ -667,7 +661,7 @@ static int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 		dur = 10; /* aSIFSTime = 10 usec */
 		dur += short_preamble ? (72 + 24) : (144 + 48);
 
-		dur += ceiling_div(8 * (len + 4) * 10, rate);
+		dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);
 	}
 
 	return dur;

