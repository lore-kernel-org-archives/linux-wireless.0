Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42916 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaGGJbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:53 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so3036355wgg.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 05/10] ath9k: do not overwrite ack timeout estimation
Date: Mon,  7 Jul 2014 11:31:41 +0200
Message-Id: <1404725506-9571-6-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113214_793727_739EA3C2)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not overwrite ack timeout estimation in ath9k_hw_init_global_settings() if
dynack processing is enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a6b113..d9406ba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1055,6 +1055,14 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		ctstimeout += 48 - sifstime - ah->slottime;
 	}
 
+	if (!ah->dynack.fix_to) {
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

