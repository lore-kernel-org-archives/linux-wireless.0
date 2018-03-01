Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36670 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031365AbeCAOVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:36 -0500
Received: by mail-qt0-f196.google.com with SMTP id c7so7703419qtn.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:35 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 27/52] ath: Map Bulgaria to ETSI1_WORLD
Date: Thu,  1 Mar 2018 15:18:37 +0100
Message-Id: <20180301141902.24824-28-sven.eckelmann@openmesh.com> (sfid-20180301_152140_891266_D66E8124)
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
index 4edd4c1d99fa..3a7fbd3794bc 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -325,7 +325,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_BOSNIA_HERZ, ETSI1_WORLD, "BA"},
 	{CTRY_BRAZIL, FCC3_WORLD, "BR"},
 	{CTRY_BRUNEI_DARUSSALAM, APL6_WORLD, "BN"},
-	{CTRY_BULGARIA, ETSI6_WORLD, "BG"},
+	{CTRY_BULGARIA, ETSI1_WORLD, "BG"},
 	{CTRY_CAMBODIA, ETSI1_WORLD, "KH"},
 	{CTRY_CANADA, FCC3_FCCA, "CA"},
 	{CTRY_CANADA2, FCC6_FCCA, "CA"},
-- 
2.11.0
