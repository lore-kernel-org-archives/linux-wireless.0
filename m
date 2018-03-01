Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35118 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031110AbeCAOUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:33 -0500
Received: by mail-qk0-f193.google.com with SMTP id s188so7703992qkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:33 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 02/52] ath: Add regulatory mapping for Bermuda
Date: Thu,  1 Mar 2018 15:18:12 +0100
Message-Id: <20180301141902.24824-3-sven.eckelmann@openmesh.com> (sfid-20180301_152037_251549_C5227152)
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
index f296ff838d2a..e7b43901d195 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -75,6 +75,7 @@ enum CountryCode {
 	CTRY_BELARUS = 112,
 	CTRY_BELGIUM = 56,
 	CTRY_BELIZE = 84,
+	CTRY_BERMUDA = 60,
 	CTRY_BOLIVIA = 68,
 	CTRY_BOSNIA_HERZ = 70,
 	CTRY_BRAZIL = 76,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index cde0268cbed6..a8c7f306fd7b 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -306,6 +306,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_BELGIUM, ETSI1_WORLD, "BE"},
 	{CTRY_BELGIUM2, ETSI4_WORLD, "BL"},
 	{CTRY_BELIZE, APL1_ETSIC, "BZ"},
+	{CTRY_BERMUDA, FCC3_FCCA, "BM"},
 	{CTRY_BOLIVIA, APL1_ETSIC, "BO"},
 	{CTRY_BOSNIA_HERZ, ETSI1_WORLD, "BA"},
 	{CTRY_BRAZIL, FCC3_WORLD, "BR"},
-- 
2.11.0
