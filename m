Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1HSVKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 17:10:34 -0400
Received: by fxh19 with SMTP id 19so2180781fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 14:10:33 -0700 (PDT)
Message-Id: <2de58131999ccc3a6d8f048c5ccbbeaec8f8eec9.1313434481.git.chunkeey@googlemail.com> (sfid-20110819_231038_186347_74CE3820)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 15 Aug 2011 18:45:54 +0200
Subject: [PATCH 1/4] carl9170: fix timekeeping for HW_COUNTER firmwares
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9170_PWR_REG_PLL_ADDAC is used to set the main clock
divisor which affects the AHB/CPU speed. Because this
would interfere with the firmware internal timekeeping,
the function has to be moved into the firmware.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/fw.c       |    3 +++
 drivers/net/wireless/ath/carl9170/phy.c      |    9 ++++-----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index c5427a7..f7dbdaa 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -282,6 +282,7 @@ struct ar9170 {
 		bool rx_stream;
 		bool tx_stream;
 		bool rx_filter;
+		bool hw_counters;
 		unsigned int mem_blocks;
 		unsigned int mem_block_size;
 		unsigned int rx_size;
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 39ddea5..f4cae1c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -266,6 +266,9 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 			FIF_PROMISC_IN_BSS;
 	}
 
+	if (SUPP(CARL9170FW_HW_COUNTERS))
+		ar->fw.hw_counters = true;
+
 	if (SUPP(CARL9170FW_WOL))
 		device_set_wakeup_enable(&ar->udev->dev, true);
 
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index aa147a9..8635c5c 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -578,11 +578,10 @@ static int carl9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 	if (err)
 		return err;
 
-	/* XXX: remove magic! */
-	if (is_2ghz)
-		err = carl9170_write_reg(ar, AR9170_PWR_REG_PLL_ADDAC, 0x5163);
-	else
-		err = carl9170_write_reg(ar, AR9170_PWR_REG_PLL_ADDAC, 0x5143);
+	if (!ar->fw.hw_counters) {
+		err = carl9170_write_reg(ar, AR9170_PWR_REG_PLL_ADDAC,
+					 is_2ghz ? 0x5163 : 0x5143);
+	}
 
 	return err;
 }
-- 
1.7.5.4

