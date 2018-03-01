Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36642 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031389AbeCAOV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:56 -0500
Received: by mail-qk0-f195.google.com with SMTP id d206so7690404qkb.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:56 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 35/52] ath: Map Lebanon to APL1_WORLD
Date: Thu,  1 Mar 2018 15:18:45 +0100
Message-Id: <20180301141902.24824-36-sven.eckelmann@openmesh.com> (sfid-20180301_152319_677594_4D6AD3D9)
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
* 5GHz: NO_CTL -> FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index dee9db074d84..1b69849b4727 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -434,7 +434,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_KOREA_ROC3, APL9_MKKC, "K3"},
 	{CTRY_KUWAIT, ETSI3_WORLD, "KW"},
 	{CTRY_LATVIA, ETSI1_WORLD, "LV"},
-	{CTRY_LEBANON, NULL1_WORLD, "LB"},
+	{CTRY_LEBANON, APL1_WORLD, "LB"},
 	{CTRY_LIECHTENSTEIN, ETSI1_WORLD, "LI"},
 	{CTRY_LITHUANIA, ETSI1_WORLD, "LT"},
 	{CTRY_LUXEMBOURG, ETSI1_WORLD, "LU"},
-- 
2.11.0
