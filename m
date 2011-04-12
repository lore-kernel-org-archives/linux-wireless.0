Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38831 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1DLNGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:06:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:05:41 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 20/22] ath9k_hw: Assign macversion based on devid for built-in wmac
Date: Tue, 12 Apr 2011 18:27:20 +0530
Message-ID: <1302613042-1754-21-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 67556ca..aaf7f7a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -247,6 +247,17 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 {
 	u32 val;
 
+	switch (ah->hw_version.devid) {
+	case AR5416_AR9100_DEVID:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
+		break;
+	case AR9300_DEVID_AR9340:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9340;
+		val = REG_READ(ah, AR_SREV);
+		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
+		return;
+	}
+
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
 
 	if (val == 0xFF) {
@@ -487,9 +498,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
-		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
-
 	ath9k_hw_read_revisions(ah);
 
 	/*
-- 
1.7.0.4

