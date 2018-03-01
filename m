Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:39806 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031181AbeCAOVo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:44 -0500
Received: by mail-qt0-f193.google.com with SMTP id f4so7675235qtj.6
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:43 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 30/52] ath: Map Honduras to FCC3_WORLD
Date: Thu,  1 Mar 2018 15:18:40 +0100
Message-Id: <20180301141902.24824-31-sven.eckelmann@openmesh.com> (sfid-20180301_152147_896736_17338503)
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
index 29021bf28b89..cfa324592271 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -352,7 +352,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_GUAM, FCC1_FCCA, "GU"},
 	{CTRY_GUATEMALA, FCC1_FCCA, "GT"},
 	{CTRY_HAITI, ETSI1_WORLD, "HT"},
-	{CTRY_HONDURAS, NULL1_WORLD, "HN"},
+	{CTRY_HONDURAS, FCC3_WORLD, "HN"},
 	{CTRY_HONG_KONG, FCC3_WORLD, "HK"},
 	{CTRY_HUNGARY, ETSI1_WORLD, "HU"},
 	{CTRY_ICELAND, ETSI1_WORLD, "IS"},
-- 
2.11.0
