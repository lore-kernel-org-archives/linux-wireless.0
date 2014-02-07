Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46040 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaBGLvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:07 -0500
Date: Fri, 7 Feb 2014 14:50:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath5k: shifting the wrong variable for AR5K_AR5210
Message-ID: <20140207115038.GA31250@elgon.mountain> (sfid-20140207_132638_985862_B029C254)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the original code we shift "AR5K_PHY(256) >> 28" which is zero but
the intent was to shift the return value of ath5k_hw_reg_read() like we
do a couple lines later.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis.  Untested.

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index d6bc7cb61bfb..1a2973b7acf2 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -110,7 +110,7 @@ ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 		ath5k_hw_reg_write(ah, 0x00010000, AR5K_PHY(0x20));
 
 	if (ah->ah_version == AR5K_AR5210) {
-		srev = ath5k_hw_reg_read(ah, AR5K_PHY(256) >> 28) & 0xf;
+		srev = (ath5k_hw_reg_read(ah, AR5K_PHY(256)) >> 28) & 0xf;
 		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
 	} else {
 		srev = (ath5k_hw_reg_read(ah, AR5K_PHY(0x100)) >> 24) & 0xff;
