Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:42280 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031301AbeCAOUl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:41 -0500
Received: by mail-qk0-f195.google.com with SMTP id b130so7666022qkg.9
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:41 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 05/52] ath: Add regulatory mapping for Kenya
Date: Thu,  1 Mar 2018 15:18:15 +0100
Message-Id: <20180301141902.24824-6-sven.eckelmann@openmesh.com> (sfid-20180301_152044_364735_58FD7490)
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
 drivers/net/wireless/ath/regd_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index e430e12f90e8..bdc1ff191264 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -415,6 +415,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 
 	{CTRY_JORDAN, ETSI2_WORLD, "JO"},
 	{CTRY_KAZAKHSTAN, NULL1_WORLD, "KZ"},
+	{CTRY_KENYA, APL1_WORLD, "KE"},
 	{CTRY_KOREA_NORTH, APL9_WORLD, "KP"},
 	{CTRY_KOREA_ROC, APL9_WORLD, "KR"},
 	{CTRY_KOREA_ROC2, APL2_WORLD, "K2"},
-- 
2.11.0
