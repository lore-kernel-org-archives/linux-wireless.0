Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36752 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031212AbeCAOWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:08 -0500
Received: by mail-qt0-f196.google.com with SMTP id c7so7705718qtn.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:08 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 40/52] ath: Map Pakistan to APL1_WORLD
Date: Thu,  1 Mar 2018 15:18:50 +0100
Message-Id: <20180301141902.24824-41-sven.eckelmann@openmesh.com> (sfid-20180301_152213_353479_510FE1FC)
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
index 6824b1db6d16..1d49300451a8 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -454,7 +454,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_NICARAGUA, FCC3_FCCA, "NI"},
 	{CTRY_NORWAY, ETSI1_WORLD, "NO"},
 	{CTRY_OMAN, FCC3_WORLD, "OM"},
-	{CTRY_PAKISTAN, NULL1_WORLD, "PK"},
+	{CTRY_PAKISTAN, APL1_WORLD, "PK"},
 	{CTRY_PANAMA, FCC1_FCCA, "PA"},
 	{CTRY_PAPUA_NEW_GUINEA, FCC1_WORLD, "PG"},
 	{CTRY_PARAGUAY, FCC3_WORLD, "PY"},
-- 
2.11.0
