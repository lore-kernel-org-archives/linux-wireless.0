Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:44834 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031424AbeCAOWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:21 -0500
Received: by mail-qk0-f195.google.com with SMTP id v124so7678177qkh.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:20 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 45/52] ath: Map Saudi Arabia to FCC2_WORLD
Date: Thu,  1 Mar 2018 15:18:55 +0100
Message-Id: <20180301141902.24824-46-sven.eckelmann@openmesh.com> (sfid-20180301_152225_208578_79187E83)
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
* 5GHz: NO_CTL -> FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index ba5f112333b8..c20ff7640061 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -467,7 +467,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_ROMANIA, ETSI1_WORLD, "RO"},
 	{CTRY_RUSSIA, ETSI8_WORLD, "RU"},
 	{CTRY_RWANDA, APL1_WORLD, "RW"},
-	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
+	{CTRY_SAUDI_ARABIA, FCC2_WORLD, "SA"},
 	{CTRY_SERBIA, ETSI1_WORLD, "RS"},
 	{CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
 	{CTRY_SINGAPORE, APL6_WORLD, "SG"},
-- 
2.11.0
