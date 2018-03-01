Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33811 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031279AbeCAOV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:58 -0500
Received: by mail-qt0-f196.google.com with SMTP id l25so7715637qtj.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:58 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 36/52] ath: Map Macedonia to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:46 +0100
Message-Id: <20180301141902.24824-37-sven.eckelmann@openmesh.com> (sfid-20180301_152317_811994_BED8D7ED)
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
index 1b69849b4727..f457c9d50bd2 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -439,7 +439,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_LITHUANIA, ETSI1_WORLD, "LT"},
 	{CTRY_LUXEMBOURG, ETSI1_WORLD, "LU"},
 	{CTRY_MACAU, FCC2_WORLD, "MO"},
-	{CTRY_MACEDONIA, NULL1_WORLD, "MK"},
+	{CTRY_MACEDONIA, ETSI1_WORLD, "MK"},
 	{CTRY_MALAYSIA, APL8_WORLD, "MY"},
 	{CTRY_MALTA, ETSI1_WORLD, "MT"},
 	{CTRY_MAURITIUS, ETSI1_WORLD, "MU"},
-- 
2.11.0
