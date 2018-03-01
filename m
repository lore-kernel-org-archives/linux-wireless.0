Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:45484 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031277AbeCAOU4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:56 -0500
Received: by mail-qt0-f194.google.com with SMTP id v90so7650602qte.12
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:56 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 11/52] ath: Add regulatory mapping for Serbia
Date: Thu,  1 Mar 2018 15:18:21 +0100
Message-Id: <20180301141902.24824-12-sven.eckelmann@openmesh.com> (sfid-20180301_153349_492413_3FF64967)
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
index 3021ba5d7ef5..9fe4857baaae 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -164,6 +164,7 @@ enum CountryCode {
 	CTRY_RUSSIA = 643,
 	CTRY_RWANDA = 646,
 	CTRY_SAUDI_ARABIA = 682,
+	CTRY_SERBIA = 688,
 	CTRY_SERBIA_MONTENEGRO = 891,
 	CTRY_SINGAPORE = 702,
 	CTRY_SLOVAKIA = 703,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 89a3a9104428..4c41308e39c1 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -456,6 +456,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_RUSSIA, NULL1_WORLD, "RU"},
 	{CTRY_RWANDA, APL1_WORLD, "RW"},
 	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
+	{CTRY_SERBIA, ETSI1_WORLD, "RS"},
 	{CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
 	{CTRY_SINGAPORE, APL6_WORLD, "SG"},
 	{CTRY_SLOVAKIA, ETSI1_WORLD, "SK"},
-- 
2.11.0
