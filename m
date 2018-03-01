Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38596 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031424AbeCAOW0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:26 -0500
Received: by mail-qt0-f194.google.com with SMTP id n12so7690550qtl.5
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:25 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 47/52] ath: Map Taiwan to APL7_FCCA
Date: Thu,  1 Mar 2018 15:18:57 +0100
Message-Id: <20180301141902.24824-48-sven.eckelmann@openmesh.com> (sfid-20180301_152229_166335_77A91597)
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
index f0b51858b965..a4a55663e58f 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -479,7 +479,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_SWEDEN, ETSI1_WORLD, "SE"},
 	{CTRY_SWITZERLAND, ETSI1_WORLD, "CH"},
 	{CTRY_SYRIA, NULL1_WORLD, "SY"},
-	{CTRY_TAIWAN, APL3_FCCA, "TW"},
+	{CTRY_TAIWAN, APL7_FCCA, "TW"},
 	{CTRY_TANZANIA, APL1_WORLD, "TZ"},
 	{CTRY_THAILAND, FCC3_WORLD, "TH"},
 	{CTRY_TRINIDAD_Y_TOBAGO, FCC3_WORLD, "TT"},
-- 
2.11.0
