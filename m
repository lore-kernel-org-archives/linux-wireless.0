Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:41826 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031437AbeCAOWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:33 -0500
Received: by mail-qk0-f196.google.com with SMTP id w142so7689280qkb.8
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:33 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 50/52] ath: Map Venezuela to FCC1_WORLD
Date: Thu,  1 Mar 2018 15:19:00 +0100
Message-Id: <20180301141902.24824-51-sven.eckelmann@openmesh.com> (sfid-20180301_153349_190070_BD051EA2)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code is used to select the correct the correct conformance
test limits (CTL) for a country. If the regdomain code isn't correctly
mapped to the actual CTL entries in EEPROM then it could happen that the
device violates the regulations. But it can also happen that the device is
then not able to be used with its full txpower on all rates.

This change itself doesn't change the selected CTL of this country and is
only required to stay in sync with the QCA mappings.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index aba44cffce3d..d22eff3fe75b 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -497,7 +497,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_UNITED_STATES_FCC49, FCC4_FCCA, "PS"},
 	{CTRY_URUGUAY, FCC3_WORLD, "UY"},
 	{CTRY_UZBEKISTAN, FCC3_FCCA, "UZ"},
-	{CTRY_VENEZUELA, APL2_ETSIC, "VE"},
+	{CTRY_VENEZUELA, FCC1_WORLD, "VE"},
 	{CTRY_VIET_NAM, NULL1_WORLD, "VN"},
 	{CTRY_YEMEN, NULL1_WORLD, "YE"},
 	{CTRY_ZIMBABWE, NULL1_WORLD, "ZW"},
-- 
2.11.0
