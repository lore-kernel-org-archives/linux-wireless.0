Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26482 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0KJNDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:03:35 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:03:22 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 03/11] ath9k_hw: Initialize 2GHz CTL properly.
Date: Wed, 10 Nov 2010 05:03:08 -0800
Message-ID: <1289394196-3465-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

The last 2GHz CTL was not being initialized, so power was being
set to 0 instead of 30dbm. Initialize to 30 like other CTLs.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index bc3f49c..b33fb5b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -306,6 +306,7 @@ static const struct ar9300_eeprom ar9300_default = {
 
 		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
 		 { { {60, 0}, {60, 1}, {60, 1}, {60, 1} } },
+		 { { {60, 0}, {60, 1}, {60, 1}, {60, 1} } },
 	 },
 	.modalHeader5G = {
 		/* 4 idle,t1,t2,b (4 bits per setting) */
-- 
1.7.0.4

