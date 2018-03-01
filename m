Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44446 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031277AbeCAOU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:58 -0500
Received: by mail-qt0-f193.google.com with SMTP id g60so7663129qtd.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:58 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 12/52] ath: Add regulatory mapping for Tanzania
Date: Thu,  1 Mar 2018 15:18:22 +0100
Message-Id: <20180301141902.24824-13-sven.eckelmann@openmesh.com> (sfid-20180301_153349_009086_50A61665)
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
index 9fe4857baaae..191502ff043d 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -176,6 +176,7 @@ enum CountryCode {
 	CTRY_SWITZERLAND = 756,
 	CTRY_SYRIA = 760,
 	CTRY_TAIWAN = 158,
+	CTRY_TANZANIA = 834,
 	CTRY_THAILAND = 764,
 	CTRY_TRINIDAD_Y_TOBAGO = 780,
 	CTRY_TUNISIA = 788,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 4c41308e39c1..27b1c76e912c 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -468,6 +468,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_SWITZERLAND, ETSI1_WORLD, "CH"},
 	{CTRY_SYRIA, NULL1_WORLD, "SY"},
 	{CTRY_TAIWAN, APL3_FCCA, "TW"},
+	{CTRY_TANZANIA, APL1_WORLD, "TZ"},
 	{CTRY_THAILAND, FCC3_WORLD, "TH"},
 	{CTRY_TRINIDAD_Y_TOBAGO, FCC3_WORLD, "TT"},
 	{CTRY_TUNISIA, ETSI3_WORLD, "TN"},
-- 
2.11.0
