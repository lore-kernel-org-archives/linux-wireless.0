Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42978 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1BOTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:16:04 -0500
Received: by bwz15 with SMTP id 15so775392bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 11:16:02 -0800 (PST)
Date: Tue, 15 Feb 2011 22:13:13 +0300
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com, jirislaby@gmail.com
Subject: [PATCH] ath5k: Right channel setting for ar2317 chip
Message-Id: <20110215221313.498d21ed.nledovskikh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch that fixes right channel setting when running ar2317 based boards.

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
