Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:46861 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031437AbeCAOWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:35 -0500
Received: by mail-qt0-f195.google.com with SMTP id m13so7667874qtg.13
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:35 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 51/52] ath: Map Vietnam to ETSI3_WORLD
Date: Thu,  1 Mar 2018 15:19:01 +0100
Message-Id: <20180301141902.24824-52-sven.eckelmann@openmesh.com> (sfid-20180301_153349_634253_EB25B5D3)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code is used to select the correct the correct conformance
test limits (CTL) for a country. If the regdomain code isn't correctly
mapped to the actual CTL entries in EEPROM then it could happen that the
device violates the regulations. But it can also happen that the device is
then not able to be used with its full txpower on all rates.

The CTL mappings for this regdomain code were now changed to:

* 2.4GHz: ETSI
* 5GHz: NO_CTL -> ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index d22eff3fe75b..7e06d1146e8a 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -498,7 +498,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_URUGUAY, FCC3_WORLD, "UY"},
 	{CTRY_UZBEKISTAN, FCC3_FCCA, "UZ"},
 	{CTRY_VENEZUELA, FCC1_WORLD, "VE"},
-	{CTRY_VIET_NAM, NULL1_WORLD, "VN"},
+	{CTRY_VIET_NAM, ETSI3_WORLD, "VN"},
 	{CTRY_YEMEN, NULL1_WORLD, "YE"},
 	{CTRY_ZIMBABWE, NULL1_WORLD, "ZW"},
 };
-- 
2.11.0
