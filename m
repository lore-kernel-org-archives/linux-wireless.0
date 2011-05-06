Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13833 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab1EFPy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 11:54:59 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 08:54:31 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k: make npending frames check as bool
Date: Fri, 6 May 2011 21:24:51 +0530
Message-ID: <1304697291-6850-1-git-send-email-mshajakhan@atheros.com> (sfid-20110506_175501_452422_1DCEBB4D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de115d..2b78ea2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2267,7 +2267,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 		timeout = 1;
 
 	for (j = 0; j < timeout; j++) {
-		int npend = 0;
+		bool npend = false;
 
 		if (j)
 			usleep_range(1000, 2000);
@@ -2276,7 +2276,10 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
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

