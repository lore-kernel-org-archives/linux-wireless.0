Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36501 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDYSrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 14:47:08 -0400
Received: by mail-la0-f42.google.com with SMTP id mc6so2200965lab.15
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 11:47:07 -0700 (PDT)
Date: Fri, 25 Apr 2014 22:47:04 +0400
From: Nickolay Ledovskikh <nledovskikh@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: reyk@openbsd.org, mickflemm@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org
Subject: [PATCH] ath5k: Fix AR5K_PHY_TXPOWER_RATE_MAX register value
 setting.
Message-Id: <20140425224704.88dbe868ae7755ef2696cde6@lnv.dyndns-server.com> (sfid-20140425_204722_000779_F9E22515)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was reading ath5k power setting code and 
noticed typing error in ath5k_hw_txpower function.
Invalid value was written to AR5K_PHY_TXPOWER_RATE_MAX
register.

Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 1a2973b..f383b25 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3709,8 +3709,8 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 			AR5K_REG_MS(AR5K_TUNE_MAX_TXPOWER, AR5K_TPC_CHIRP),
 			AR5K_TPC);
 	} else {
-		ath5k_hw_reg_write(ah, AR5K_PHY_TXPOWER_RATE_MAX |
-			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
+		ath5k_hw_reg_write(ah, AR5K_TUNE_MAX_TXPOWER, 
+			AR5K_PHY_TXPOWER_RATE_MAX);
 	}
 
 	return 0;
-- 
Best regards, Nikolay Ledovskikh.
