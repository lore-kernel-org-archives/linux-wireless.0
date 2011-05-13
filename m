Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31900 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1EMP3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:29:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:29:20 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: make npending frames check as bool
Date: Fri, 13 May 2011 20:59:42 +0530
Message-ID: <1305300582-5723-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_172957_556123_F75412EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

we are not doing anything by tracking the number of pending frames.
bail out when we first find a pending frame in any one of the 10 queues.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4eec494..17ebdf1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2284,7 +2284,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 		timeout = 1;
 
 	for (j = 0; j < timeout; j++) {
-		int npend = 0;
+		bool npend = false;
 
 		if (j)
 			usleep_range(1000, 2000);
@@ -2293,7 +2293,10 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 			if (!ATH_TXQ_SETUP(sc, i))
 				continue;
 
-			npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
+			npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
+
+			if (npend)
+				break;
 		}
 
 		if (!npend)
-- 
1.7.0.4

