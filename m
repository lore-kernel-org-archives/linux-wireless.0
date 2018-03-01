Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:38960 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031212AbeCAOWG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:06 -0500
Received: by mail-qk0-f193.google.com with SMTP id z197so7704873qkb.6
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:06 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 39/52] ath: Map New Zealand to FCC3_ETSIC
Date: Thu,  1 Mar 2018 15:18:49 +0100
Message-Id: <20180301141902.24824-40-sven.eckelmann@openmesh.com> (sfid-20180301_152231_567160_0A559F4C)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code is used to select the correct the correct conformance
test limits (CTL) for a country. If the regdomain code isn't correctly
mapped to the actual CTL entries in EEPROM then it could happen that the
device violates the regulations. But it can also happen that the device is
then not able to be used with its full txpower on all rates.

This change itself doesn't change the selected CTL of this country and is
only required to stay in sync with the QCA mappings.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index ca1f07e55aec..6824b1db6d16 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -450,7 +450,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_NEPAL, APL1_WORLD, "NP"},
 	{CTRY_NETHERLANDS, ETSI1_WORLD, "NL"},
 	{CTRY_NETHERLANDS_ANTILLES, ETSI1_WORLD, "AN"},
-	{CTRY_NEW_ZEALAND, FCC2_ETSIC, "NZ"},
+	{CTRY_NEW_ZEALAND, FCC3_ETSIC, "NZ"},
 	{CTRY_NICARAGUA, FCC3_FCCA, "NI"},
 	{CTRY_NORWAY, ETSI1_WORLD, "NO"},
 	{CTRY_OMAN, FCC3_WORLD, "OM"},
-- 
2.11.0
