Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38554 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031160AbeCAOWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:11 -0500
Received: by mail-qt0-f195.google.com with SMTP id n12so7689478qtl.5
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:10 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 41/52] ath: Map Peru to APL1_WORLD
Date: Thu,  1 Mar 2018 15:18:51 +0100
Message-Id: <20180301141902.24824-42-sven.eckelmann@openmesh.com> (sfid-20180301_152214_034536_689B7B62)
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
index 1d49300451a8..983572ea7048 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -458,7 +458,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_PANAMA, FCC1_FCCA, "PA"},
 	{CTRY_PAPUA_NEW_GUINEA, FCC1_WORLD, "PG"},
 	{CTRY_PARAGUAY, FCC3_WORLD, "PY"},
-	{CTRY_PERU, APL1_WORLD, "PE"},
+	{CTRY_PERU, FCC3_WORLD, "PE"},
 	{CTRY_PHILIPPINES, APL1_WORLD, "PH"},
 	{CTRY_POLAND, ETSI1_WORLD, "PL"},
 	{CTRY_PORTUGAL, ETSI1_WORLD, "PT"},
-- 
2.11.0
