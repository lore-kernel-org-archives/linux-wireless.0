Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38923 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDYSxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 14:53:39 -0400
Received: by mail-lb0-f176.google.com with SMTP id 10so3298860lbg.21
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 11:53:37 -0700 (PDT)
Date: Fri, 25 Apr 2014 22:53:34 +0400
From: Nickolay Ledovskikh <nledovskikh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, reyk@openbsd.org,
	mickflemm@gmail.com, jirislaby@gmail.com, nbd@openwrt.org
Subject: [PATCH] ath5k: Fix AR5K_PHY_TXPOWER_RATE_MAX register value
 setting.
Message-Id: <20140425225334.646d5bb22f458e0054b965c3@lnv.dyndns-server.com> (sfid-20140425_205343_206033_CC44EAAB)
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
