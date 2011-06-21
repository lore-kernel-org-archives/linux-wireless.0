Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab1FUJVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:21:54 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 02:21:18 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <rodrigue@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<nbd@openwrt.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix calculation of PAPRD training power at 5Ghz
Date: Tue, 21 Jun 2011 14:51:46 +0530
Message-ID: <1308648106-9294-1-git-send-email-mshajakhan@atheros.com> (sfid-20110621_112157_908921_0E49156E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

higher the chainmask, lesser the power_delta to be added
to the paprd_training_power

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index fc9c08f..8f6d11d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -83,7 +83,23 @@ static int ar9003_get_training_power_5g(struct ath_hw *ah)
 	if (delta > scale)
 		return -1;
 
-	power += 2 * get_streams(common->tx_chainmask);
+	switch (get_streams(common->tx_chainmask)) {
+	case 1:
+		delta = 6;
+		break;
+	case 2:
+		delta = 4;
+		break;
+	case 3:
+		delta = 2;
+		break;
+	default:
+		delta = 0;
+		ath_dbg(common, ATH_DBG_CALIBRATE,
+		"Invalid tx-chainmask: %u\n", common->tx_chainmask);
+	}
+
+	power += delta;
 	return power;
 }
 
-- 
1.7.0.4

