Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35801 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGTMbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:34 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so5341311wgg.7
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 05/10] ath9k: do not overwrite ack timeout estimation
Date: Sun, 20 Jul 2014 14:31:21 +0200
Message-Id: <1405859486-31414-6-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143150_497057_36FF966C)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
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

