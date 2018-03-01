Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36490 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031110AbeCAOUb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:31 -0500
Received: by mail-qt0-f193.google.com with SMTP id c7so7698470qtn.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:31 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 01/52] ath: Add regulatory mapping for Bahamas
Date: Thu,  1 Mar 2018 15:18:11 +0100
Message-Id: <20180301141902.24824-2-sven.eckelmann@openmesh.com> (sfid-20180301_152035_243782_BFE25039)
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
index 5d80be213fac..f296ff838d2a 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -68,6 +68,7 @@ enum CountryCode {
 	CTRY_AUSTRALIA = 36,
 	CTRY_AUSTRIA = 40,
 	CTRY_AZERBAIJAN = 31,
+	CTRY_BAHAMAS = 44,
 	CTRY_BAHRAIN = 48,
 	CTRY_BANGLADESH = 50,
 	CTRY_BARBADOS = 52,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index bdd2b4d61f2f..cde0268cbed6 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -298,6 +298,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_AUSTRALIA2, FCC6_WORLD, "AU"},
 	{CTRY_AUSTRIA, ETSI1_WORLD, "AT"},
 	{CTRY_AZERBAIJAN, ETSI4_WORLD, "AZ"},
+	{CTRY_BAHAMAS, FCC3_WORLD, "BS"},
 	{CTRY_BAHRAIN, APL6_WORLD, "BH"},
 	{CTRY_BANGLADESH, NULL1_WORLD, "BD"},
 	{CTRY_BARBADOS, FCC2_WORLD, "BB"},
-- 
2.11.0
