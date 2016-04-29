Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34186 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbcD2NHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 09:07:30 -0400
Received: by mail-wm0-f65.google.com with SMTP id n129so4999920wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2016 06:07:30 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Fix symbol overlap window for half/quarter channels
Date: Fri, 29 Apr 2016 15:06:34 +0200
Message-Id: <1461935194-19632-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20160429_150755_621079_2FCC29AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit cd6cfd7311a385144a2f9c74f692ae2df3ae033f
"ath9k: do not set half/quarter channel flags in AR_PHY_MODE" the
condition "rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF)" would
never evaluate to true.

Fix this by using the available IS_CHAN_HALF_RATE and IS_CHAN_QUARTER_RATE
marcros instead.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
Just stumbled over that piece of code while looking into TX99, so
this is only compile-tested.

Felix, can you please confirm if this is correct or if removing
the whole block would be better?

Thanks,
Helmut

 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 81ab3ca..ae304355 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1010,7 +1010,7 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
 
-	if (rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF))
+	if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
 		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL,
 			      AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW, 3);
 
-- 
2.8.1

