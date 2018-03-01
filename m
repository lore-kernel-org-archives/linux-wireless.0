Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40420 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031160AbeCAOWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:15 -0500
Received: by mail-qt0-f195.google.com with SMTP id y6so7689674qtm.7
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:15 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 43/52] ath: Map Romania to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:53 +0100
Message-Id: <20180301141902.24824-44-sven.eckelmann@openmesh.com> (sfid-20180301_152220_724620_801C0EFC)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code is used to select the correct the correct conformance
test limits (CTL) for a country. If the regdomain code isn't correctly
mapped to the actual CTL entries in EEPROM then it could happen that the
device violates the regulations. But it can also happen that the device is
then not able to be used with its full txpower on all rates.

The CTL mappings for this regdomain code were now changed to:

* 2.4GHz: ETSI
* 5GHz: NO_CTL -> ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 66c4a579cb99..0baa028ce7a2 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -464,7 +464,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_PORTUGAL, ETSI1_WORLD, "PT"},
 	{CTRY_PUERTO_RICO, FCC1_FCCA, "PR"},
 	{CTRY_QATAR, APL1_WORLD, "QA"},
-	{CTRY_ROMANIA, NULL1_WORLD, "RO"},
+	{CTRY_ROMANIA, ETSI1_WORLD, "RO"},
 	{CTRY_RUSSIA, NULL1_WORLD, "RU"},
 	{CTRY_RWANDA, APL1_WORLD, "RW"},
 	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
-- 
2.11.0
