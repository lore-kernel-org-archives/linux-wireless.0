Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64635 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaGMKSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:31 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so1212378wib.8
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:30 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 05/10] ath9k: do not overwrite ack timeout estimation
Date: Sun, 13 Jul 2014 12:18:19 +0200
Message-Id: <1405246704-7489-6-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121846_662057_7C3B1389)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not overwrite ack timeout estimation in ath9k_hw_init_global_settings() if
dynack processing is enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a6b113..b2ca47a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1055,6 +1055,14 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		ctstimeout += 48 - sifstime - ah->slottime;
 	}
 
+	if (ah->dynack.enabled) {
+		acktimeout = ah->dynack.ackto;
+		ctstimeout = acktimeout;
+		slottime = (acktimeout - 3) / 2;
+	} else {
+		ah->dynack.ackto = acktimeout;
+	}
+
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
-- 
1.9.1

