Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34910 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3FCJTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 05:19:07 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rmanohar@qca.qualcomm.com
Subject: [PATCH 3.10] Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"
Date: Mon,  3 Jun 2013 11:18:57 +0200
Message-Id: <1370251137-3130-1-git-send-email-nbd@openwrt.org> (sfid-20130603_111911_409232_CB8A4F34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 68d9e1fa24d9c7c2e527f49df8d18fb8cf0ec943

This change reduces rx sensitivity with no apparent extra benefit.
It looks like it was meant for testing in a specific scenario,
but it was never properly validated.

Cc: rmanohar@qca.qualcomm.com
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index db5ffad..7546b9a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -958,11 +958,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x1a1a1a1a},
-	{0x0000a084, 0x1a1a1a1a},
-	{0x0000a088, 0x1a1a1a1a},
-	{0x0000a08c, 0x1a1a1a1a},
-	{0x0000a090, 0x171a1a1a},
+	{0x0000a080, 0x22222229},
+	{0x0000a084, 0x1d1d1d1d},
+	{0x0000a088, 0x1d1d1d1d},
+	{0x0000a08c, 0x1d1d1d1d},
+	{0x0000a090, 0x171d1d1d},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},
-- 
1.8.0.2

