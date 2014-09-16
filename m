Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35829 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488AbaIPANX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:23 -0400
Received: by mail-wi0-f173.google.com with SMTP id em10so5193336wid.12
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:22 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 05/10] ath9k: do not overwrite ACK timeout estimation
Date: Tue, 16 Sep 2014 02:13:11 +0200
Message-Id: <1410826396-15544-6-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021343_926822_F3F167C2)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not overwrite ACK timeout estimation in ath9k_hw_init_global_settings() if
dynack processing has been enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e71f824..949d5d6 100644
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

