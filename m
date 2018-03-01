Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:44543 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031110AbeCAOUi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:38 -0500
Received: by mail-qk0-f195.google.com with SMTP id v124so7670307qkh.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:38 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 04/52] ath: Add regulatory mapping for Japan KDDI
Date: Thu,  1 Mar 2018 15:18:14 +0100
Message-Id: <20180301141902.24824-5-sven.eckelmann@openmesh.com> (sfid-20180301_152043_760365_DEF5E91C)
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

* 2.4GHz: MKK
* 5GHz: MKK

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd.h        | 1 +
 drivers/net/wireless/ath/regd_common.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index e7b43901d195..a615a878ac40 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -246,6 +246,7 @@ enum CountryCode {
 	CTRY_JAPAN57 = 4057,
 	CTRY_JAPAN58 = 4058,
 	CTRY_JAPAN59 = 4059,
+	CTRY_XA = 4100,
 	CTRY_AUSTRALIA2 = 5000,
 	CTRY_CANADA2 = 5001,
 	CTRY_BELGIUM2 = 5002
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index bba2d156cb21..e430e12f90e8 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -411,6 +411,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_JAPAN57, MKK13_MKKB, "JP"},
 	{CTRY_JAPAN58, MKK14_MKKA1, "JP"},
 	{CTRY_JAPAN59, MKK15_MKKA1, "JP"},
+	{CTRY_XA, MKK5_MKKA2, "XA"},
 
 	{CTRY_JORDAN, ETSI2_WORLD, "JO"},
 	{CTRY_KAZAKHSTAN, NULL1_WORLD, "KZ"},
-- 
2.11.0
