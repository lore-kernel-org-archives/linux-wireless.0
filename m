Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:45939 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031301AbeCAOUn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:43 -0500
Received: by mail-qk0-f195.google.com with SMTP id g2so7667274qkd.12
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:43 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 06/52] ath: Add regulatory mapping for Mauritius
Date: Thu,  1 Mar 2018 15:18:16 +0100
Message-Id: <20180301141902.24824-7-sven.eckelmann@openmesh.com> (sfid-20180301_152046_977922_B5C2BC6F)
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
* 5GHz: ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd.h        | 1 +
 drivers/net/wireless/ath/regd_common.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index a615a878ac40..f38e42703060 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -138,6 +138,7 @@ enum CountryCode {
 	CTRY_MACEDONIA = 807,
 	CTRY_MALAYSIA = 458,
 	CTRY_MALTA = 470,
+	CTRY_MAURITIUS = 480,
 	CTRY_MEXICO = 484,
 	CTRY_MONACO = 492,
 	CTRY_MOROCCO = 504,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index bdc1ff191264..375f9da6955b 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -430,6 +430,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_MACEDONIA, NULL1_WORLD, "MK"},
 	{CTRY_MALAYSIA, APL8_WORLD, "MY"},
 	{CTRY_MALTA, ETSI1_WORLD, "MT"},
+	{CTRY_MAURITIUS, ETSI1_WORLD, "MU"},
 	{CTRY_MEXICO, FCC1_FCCA, "MX"},
 	{CTRY_MONACO, ETSI4_WORLD, "MC"},
 	{CTRY_MOROCCO, APL4_WORLD, "MA"},
-- 
2.11.0
