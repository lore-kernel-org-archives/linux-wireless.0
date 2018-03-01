Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33658 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031275AbeCAOWD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:03 -0500
Received: by mail-qk0-f194.google.com with SMTP id f25so7718846qkm.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:03 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 38/52] ath: Map Mexico to FCC1_WORLD
Date: Thu,  1 Mar 2018 15:18:48 +0100
Message-Id: <20180301141902.24824-39-sven.eckelmann@openmesh.com> (sfid-20180301_152211_022977_04C5CB07)
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

* 2.4GHz: FCC-> ETSI
* 5GHz: FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index efc363af5e41..ca1f07e55aec 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -443,7 +443,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_MALAYSIA, FCC1_WORLD, "MY"},
 	{CTRY_MALTA, ETSI1_WORLD, "MT"},
 	{CTRY_MAURITIUS, ETSI1_WORLD, "MU"},
-	{CTRY_MEXICO, FCC1_FCCA, "MX"},
+	{CTRY_MEXICO, FCC1_WORLD, "MX"},
 	{CTRY_MONACO, ETSI4_WORLD, "MC"},
 	{CTRY_MONTENEGRO, ETSI1_WORLD, "ME"},
 	{CTRY_MOROCCO, APL4_WORLD, "MA"},
-- 
2.11.0
