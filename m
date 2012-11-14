Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab2KNIXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 03:23:42 -0500
Date: Wed, 14 Nov 2012 11:23:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath5k: precedence error in ath5k_hw_nic_wakeup()
Message-ID: <20121114082307.GA31792@elgon.mountain> (sfid-20121114_092347_951659_68072C69)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'|' has higher precedence than ?:.  Since AR5K_PHY_TURBO_MODE is 0x1 and
"AR5K_PHY_TURBO_MODE | (ah->ah_radio == AR5K_RF2425)" is true then we
always set turbo to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis fix.  I don't have a way to test this.

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 0c2dd47..4084b10 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -789,9 +789,9 @@ ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 		 * (I don't think it supports 44MHz) */
 		/* On 2425 initvals TURBO_SHORT is not present */
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
-			turbo = AR5K_PHY_TURBO_MODE |
-				(ah->ah_radio == AR5K_RF2425) ? 0 :
-				AR5K_PHY_TURBO_SHORT;
+			turbo = AR5K_PHY_TURBO_MODE;
+			if (ah->ah_radio != AR5K_RF2425)
+				turbo |= AR5K_PHY_TURBO_SHORT;
 		} else if (ah->ah_bwmode != AR5K_BWMODE_DEFAULT) {
 			if (ah->ah_radio == AR5K_RF5413) {
 				mode |= (ah->ah_bwmode == AR5K_BWMODE_10MHZ) ?
