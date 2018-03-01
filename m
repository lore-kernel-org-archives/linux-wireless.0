Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34746 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031371AbeCAOV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:28 -0500
Received: by mail-qt0-f196.google.com with SMTP id l25so7713301qtj.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:28 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 24/52] ath: Map Australia to FCC3_WORLD
Date: Thu,  1 Mar 2018 15:18:34 +0100
Message-Id: <20180301141902.24824-25-sven.eckelmann@openmesh.com> (sfid-20180301_152133_759198_8C45C3DC)
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
index 984039073aea..173db6bd1280 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -308,7 +308,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_ARGENTINA, FCC3_WORLD, "AR"},
 	{CTRY_ARMENIA, ETSI4_WORLD, "AM"},
 	{CTRY_ARUBA, ETSI1_WORLD, "AW"},
-	{CTRY_AUSTRALIA, FCC2_WORLD, "AU"},
+	{CTRY_AUSTRALIA, FCC3_WORLD, "AU"},
 	{CTRY_AUSTRALIA2, FCC6_WORLD, "AU"},
 	{CTRY_AUSTRIA, ETSI1_WORLD, "AT"},
 	{CTRY_AZERBAIJAN, ETSI4_WORLD, "AZ"},
-- 
2.11.0
