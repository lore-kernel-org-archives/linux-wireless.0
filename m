Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26487 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0KJNDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:03:41 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:03:29 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 04/11] ath9k_hw: Fix paprd training frame failure.
Date: Wed, 10 Nov 2010 05:03:09 -0800
Message-ID: <1289394196-3465-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

paprd training frame fails in some rates. Fix the rate mask.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b33fb5b..29a1386 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -144,8 +144,8 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txEndToRxOn = 0x2,
 		.txFrameToXpaOn = 0xe,
 		.thresh62 = 28,
-		.papdRateMaskHt20 = LE32(0x80c080),
-		.papdRateMaskHt40 = LE32(0x80c080),
+		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
+		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		},
@@ -346,8 +346,8 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txEndToRxOn = 0x2,
 		.txFrameToXpaOn = 0xe,
 		.thresh62 = 28,
-		.papdRateMaskHt20 = LE32(0xf0e0e0),
-		.papdRateMaskHt40 = LE32(0xf0e0e0),
+		.papdRateMaskHt20 = LE32(0x0c80c080),
+		.papdRateMaskHt40 = LE32(0x0080c080),
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		},
-- 
1.7.0.4

