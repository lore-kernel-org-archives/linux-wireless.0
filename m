Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43222 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031424AbeCAOWX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:22:23 -0500
Received: by mail-qt0-f193.google.com with SMTP id d26so7682137qtk.10
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:22:23 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 46/52] ath: Map Singapore to FCC3_WORLD
Date: Thu,  1 Mar 2018 15:18:56 +0100
Message-Id: <20180301141902.24824-47-sven.eckelmann@openmesh.com> (sfid-20180301_152226_867864_39FCDA4C)
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
* 5GHz: ETSI -> FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index c20ff7640061..f0b51858b965 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -470,7 +470,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_SAUDI_ARABIA, FCC2_WORLD, "SA"},
 	{CTRY_SERBIA, ETSI1_WORLD, "RS"},
 	{CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
-	{CTRY_SINGAPORE, APL6_WORLD, "SG"},
+	{CTRY_SINGAPORE, FCC3_WORLD, "SG"},
 	{CTRY_SLOVAKIA, ETSI1_WORLD, "SK"},
 	{CTRY_SLOVENIA, ETSI1_WORLD, "SI"},
 	{CTRY_SOUTH_AFRICA, FCC3_WORLD, "ZA"},
-- 
2.11.0
