Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40194 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031278AbeCAOUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:51 -0500
Received: by mail-qt0-f193.google.com with SMTP id y6so7683535qtm.7
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:51 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 09/52] ath: Add regulatory mapping for Paraguya
Date: Thu,  1 Mar 2018 15:18:19 +0100
Message-Id: <20180301141902.24824-10-sven.eckelmann@openmesh.com> (sfid-20180301_152055_043233_B4320056)
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
index 11132f4a0aad..679c6bc9035e 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -445,6 +445,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_PAKISTAN, NULL1_WORLD, "PK"},
 	{CTRY_PANAMA, FCC1_FCCA, "PA"},
 	{CTRY_PAPUA_NEW_GUINEA, FCC1_WORLD, "PG"},
+	{CTRY_PARAGUAY, FCC3_WORLD, "PY"},
 	{CTRY_PERU, APL1_WORLD, "PE"},
 	{CTRY_PHILIPPINES, APL1_WORLD, "PH"},
 	{CTRY_POLAND, ETSI1_WORLD, "PL"},
-- 
2.11.0
