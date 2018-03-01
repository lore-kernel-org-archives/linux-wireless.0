Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35164 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031278AbeCAOUs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:48 -0500
Received: by mail-qk0-f194.google.com with SMTP id s188so7705214qkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:48 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 08/52] ath: Add regulatory mapping for Nicaragua
Date: Thu,  1 Mar 2018 15:18:18 +0100
Message-Id: <20180301141902.24824-9-sven.eckelmann@openmesh.com> (sfid-20180301_152053_499805_D8049120)
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
 drivers/net/wireless/ath/regd_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index df5db47f2930..11132f4a0aad 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -439,6 +439,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_NETHERLANDS, ETSI1_WORLD, "NL"},
 	{CTRY_NETHERLANDS_ANTILLES, ETSI1_WORLD, "AN"},
 	{CTRY_NEW_ZEALAND, FCC2_ETSIC, "NZ"},
+	{CTRY_NICARAGUA, FCC3_FCCA, "NI"},
 	{CTRY_NORWAY, ETSI1_WORLD, "NO"},
 	{CTRY_OMAN, FCC3_WORLD, "OM"},
 	{CTRY_PAKISTAN, NULL1_WORLD, "PK"},
-- 
2.11.0
