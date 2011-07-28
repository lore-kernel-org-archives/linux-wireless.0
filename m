Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21367 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G1R3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:29:47 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/9] ath9k_hw: Fix incorrect Tx control power in AR9003 template
Date: Thu, 28 Jul 2011 22:59:31 +0530
Message-ID: <1311874176-27569-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_192950_428205_5042F86A)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
Setting incorrect CTL power in calibration is causing lower tx power.
This issue was identified in HT40 mode on channel 6 & 11.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d109c25..6cfc9eb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -307,7 +307,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 
@@ -884,7 +884,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 
@@ -2040,7 +2040,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		{ { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 
-- 
1.7.6

