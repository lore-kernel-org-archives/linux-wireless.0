Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43085 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031365AbeCAOVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:33 -0500
Received: by mail-qt0-f194.google.com with SMTP id d26so7678265qtk.10
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:33 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 26/52] ath: Map Brunei Darussalam to APL6_WORLD
Date: Thu,  1 Mar 2018 15:18:36 +0100
Message-Id: <20180301141902.24824-27-sven.eckelmann@openmesh.com> (sfid-20180301_152138_449118_2AF7AFAF)
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
* 5GHz: FCC -> ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index a5d528367082..4edd4c1d99fa 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -324,7 +324,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_BOLIVIA, APL1_ETSIC, "BO"},
 	{CTRY_BOSNIA_HERZ, ETSI1_WORLD, "BA"},
 	{CTRY_BRAZIL, FCC3_WORLD, "BR"},
-	{CTRY_BRUNEI_DARUSSALAM, APL1_WORLD, "BN"},
+	{CTRY_BRUNEI_DARUSSALAM, APL6_WORLD, "BN"},
 	{CTRY_BULGARIA, ETSI6_WORLD, "BG"},
 	{CTRY_CAMBODIA, ETSI1_WORLD, "KH"},
 	{CTRY_CANADA, FCC3_FCCA, "CA"},
-- 
2.11.0
