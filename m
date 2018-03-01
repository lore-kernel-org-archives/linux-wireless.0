Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38311 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031280AbeCAOUq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:46 -0500
Received: by mail-qt0-f193.google.com with SMTP id n12so7683193qtl.5
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:46 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 07/52] ath: Add regulatory mapping for Montenegro
Date: Thu,  1 Mar 2018 15:18:17 +0100
Message-Id: <20180301141902.24824-8-sven.eckelmann@openmesh.com> (sfid-20180301_152049_475213_F02A15AB)
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
index f38e42703060..8575718425b6 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -141,6 +141,7 @@ enum CountryCode {
 	CTRY_MAURITIUS = 480,
 	CTRY_MEXICO = 484,
 	CTRY_MONACO = 492,
+	CTRY_MONTENEGRO = 499,
 	CTRY_MOROCCO = 504,
 	CTRY_NEPAL = 524,
 	CTRY_NETHERLANDS = 528,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 375f9da6955b..df5db47f2930 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -433,6 +433,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_MAURITIUS, ETSI1_WORLD, "MU"},
 	{CTRY_MEXICO, FCC1_FCCA, "MX"},
 	{CTRY_MONACO, ETSI4_WORLD, "MC"},
+	{CTRY_MONTENEGRO, ETSI1_WORLD, "ME"},
 	{CTRY_MOROCCO, APL4_WORLD, "MA"},
 	{CTRY_NEPAL, APL1_WORLD, "NP"},
 	{CTRY_NETHERLANDS, ETSI1_WORLD, "NL"},
-- 
2.11.0
