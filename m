Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:47094 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031353AbeCAOVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:30 -0500
Received: by mail-qk0-f193.google.com with SMTP id 130so7655795qkd.13
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:30 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 25/52] ath: Map Bangladesh to APL1_WORLD
Date: Thu,  1 Mar 2018 15:18:35 +0100
Message-Id: <20180301141902.24824-26-sven.eckelmann@openmesh.com> (sfid-20180301_152136_110181_B83050C3)
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
index 173db6bd1280..a5d528367082 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -314,7 +314,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_AZERBAIJAN, ETSI4_WORLD, "AZ"},
 	{CTRY_BAHAMAS, FCC3_WORLD, "BS"},
 	{CTRY_BAHRAIN, APL6_WORLD, "BH"},
-	{CTRY_BANGLADESH, NULL1_WORLD, "BD"},
+	{CTRY_BANGLADESH, APL1_WORLD, "BD"},
 	{CTRY_BARBADOS, FCC2_WORLD, "BB"},
 	{CTRY_BELARUS, ETSI1_WORLD, "BY"},
 	{CTRY_BELGIUM, ETSI1_WORLD, "BE"},
-- 
2.11.0
