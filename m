Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44451 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031274AbeCAOVB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:01 -0500
Received: by mail-qt0-f193.google.com with SMTP id g60so7663306qtd.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:01 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 13/52] ath: Add regulatory mapping for Uganda
Date: Thu,  1 Mar 2018 15:18:23 +0100
Message-Id: <20180301141902.24824-14-sven.eckelmann@openmesh.com> (sfid-20180301_153349_348192_69FF5602)
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
index 191502ff043d..908163948d59 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -182,6 +182,7 @@ enum CountryCode {
 	CTRY_TUNISIA = 788,
 	CTRY_TURKEY = 792,
 	CTRY_UAE = 784,
+	CTRY_UGANDA = 800,
 	CTRY_UKRAINE = 804,
 	CTRY_UNITED_KINGDOM = 826,
 	CTRY_UNITED_STATES = 840,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 27b1c76e912c..a00be9604d21 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -473,6 +473,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_TRINIDAD_Y_TOBAGO, FCC3_WORLD, "TT"},
 	{CTRY_TUNISIA, ETSI3_WORLD, "TN"},
 	{CTRY_TURKEY, ETSI3_WORLD, "TR"},
+	{CTRY_UGANDA, FCC3_WORLD, "UG"},
 	{CTRY_UKRAINE, NULL1_WORLD, "UA"},
 	{CTRY_UAE, NULL1_WORLD, "AE"},
 	{CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},
-- 
2.11.0
