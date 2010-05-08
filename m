Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:51222 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0EHQXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:23:02 -0400
Received: by qyk13 with SMTP id 13so3446177qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:23:01 -0700 (PDT)
Date: Sat, 8 May 2010 18:22:47 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch 3/9] ath9k: cleanup: u32 => bool
Message-ID: <20100508162247.GO27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used as a boolean variable so changing it to a boolean type is a
cleanup.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index b2c17c9..f685b8b 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1082,7 +1082,7 @@ static bool ar5008_hw_ani_control(struct ath_hw *ah,
 		const int m2Thresh[] = { 127, 0x40 };
 		const int m2CountThr[] = { 31, 16 };
 		const int m2CountThrLow[] = { 63, 48 };
-		u32 on = param ? 1 : 0;
+		bool on = param ? 1 : 0;
 
 		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
 			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 80431a2..0c34154 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -771,7 +771,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		const int m2Thresh[] = { 127, 0x40 };
 		const int m2CountThr[] = { 31, 16 };
 		const int m2CountThrLow[] = { 63, 48 };
-		u32 on = param ? 1 : 0;
+		bool on = param ? 1 : 0;
 
 		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
 			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
