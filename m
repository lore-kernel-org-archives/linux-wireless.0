Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45630 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:51 -0500
Received: by mail-qt0-f196.google.com with SMTP id v90so7654763qte.12
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:51 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 33/52] ath: Map Japan to MKK5_MKKA2
Date: Thu,  1 Mar 2018 15:18:43 +0100
Message-Id: <20180301141902.24824-34-sven.eckelmann@openmesh.com> (sfid-20180301_152155_305621_394F153C)
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
index 59145decdb2b..14cb25ab494d 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -364,7 +364,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_ITALY, ETSI1_WORLD, "IT"},
 	{CTRY_JAMAICA, FCC3_WORLD, "JM"},
 
-	{CTRY_JAPAN, MKK1_MKKA, "JP"},
+	{CTRY_JAPAN, MKK5_MKKA2, "JP"},
 	{CTRY_JAPAN1, MKK1_MKKB, "JP"},
 	{CTRY_JAPAN2, MKK1_FCCA, "JP"},
 	{CTRY_JAPAN3, MKK2_MKKA, "JP"},
-- 
2.11.0
