Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43510 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:53 -0500
Received: by mail-qk0-f196.google.com with SMTP id j4so7667459qke.10
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:53 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 34/52] ath: Map South Korea to APL10_MKKC
Date: Thu,  1 Mar 2018 15:18:44 +0100
Message-Id: <20180301141902.24824-35-sven.eckelmann@openmesh.com> (sfid-20180301_152159_663490_FDE2EF4E)
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
index 14cb25ab494d..dee9db074d84 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -429,7 +429,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_KAZAKHSTAN, NULL1_WORLD, "KZ"},
 	{CTRY_KENYA, APL1_WORLD, "KE"},
 	{CTRY_KOREA_NORTH, APL9_MKKC, "KP"},
-	{CTRY_KOREA_ROC, APL9_MKKC, "KR"},
+	{CTRY_KOREA_ROC, APL10_MKKC, "KR"},
 	{CTRY_KOREA_ROC2, APL2_WORLD, "K2"},
 	{CTRY_KOREA_ROC3, APL9_MKKC, "K3"},
 	{CTRY_KUWAIT, ETSI3_WORLD, "KW"},
-- 
2.11.0
