Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:44732 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:41 -0500
Received: by mail-qk0-f194.google.com with SMTP id v124so7675216qkh.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:41 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 29/52] ath: Map Czech to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:39 +0100
Message-Id: <20180301141902.24824-30-sven.eckelmann@openmesh.com> (sfid-20180301_152146_443516_52FDF27D)
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
index c28347fac774..29021bf28b89 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -335,7 +335,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_COSTA_RICA, FCC1_WORLD, "CR"},
 	{CTRY_CROATIA, ETSI1_WORLD, "HR"},
 	{CTRY_CYPRUS, ETSI1_WORLD, "CY"},
-	{CTRY_CZECH, ETSI3_WORLD, "CZ"},
+	{CTRY_CZECH, ETSI1_WORLD, "CZ"},
 	{CTRY_DENMARK, ETSI1_WORLD, "DK"},
 	{CTRY_DOMINICAN_REPUBLIC, FCC1_FCCA, "DO"},
 	{CTRY_ECUADOR, FCC1_WORLD, "EC"},
-- 
2.11.0
