Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36979 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031438AbeCAOWb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:31 -0500
Received: by mail-qt0-f194.google.com with SMTP id r16so7698418qtm.4
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:30 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 49/52] ath: Map U.A.E. to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:59 +0100
Message-Id: <20180301141902.24824-50-sven.eckelmann@openmesh.com> (sfid-20180301_152235_569007_7F121764)
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
index e41a0ce332a8..aba44cffce3d 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -487,7 +487,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_TURKEY, ETSI3_WORLD, "TR"},
 	{CTRY_UGANDA, FCC3_WORLD, "UG"},
 	{CTRY_UKRAINE, ETSI9_WORLD, "UA"},
-	{CTRY_UAE, NULL1_WORLD, "AE"},
+	{CTRY_UAE, ETSI1_WORLD, "AE"},
 	{CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},
 	{CTRY_UNITED_STATES, FCC3_FCCA, "US"},
 	{CTRY_UNITED_STATES2, FCC6_FCCA, "US"},
-- 
2.11.0
