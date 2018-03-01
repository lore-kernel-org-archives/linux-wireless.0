Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:42347 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031274AbeCAOVD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:03 -0500
Received: by mail-qk0-f194.google.com with SMTP id b130so7667732qkg.9
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:03 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 14/52] ath: Add regulatory mapping for United States for AP
Date: Thu,  1 Mar 2018 15:18:24 +0100
Message-Id: <20180301141902.24824-15-sven.eckelmann@openmesh.com> (sfid-20180301_152107_529793_F97914DF)
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

* 2.4GHz: FCC
* 5GHz: FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd.h        | 1 +
 drivers/net/wireless/ath/regd_common.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 908163948d59..490efdcddf93 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -186,6 +186,7 @@ enum CountryCode {
 	CTRY_UKRAINE = 804,
 	CTRY_UNITED_KINGDOM = 826,
 	CTRY_UNITED_STATES = 840,
+	CTRY_UNITED_STATES2 = 841,
 	CTRY_UNITED_STATES_FCC49 = 842,
 	CTRY_URUGUAY = 858,
 	CTRY_UZBEKISTAN = 860,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index a00be9604d21..5cbd76235248 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -478,6 +478,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_UAE, NULL1_WORLD, "AE"},
 	{CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},
 	{CTRY_UNITED_STATES, FCC3_FCCA, "US"},
+	{CTRY_UNITED_STATES2, FCC6_FCCA, "US"},
 	/* This "PS" is for US public safety actually... to support this we
 	 * would need to assign new special alpha2 to CRDA db as with the world
 	 * regdomain and use another alpha2 */
-- 
2.11.0
