Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40162 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031110AbeCAOUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:36 -0500
Received: by mail-qt0-f196.google.com with SMTP id y6so7682518qtm.7
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:36 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 03/52] ath: Add regulatory mapping for Japan (J56)
Date: Thu,  1 Mar 2018 15:18:13 +0100
Message-Id: <20180301141902.24824-4-sven.eckelmann@openmesh.com> (sfid-20180301_152039_737552_37434FC6)
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
* 5GHz: MKK

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index a8c7f306fd7b..bba2d156cb21 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -99,6 +99,7 @@ enum EnumRd {
 	MKK5_MKKB = 0x86,
 	MKK5_MKKA2 = 0x87,
 	MKK5_MKKC = 0x88,
+	MKK5_FCCA = 0x9A,
 
 	MKK6_MKKB = 0x89,
 	MKK6_MKKA2 = 0x8A,
@@ -226,6 +227,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{MKK5_MKKB, CTL_MKK, CTL_MKK},
 	{MKK5_MKKA2, CTL_MKK, CTL_MKK},
 	{MKK5_MKKC, CTL_MKK, CTL_MKK},
+	{MKK5_FCCA, CTL_MKK, CTL_FCC},
 
 	{MKK6_MKKB, CTL_MKK, CTL_MKK},
 	{MKK6_MKKA1, CTL_MKK, CTL_MKK},
@@ -405,6 +407,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_JAPAN52, MKK12_MKKA1, "JP"},
 	{CTRY_JAPAN53, MKK12_MKKC, "JP"},
 	{CTRY_JAPAN54, MKK12_MKKA2, "JP"},
+	{CTRY_JAPAN56, MKK5_FCCA, "JP"},
 	{CTRY_JAPAN57, MKK13_MKKB, "JP"},
 	{CTRY_JAPAN58, MKK14_MKKA1, "JP"},
 	{CTRY_JAPAN59, MKK15_MKKA1, "JP"},
-- 
2.11.0
