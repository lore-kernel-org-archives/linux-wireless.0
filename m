Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36548 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031353AbeCAOVV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:21 -0500
Received: by mail-qk0-f195.google.com with SMTP id d206so7687844qkb.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:20 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 21/52] ath: Switch APL9_WORLD to 2.4GHz MKK CTL
Date: Thu,  1 Mar 2018 15:18:31 +0100
Message-Id: <20180301141902.24824-22-sven.eckelmann@openmesh.com> (sfid-20180301_152124_936996_E45609BB)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code 0x5E was switched from ETSI conformance test limits
(CTL) on 2.4GHz to MKK. This only affects the different South Korea country
codes.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 447547c25093..c2074b1cd207 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -75,7 +75,7 @@ enum EnumRd {
 	APL6_WORLD = 0x5B,
 	APL7_FCCA = 0x5C,
 	APL8_WORLD = 0x5D,
-	APL9_WORLD = 0x5E,
+	APL9_MKKC = 0x5E,
 	APL10_MKKC = 0x5F,
 
 	WOR0_WORLD = 0x60,
@@ -205,7 +205,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL13_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL6_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL8_WORLD, CTL_ETSI, CTL_ETSI},
-	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
+	{APL9_MKKC, CTL_ETSI, CTL_MKK},
 
 	{APL10_MKKC, CTL_ETSI, CTL_MKK},
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
@@ -428,10 +428,10 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_JORDAN, ETSI2_WORLD, "JO"},
 	{CTRY_KAZAKHSTAN, NULL1_WORLD, "KZ"},
 	{CTRY_KENYA, APL1_WORLD, "KE"},
-	{CTRY_KOREA_NORTH, APL9_WORLD, "KP"},
-	{CTRY_KOREA_ROC, APL9_WORLD, "KR"},
+	{CTRY_KOREA_NORTH, APL9_MKKC, "KP"},
+	{CTRY_KOREA_ROC, APL9_MKKC, "KR"},
 	{CTRY_KOREA_ROC2, APL2_WORLD, "K2"},
-	{CTRY_KOREA_ROC3, APL9_WORLD, "K3"},
+	{CTRY_KOREA_ROC3, APL9_MKKC, "K3"},
 	{CTRY_KUWAIT, ETSI3_WORLD, "KW"},
 	{CTRY_LATVIA, ETSI1_WORLD, "LV"},
 	{CTRY_LEBANON, NULL1_WORLD, "LB"},
-- 
2.11.0
