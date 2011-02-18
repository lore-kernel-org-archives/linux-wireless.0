Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.kodofon.ru ([89.18.141.241]:52936 "EHLO kodofon.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1BRLqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:46:48 -0500
Date: Fri, 18 Feb 2011 13:39:58 +0000
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com, jirislaby@gmail.com
Subject: [PATCH] ath5k: Correct channel setting for AR2317 chip
Message-Id: <20110218133958.8bc626a3.nledovskikh@gmail.com>
Reply-To: nledovskikh@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct channel setting function must be used for AR2317.
When I tested ahb patch on bullet2 all seemed to work fine, 
but it couldn't connect another host (using ibss for example). 
During an analysis I observed that it's transmitting on another 
channel. I looked into madwifi code and understood that
the problem is in channel setting function. So atheros RF2317 not 
fully handled in the current ath5k version and must be patched.

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
