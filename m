Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:42314 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031277AbeCAOUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:53 -0500
Received: by mail-qk0-f193.google.com with SMTP id b130so7666990qkg.9
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:53 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 10/52] ath: Add regulatory mapping for Rwanda
Date: Thu,  1 Mar 2018 15:18:20 +0100
Message-Id: <20180301141902.24824-11-sven.eckelmann@openmesh.com> (sfid-20180301_153349_776380_DD722073)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The country code is used by the ath to detect the ISO 3166-1 alpha-2 name
and to select the correct conformance test limits (CTL) for a country. If
the country isn't available and it is still programmed in the EEPROM then
it will cause an error and stop the initialization with:

  Invalid EEPROM contents

The current CTL mappings for this country are:

* 2.4GHz: ETSI
* 5GHz: FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd.h        | 1 +
 drivers/net/wireless/ath/regd_common.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 8575718425b6..3021ba5d7ef5 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -162,6 +162,7 @@ enum CountryCode {
 	CTRY_QATAR = 634,
 	CTRY_ROMANIA = 642,
 	CTRY_RUSSIA = 643,
+	CTRY_RWANDA = 646,
 	CTRY_SAUDI_ARABIA = 682,
 	CTRY_SERBIA_MONTENEGRO = 891,
 	CTRY_SINGAPORE = 702,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 679c6bc9035e..89a3a9104428 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -454,6 +454,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_QATAR, APL1_WORLD, "QA"},
 	{CTRY_ROMANIA, NULL1_WORLD, "RO"},
 	{CTRY_RUSSIA, NULL1_WORLD, "RU"},
+	{CTRY_RWANDA, APL1_WORLD, "RW"},
 	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
 	{CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
 	{CTRY_SINGAPORE, APL6_WORLD, "SG"},
-- 
2.11.0
