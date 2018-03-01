Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43499 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:48 -0500
Received: by mail-qk0-f196.google.com with SMTP id j4so7667085qke.10
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:48 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 32/52] ath: Map Isreal to ETSI3_WORLD
Date: Thu,  1 Mar 2018 15:18:42 +0100
Message-Id: <20180301141902.24824-33-sven.eckelmann@openmesh.com> (sfid-20180301_152152_890202_17B99C2C)
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
index 6a325213c163..59145decdb2b 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -360,7 +360,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_INDONESIA, APL2_WORLD, "ID"},
 	{CTRY_IRAN, APL1_WORLD, "IR"},
 	{CTRY_IRELAND, ETSI1_WORLD, "IE"},
-	{CTRY_ISRAEL, NULL1_WORLD, "IL"},
+	{CTRY_ISRAEL, ETSI3_WORLD, "IL"},
 	{CTRY_ITALY, ETSI1_WORLD, "IT"},
 	{CTRY_JAMAICA, FCC3_WORLD, "JM"},
 
-- 
2.11.0
