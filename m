Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64537 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0IQXI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:27 -0400
Received: by bwz11 with SMTP id 11so3128491bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:26 -0700 (PDT)
Message-Id: <99b5b4fce19b1c221e8eee563dc6e4b086ae493b.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 22:07:59 +0200
Subject: [PATCH 1/7] carl9170: use rx chainmask from eeprom
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The eeprom provides a mask for all present rx chains.
Why not use it instead of the generic initval default?

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/phy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 71dea97..fe265e3 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -532,8 +532,11 @@ static int carl9170_init_phy_from_eeprom(struct ar9170 *ar,
 	SET_VAL(AR9170_PHY_TPCRG1_PD_GAIN_2, val,
 		xpd2pd[m->xpdGain & 0xf] >> 2);
 	carl9170_regwrite(AR9170_PHY_REG_TPCRG1, val);
-	carl9170_regwrite_finish();
 
+	carl9170_regwrite(AR9170_PHY_REG_RX_CHAINMASK, ar->eeprom.rx_mask);
+	carl9170_regwrite(AR9170_PHY_REG_CAL_CHAINMASK, ar->eeprom.rx_mask);
+
+	carl9170_regwrite_finish();
 	return carl9170_regwrite_result();
 }
 
-- 
1.7.1

