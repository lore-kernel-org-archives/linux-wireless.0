Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25566 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1G2MK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:10:58 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH v2 08/13] ath9k_hw: Fix incorrect Tx control power in AR9003 template
Date: Fri, 29 Jul 2011 17:38:15 +0530
Message-ID: <1311941300-2590-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_141101_887251_7CB608D9)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
Setting incorrect CTL power in calibration is causing lower tx power.
Tx power was reported as 3dBm while operating in channel 6 HT40+/
in channel 11 HT40- due to CTL powers in the calibration is set to
zero.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index e216712..9257afd 100644
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

