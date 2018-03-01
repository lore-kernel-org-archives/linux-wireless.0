Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:38752 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:46 -0500
Received: by mail-qk0-f196.google.com with SMTP id s198so7705925qke.5
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:46 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 31/52] ath: Map Indonesia to APL2_WORLD
Date: Thu,  1 Mar 2018 15:18:41 +0100
Message-Id: <20180301141902.24824-32-sven.eckelmann@openmesh.com> (sfid-20180301_152150_675023_5A564060)
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
index cfa324592271..6a325213c163 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -357,7 +357,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_HUNGARY, ETSI1_WORLD, "HU"},
 	{CTRY_ICELAND, ETSI1_WORLD, "IS"},
 	{CTRY_INDIA, APL6_WORLD, "IN"},
-	{CTRY_INDONESIA, NULL1_WORLD, "ID"},
+	{CTRY_INDONESIA, APL2_WORLD, "ID"},
 	{CTRY_IRAN, APL1_WORLD, "IR"},
 	{CTRY_IRELAND, ETSI1_WORLD, "IE"},
 	{CTRY_ISRAEL, NULL1_WORLD, "IL"},
-- 
2.11.0
