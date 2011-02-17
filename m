Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42757 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1BQErt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 23:47:49 -0500
Received: by bwz15 with SMTP id 15so1338028bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 20:47:47 -0800 (PST)
Date: Thu, 17 Feb 2011 07:44:54 +0300
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com, jirislaby@gmail.com
Subject: [PATCH] ath5k: Correct channel setting for ar2317 chip
Message-Id: <20110217074454.7233f22f.nledovskikh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use correct channel setting function for AR2317

Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 78c26fd..c44111f 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1253,6 +1253,7 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	case AR5K_RF5111:
 		ret = ath5k_hw_rf5111_channel(ah, channel);
 		break;
+	case AR5K_RF2317:
 	case AR5K_RF2425:
 		ret = ath5k_hw_rf2425_channel(ah, channel);
 		break;

-- 
Best regards, Nikolay Ledovskikh.
