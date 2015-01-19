Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41579 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbASTpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 14:45:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ath5k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: document a fall-through case in ath5k_hw_set_opmode
Date: Mon, 19 Jan 2015 14:09:15 -0500
Message-Id: <1421694555-20795-1-git-send-email-linville@tuxdriver.com> (sfid-20150119_204533_899775_A294D78D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coverity: CID 114932

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I'm guessing this is OK, since it seems to work?

 drivers/net/wireless/ath/ath5k/pcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index c60d36aa13e2..bf29da5e90da 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -912,6 +912,7 @@ ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
 			| (ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
+		/* fall through */
 	case NL80211_IFTYPE_MONITOR:
 		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
 			| (ah->ah_version == AR5K_AR5210 ?
-- 
2.1.0

