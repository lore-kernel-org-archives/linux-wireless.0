Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46666 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031353AbeCAOVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:23 -0500
Received: by mail-qt0-f193.google.com with SMTP id m13so7662480qtg.13
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:23 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 22/52] ath: Map Albania to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:32 +0100
Message-Id: <20180301141902.24824-23-sven.eckelmann@openmesh.com> (sfid-20180301_152126_764685_EDD8CE43)
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
index c2074b1cd207..bdfbdd4e8583 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -303,7 +303,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_DEBUG, NO_ENUMRD, "DB"},
 	{CTRY_DEFAULT, FCC1_FCCA, "CO"},
-	{CTRY_ALBANIA, NULL1_WORLD, "AL"},
+	{CTRY_ALBANIA, ETSI1_WORLD, "AL"},
 	{CTRY_ALGERIA, NULL1_WORLD, "DZ"},
 	{CTRY_ARGENTINA, FCC3_WORLD, "AR"},
 	{CTRY_ARMENIA, ETSI4_WORLD, "AM"},
-- 
2.11.0
