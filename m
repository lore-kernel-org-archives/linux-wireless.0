Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13837 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0LAHdw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:33:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:33:38 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/26] ath9k: Disable TX STBC for AR9485
Date: Tue, 30 Nov 2010 23:32:37 -0800
Message-ID: <1291188775-13707-9-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2962ce3..3439fa7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -210,7 +210,9 @@ static void setup_ht_cap(struct ath_softc *sc,
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9485(ah))
+		max_streams = 1;
+	else if (AR_SREV_9300_20_OR_LATER(ah))
 		max_streams = 3;
 	else
 		max_streams = 2;
-- 
1.7.0.4

